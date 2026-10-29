import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'package:out_split_in/core/services/firebase_services.dart';
import 'package:out_split_in/core/sms/sms_parser.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';

class UpiNotificationService {
  final FirebaseServices _firebaseServices;
  final FirebaseAuth _auth;

  StreamSubscription<ServiceNotificationEvent>? _subscription;
  final _onTransactionDetectedController =
      StreamController<TransactionModel>.broadcast();

  Stream<TransactionModel> get onTransactionDetected =>
      _onTransactionDetectedController.stream;

  bool _isListening = false;
  bool get isListening => _isListening;

  UpiNotificationService({
    FirebaseServices? firebaseServices,
    FirebaseAuth? auth,
  }) : _firebaseServices = firebaseServices ?? FirebaseServices(),
       _auth = auth ?? FirebaseAuth.instance;

  /// Known payment and banking packages in India / UPI ecosystem
  static const Set<String> supportedPaymentPackages = {
    // UPI apps
    'com.google.android.apps.nbu.paisa.user', // Google Pay
    'com.phonepe.app', // PhonePe
    'net.one97.paytm', // Paytm
    'com.dreamplug.androidapp', // CRED
    'in.org.npci.upiapp', // BHIM
    'com.amazon.mShop.android.shopping', // Amazon Pay
    'com.whatsapp', // WhatsApp Pay
    // Indian Bank & Neobank apps
    'com.hdfcbank.android', // HDFC Bank / PayZapp
    'com.icicibank.mobile', // ICICI iMobile
    'com.sbi.lotusintouch', // YONO SBI
    'com.axis.mobile', // Axis Mobile
    'com.msf.kbank.mobile', // Kotak 811
    'com.bankofbaroda.mconnect', // bob World
    'com.fampay.in', // FamPay
    'club.jupiter', // Jupiter
    'money.fi', // Fi Money
    'in.slice', // Slice
    // SMS & Messaging apps (intercepts bank SMS notifications without READ_SMS permission)
    'com.google.android.apps.messaging', // Google Messages
    'com.samsung.android.messaging', // Samsung Messages
    'com.android.mms', // Stock Android SMS
    'com.truecaller', // Truecaller
    // OEM SMS packages (OnePlus, Oppo, Realme, Xiaomi, Vivo)
    'com.oneplus.mms', // OnePlus Messages
    'com.coloros.mms', // Oppo / ColorOS Messages
    'com.heytap.mms', // Realme / HeyTap Messages
    'com.oppo.mms', // Oppo Messages
    'com.miui.sms-extra', // Xiaomi / MIUI Messages
    'com.vivo.mms', // Vivo Messages
    'com.bbk.mms', // BBK / Vivo Messages
  };

  /// Check if the user has granted Notification Listener access in Android Settings
  Future<bool> isPermissionGranted() async {
    if (!Platform.isAndroid) return false;
    try {
      return await NotificationListenerService.isPermissionGranted();
    } catch (e) {
      debugPrint('Error checking notification permission: $e');
      return false;
    }
  }

  /// Request Notification Listener permission by redirecting the user to System Settings
  Future<bool> requestPermission() async {
    if (!Platform.isAndroid) return false;
    try {
      return await NotificationListenerService.requestPermission();
    } catch (e) {
      debugPrint('Error requesting notification permission: $e');
      return false;
    }
  }

  /// Start listening to live notification stream from UPI and banking apps
  Future<bool> startListening() async {
    if (!Platform.isAndroid) return false;

    final hasPermission = await isPermissionGranted();
    if (!hasPermission) {
      debugPrint('Notification permission is not granted yet.');
      return false;
    }

    if (_isListening && _subscription != null) {
      return true;
    }

    try {
      _subscription = NotificationListenerService.notificationsStream.listen(
        _handleNotificationEvent,
        onError: (error) {
          debugPrint('NotificationListener stream error: $error');
        },
      );
      _isListening = true;
      debugPrint('UPI Notification listener started successfully.');
      return true;
    } catch (e) {
      debugPrint('Error starting notification listener: $e');
      _isListening = false;
      return false;
    }
  }

  /// Stop listening to notifications
  Future<void> stopListening() async {
    await _subscription?.cancel();
    _subscription = null;
    _isListening = false;
    debugPrint('UPI Notification listener stopped.');
  }

