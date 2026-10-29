import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:out_split_in/feature/notification/services/notification_service.dart';
import 'package:out_split_in/feature/notification/view_model/notification/notification_event.dart';
import 'package:out_split_in/feature/notification/view_model/notification/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService notificationService;

  NotificationBloc({required this.notificationService})
      : super(const NotificationState()) {
    on<LoadNotificationsEvent>(_onLoadNotifications);
    on<AddNotificationEvent>(_onAddNotification);
    on<MarkNotificationReadEvent>(_onMarkNotificationRead);
    on<MarkAllNotificationsReadEvent>(_onMarkAllNotificationsRead);
    on<ClearAllNotificationsEvent>(_onClearAllNotifications);
    on<FilterNotificationCategoryEvent>(_onFilterNotificationCategory);
  }

  Future<void> _onLoadNotifications(
    LoadNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(status: NotificationStatus.loading));
    try {
      final list = await notificationService.getNotifications();
      emit(
        state.copyWith(
          notifications: list,
          status: NotificationStatus.loaded,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NotificationStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAddNotification(
    AddNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await notificationService.saveNotification(event.notification);
      final list = await notificationService.getNotifications();
      emit(
        state.copyWith(
          notifications: list,
          status: NotificationStatus.loaded,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NotificationStatus.error,
          errorMessage: 'Failed to add notification: $e',
        ),
      );
    }
  }

  Future<void> _onMarkNotificationRead(
    MarkNotificationReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await notificationService.markAsRead(event.notificationId);
      final list = await notificationService.getNotifications();
      emit(
        state.copyWith(
          notifications: list,
          status: NotificationStatus.loaded,
        ),
      );
    } catch (_) {}
  }

  Future<void> _onMarkAllNotificationsRead(
    MarkAllNotificationsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await notificationService.markAllAsRead();
      final list = await notificationService.getNotifications();
      emit(
        state.copyWith(
          notifications: list,
          status: NotificationStatus.loaded,
        ),
      );
    } catch (_) {}
  }

  Future<void> _onClearAllNotifications(
    ClearAllNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await notificationService.clearAll();
      emit(
        state.copyWith(
          notifications: const [],
          status: NotificationStatus.loaded,
        ),
      );
    } catch (_) {}
  }

  void _onFilterNotificationCategory(
    FilterNotificationCategoryEvent event,
    Emitter<NotificationState> emit,
  ) {
    if (event.category == null) {
      emit(state.copyWith(clearCategoryFilter: true));
    } else {
      emit(state.copyWith(selectedCategory: event.category));
    }
  }
}
