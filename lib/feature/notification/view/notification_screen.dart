import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:out_split_in/core/shared_widgets/app_fade_slide.dart';
import 'package:out_split_in/core/shared_widgets/snackbar.dart';
import 'package:out_split_in/feature/notification/view_model/notification/notification_bloc.dart';
import 'package:out_split_in/feature/notification/view_model/notification/notification_event.dart';
import 'package:out_split_in/feature/notification/view_model/notification/notification_state.dart';
import 'package:out_split_in/feature/notification/widgets/notification_empty_view.dart';
import 'package:out_split_in/feature/notification/widgets/notification_filter_tabs.dart';
import 'package:out_split_in/feature/notification/widgets/notification_tile.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(const LoadNotificationsEvent());
  }

  void _confirmClearAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear Notifications'),
          content: const Text(
            'Are you sure you want to delete all notifications?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE05A62),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                context
                    .read<NotificationBloc>()
                    .add(const ClearAllNotificationsEvent());
                AppSnackbar.info(context, 'All notifications cleared');
              },
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (value) {
              if (value == 'mark_read') {
                context
                    .read<NotificationBloc>()
                    .add(const MarkAllNotificationsReadEvent());
                AppSnackbar.success(context, 'Marked all as read');
              } else if (value == 'clear_all') {
                _confirmClearAll(context);
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'mark_read',
                child: Row(
                  children: [
                    Icon(Icons.done_all_rounded, size: 18),
                    SizedBox(width: 10),
                    Text('Mark all as read'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep_rounded, size: 18, color: Color(0xFFE05A62)),
                    SizedBox(width: 10),
                    Text('Clear all', style: TextStyle(color: Color(0xFFE05A62))),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state.status == NotificationStatus.loading &&
                state.notifications.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final filteredList = state.filteredNotifications;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppFadeSlide(
                        direction: SlideDirection.fromTop,
                        child: NotificationFilterTabs(
                          selectedCategory: state.selectedCategory,
                          onCategoryChanged: (cat) {
                            context
                                .read<NotificationBloc>()
                                .add(FilterNotificationCategoryEvent(cat));
                          },
                        ),
                      ),
                      const SizedBox(height: 14),
                      Expanded(
                        child: filteredList.isEmpty
                            ? const NotificationEmptyView()
                            : RefreshIndicator(
                                onRefresh: () async {
                                  context
                                      .read<NotificationBloc>()
                                      .add(const LoadNotificationsEvent());
                                },
                                child: ListView.separated(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: filteredList.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(height: 10),
                                  itemBuilder: (context, index) {
                                    final notif = filteredList[index];
                                    return AppFadeSlide(
                                      delay: Duration(
                                        milliseconds:
                                            (index.clamp(0, 10)) * 30,
                                      ),
                                      direction: SlideDirection.fromBottom,
                                      child: NotificationTile(
                                        notification: notif,
                                        onTap: () {
                                          if (!notif.isRead) {
                                            context
                                                .read<NotificationBloc>()
                                                .add(
                                                  MarkNotificationReadEvent(
                                                    notif.id,
                                                  ),
                                                );
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