  /// Process incoming notification event
  Future<void> _handleNotificationEvent(ServiceNotificationEvent event) async {
    // Ignore removed, empty, or ongoing notifications (like music player or background downloads)
    if (event.hasRemoved || event.onGoing) return;

    final packageName = event.packageName.trim();
    final title = event.title.trim();
    final content = event.content.trim();

    if (title.isEmpty && content.isEmpty) return;

    final combinedText = '$title $content';
    final lower = combinedText.toLowerCase();

    // Check if the notification comes from a known payment app or contains payment keywords
    final isKnownPackage = supportedPaymentPackages.contains(packageName);
    final hasPaymentKeywords = RegExp(
      r'\b(debited|credited|paid|spent|sent|received|transfer|payment|upi|vpa|dr|cr|txn|refund|cashback|re\.?|rs\.?)\b',
      caseSensitive: false,
    ).hasMatch(lower);

    if (!isKnownPackage && !hasPaymentKeywords) {
      return;
    }

    debugPrint(
      'Payment notification candidate from $packageName: "$combinedText"',
    );

    final senderName = _friendlyAppName(packageName, title);
    final notifTime = event.humanTime;
    final uniqueSmsId =
        'notif_${packageName.hashCode}_${event.timestamp}_${title.hashCode}';

    // Parse transaction using SmsParser
    final transaction = SmsParser.parse(
      body: combinedText,
      message: combinedText,
      sender: senderName,
      date: notifTime,
      smsDate: notifTime,
      smsId: uniqueSmsId,
    );

    if (transaction == null) {
      debugPrint(
        'Notification could not be parsed as a financial transaction.',
      );
      return;
    }

    // Ensure user is authenticated before saving
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint('User is not authenticated. Transaction skipped.');
      return;
    }

    try {
      final saved = await _firebaseServices.saveIfNotExists(
        transaction: transaction,
      );
      if (saved) {
        debugPrint(
          'Auto-detected payment saved: ${transaction.type.name.toUpperCase()} ₹${transaction.amount} at ${transaction.title}',
        );
        _onTransactionDetectedController.add(transaction);
      } else {
        debugPrint('Duplicate payment notification ignored: ${transaction.id}');
      }
    } catch (e) {
      debugPrint('Error saving auto-detected transaction: $e');
    }
  }

  /// Maps package names to user-friendly source labels
  String _friendlyAppName(String packageName, String title) {
    switch (packageName) {
      case 'com.google.android.apps.nbu.paisa.user':
        return 'Google Pay';
      case 'com.phonepe.app':
        return 'PhonePe';
      case 'net.one97.paytm':
        return 'Paytm';
      case 'com.dreamplug.androidapp':
        return 'CRED';
      case 'in.org.npci.upiapp':
        return 'BHIM';
      case 'com.amazon.mShop.android.shopping':
        return 'Amazon Pay';
      case 'com.hdfcbank.android':
        return 'HDFC Bank';
      case 'com.icicibank.mobile':
        return 'ICICI Bank';
      case 'com.sbi.lotusintouch':
        return 'SBI';
      case 'com.axis.mobile':
        return 'Axis Bank';
      case 'com.msf.kbank.mobile':
        return 'Kotak Bank';
      case 'club.jupiter':
        return 'Jupiter';
      case 'money.fi':
        return 'Fi Money';
      case 'in.slice':
        return 'Slice';
      case 'com.google.android.apps.messaging':
      case 'com.samsung.android.messaging':
      case 'com.android.mms':
      case 'com.truecaller':
      case 'com.oneplus.mms':
      case 'com.coloros.mms':
      case 'com.heytap.mms':
      case 'com.oppo.mms':
      case 'com.miui.sms-extra':
      case 'com.vivo.mms':
      case 'com.bbk.mms':
        return 'SMS Alert';
      default:
        final cleanTitle = title.trim();
        final lower = cleanTitle.toLowerCase();
        if (cleanTitle.isNotEmpty &&
            !lower.startsWith('view') &&
            !lower.startsWith('tap') &&
            !lower.startsWith('click') &&
            !lower.contains('details') &&
            !lower.contains('notification') &&
            !cleanTitle.contains('---')) {
          return cleanTitle;
        }
        return 'UPI Payment';
    }
  }

  void dispose() {
    stopListening();
    _onTransactionDetectedController.close();
  }
}
