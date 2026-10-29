import 'package:equatable/equatable.dart';
import 'package:out_split_in/feature/notification/model/app_notification_model.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotificationsEvent extends NotificationEvent {
  const LoadNotificationsEvent();
}

class AddNotificationEvent extends NotificationEvent {
  final AppNotificationModel notification;

  const AddNotificationEvent(this.notification);

  @override
  List<Object?> get props => [notification];
}

class MarkNotificationReadEvent extends NotificationEvent {
  final String notificationId;

  const MarkNotificationReadEvent(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class MarkAllNotificationsReadEvent extends NotificationEvent {
  const MarkAllNotificationsReadEvent();
}

class ClearAllNotificationsEvent extends NotificationEvent {
  const ClearAllNotificationsEvent();
}

class FilterNotificationCategoryEvent extends NotificationEvent {
  final NotificationCategory? category;

  const FilterNotificationCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}
