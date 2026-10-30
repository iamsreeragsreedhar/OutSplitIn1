import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class NetworkService {
  final Connectivity _connectivity;
  final StreamController<bool> _connectivityStreamController =
      StreamController<bool>.broadcast();

  final ValueNotifier<bool> isConnectedNotifier = ValueNotifier<bool>(true);

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _lastKnownConnected = true;

  NetworkService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity() {
    _init();
  }

  bool get isConnected => isConnectedNotifier.value;

  Stream<bool> get onConnectivityChanged =>
      _connectivityStreamController.stream;

  void _init() {
    // Initial check on startup
    checkIsConnected();

    // Listen to network interface changes
    _subscription = _connectivity.onConnectivityChanged.listen((results) async {
      final isOffline = results.isEmpty ||
          (results.contains(ConnectivityResult.none) &&
              !results.any((r) =>
                  r == ConnectivityResult.wifi ||
                  r == ConnectivityResult.mobile ||
                  r == ConnectivityResult.ethernet));

      if (isOffline) {
        _updateStatus(false);
      } else {
        final hasInternet = await _checkRealInternetAccess();
        _updateStatus(hasInternet);
      }
    });
  }

  void _updateStatus(bool connected) {
    if (_lastKnownConnected != connected || isConnectedNotifier.value != connected) {
      _lastKnownConnected = connected;
      isConnectedNotifier.value = connected;
      _connectivityStreamController.add(connected);
    }
  }

  /// Verifies if the device actually has internet connectivity
  Future<bool> checkIsConnected() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final isOffline = results.isEmpty ||
          (results.contains(ConnectivityResult.none) &&
              !results.any((r) =>
                  r == ConnectivityResult.wifi ||
                  r == ConnectivityResult.mobile ||
                  r == ConnectivityResult.ethernet));

      if (isOffline) {
        _updateStatus(false);
        return false;
      }

      final hasInternet = await _checkRealInternetAccess();
      _updateStatus(hasInternet);
      return hasInternet;
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      return _lastKnownConnected;
    }
  }

  Future<bool> _checkRealInternetAccess() async {
    if (kIsWeb) return true;
    try {
      final lookup = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 6));
      return lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty;
    } catch (_) {
      try {
        final fallback = await InternetAddress.lookup('cloudflare.com')
            .timeout(const Duration(seconds: 6));
        return fallback.isNotEmpty && fallback[0].rawAddress.isNotEmpty;
      } catch (_) {
        return false;
      }
    }
  }

  void dispose() {
    _subscription?.cancel();
    _connectivityStreamController.close();
    isConnectedNotifier.dispose();
  }
}
