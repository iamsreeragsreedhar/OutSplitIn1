import 'package:equatable/equatable.dart';
import 'package:out_split_in/feature/notification/model/app_notification_model.dart';

enum NotificationStatus { initial, loading, loaded, error }

class NotificationState extends Equatable {
  final List<AppNotificationModel> notifications;
  final NotificationCategory? selectedCategory;
  final NotificationStatus status;
  final String? errorMessage;

  const NotificationState({
    this.notifications = const [],
    this.selectedCategory,
    this.status = NotificationStatus.initial,
    this.errorMessage,
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  List<AppNotificationModel> get filteredNotifications {
    if (selectedCategory == null) return notifications;
    return notifications
        .where((n) => n.category == selectedCategory)
        .toList();
  }

  NotificationState copyWith({
    List<AppNotificationModel>? notifications,
    NotificationCategory? selectedCategory,
    bool clearCategoryFilter = false,
    NotificationStatus? status,
    String? errorMessage,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      selectedCategory: clearCategoryFilter
          ? null
          : (selectedCategory ?? this.selectedCategory),
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        notifications,
        selectedCategory,
        status,
        errorMessage,
      ];
}
