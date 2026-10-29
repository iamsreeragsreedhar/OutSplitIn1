import 'dart:convert';
import 'package:out_split_in/feature/notification/model/app_notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static const String _notificationsKey = 'app_notifications_v1';

  Future<List<AppNotificationModel>> getNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_notificationsKey);
      if (jsonString == null || jsonString.isEmpty) {
        return _seedInitialNotifications();
      }

      final decoded = jsonDecode(jsonString) as List<dynamic>;
      final list = decoded
          .map((item) => AppNotificationModel.fromMap(item as Map<String, dynamic>))
          .toList();

      list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return list;
    } catch (_) {
      return _seedInitialNotifications();
    }
  }

  Future<void> saveNotification(AppNotificationModel notification) async {
    final list = await getNotifications();
    list.removeWhere((n) => n.id == notification.id);
    list.insert(0, notification);

    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(list.map((n) => n.toMap()).toList());
    await prefs.setString(_notificationsKey, encoded);
  }

  Future<void> markAsRead(String id) async {
    final list = await getNotifications();
    final index = list.indexWhere((n) => n.id == id);
    if (index != -1) {
      list[index] = list[index].copyWith(isRead: true);
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(list.map((n) => n.toMap()).toList());
      await prefs.setString(_notificationsKey, encoded);
    }
  }

  Future<void> markAllAsRead() async {
    final list = await getNotifications();
    final updated = list.map((n) => n.copyWith(isRead: true)).toList();
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(updated.map((n) => n.toMap()).toList());
    await prefs.setString(_notificationsKey, encoded);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notificationsKey);
  }

  List<AppNotificationModel> _seedInitialNotifications() {
    return [
      AppNotificationModel(
        id: 'notif_welcome',
        title: 'Welcome to OutSplitIn! 🎉',
        body: 'Automatic UPI payment tracking and offline backup are active.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        category: NotificationCategory.system,
        isRead: false,
      ),
    ];
  }
}
