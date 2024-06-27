import 'package:flutter_projects/data/datasources/project_datasource.dart';
import 'package:flutter_projects/domain/model/notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationProvider = StateNotifierProvider<NotificationNotifier,
    Map<int, List<NotificationModel>>>((ref) {
  return NotificationNotifier();
});

final notificationsViewedProvider = StateProvider<bool>((ref) => false);

class NotificationNotifier
    extends StateNotifier<Map<int, List<NotificationModel>>> {
  NotificationNotifier() : super({});

  Future<void> addNotification(int projectId, String message) async {
    final notification = NotificationModel(
      projectId: projectId,
      message: message,
      isRead: false,
      id: 0,
    );
    print('notification ------- $notification');
    final newNotification =
        await ProjectDataSource.instance.create(notification);

    final List<NotificationModel> notifications =
        state[projectId]?.toList() ?? [];
    notifications.add(newNotification);

    state = {
      ...state,
      projectId: notifications,
    };
  }

  Future<void> updateNotification(NotificationModel updatedNotification) async {
    await ProjectDataSource.instance.update(updatedNotification);

    final projectId = updatedNotification.projectId;
    final notifications = state[projectId] ?? [];

    final updatedNotifications = notifications.map((notification) {
      return notification.id == updatedNotification.id
          ? updatedNotification
          : notification;
    }).toList();

    state = {
      ...state,
      projectId: updatedNotifications,
    };
  }

  int get count {
    int count = 0;
    state.forEach((key, value) => count += value.length);
    return count;
  }

  Future<int> getCountOfUnreadNotifications() async {
    int unreadCount = 0;
    for (var notifications in state.values) {
      unreadCount +=
          notifications.where((notification) => !notification.isRead).length;
    }
    return unreadCount;
  }
}
