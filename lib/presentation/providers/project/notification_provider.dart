// import 'package:flutter_projects/data/datasources/project_datasource.dart';
// import 'package:flutter_projects/domain/model/notification.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final notificationProvider =
//     StateNotifierProvider<NotificationNotifier, List<NotificationModel>>((ref) {
//   return NotificationNotifier();
// });

// // final notificationsViewedProvider = StateProvider<bool>((ref) => false);

// class NotificationNotifier extends StateNotifier<List<NotificationModel>> {
//   NotificationNotifier() : super(state);

//   Future<void> addNotification(int projectId, String message) async {
//     final notification = NotificationModel(
//       projectId: projectId,
//       message: message,
//       isRead: false,
//       id: 0,
//     );
//     print('notification ------- $notification');
//     final newNotification =
//         await ProjectDataSource.instance.create(notification);

//     final List<NotificationModel> notifications =
//         state[projectId]?.toList() ?? [];
//     notifications.add(newNotification);

//     state = {
//       ...state,
//       projectId: notifications,
//     };
//   }

//   Future<void> updateNotification(int projectId) async {
//     // for (NotificationModel model in state) {}

//     await ProjectDataSource.instance.update(projectId);

//     // final projectId = updatedNotification.projectId;
//     // final notifications = state[projectId] ?? [];

//     // final updatedNotifications = notifications.map((notification) {
//     //   return notification.id == updatedNotification.id
//     //       ? updatedNotification
//     //       : notification;
//     // }).toList();

//     // state = {
//     //   ...state,
//     //   projectId: updatedNotifications,
//     // };
//   }

//   int get count {
//     int count = 0;
//     state.forEach((key, value) => count += value.length);
//     return count;
//   }

//   Future<int> getCountOfUnreadNotifications() async {
//     int unreadCount = 0;
//     for (var notifications in state.values) {
//       unreadCount +=
//           notifications.where((notification) => !notification.isRead).length;
//     }
//     return unreadCount;
//   }
// }

import 'package:flutter_projects/data/datasources/project_datasource.dart';
import 'package:flutter_projects/domain/model/notification/notification.dart';
import 'package:flutter_projects/utils/constants/custom_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/database_project_impl.dart';
import '../../../domain/repositories/project_repository.dart';

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, List<NotificationModel>>((ref) {
  return NotificationNotifier(ref.watch(notificationRepositoryProvider));
});

final notificationRepositoryProvider = Provider<ProjectRepository>((ref) {
  return DatabaseProjectRepository(ref.read(databaseHelperProvider));
});

final databaseHelperProvider = Provider<ProjectDataSource>((ref) {
  return ProjectDataSource.instance;
});

class NotificationNotifier extends StateNotifier<List<NotificationModel>> {
  final ProjectRepository _repository;

  NotificationNotifier(this._repository) : super([]);

  // Future<void> addNotification(int projectId, String message) async {
  //   final notification = NotificationModel(
  //     projectId: projectId,
  //     message: message,
  //     isRead: false,
  //     id: 0,
  //   );
  //   print('notification ------- $notification');
  //   final newNotification =
  //       await ProjectDataSource.instance.create(notification);
  //   final List<NotificationModel> notifications = [...state];
  //   notifications.add(newNotification);
  //   state = notifications;
  // }

  Future<void> addNotification(int projectId, String message) async {
    final notification = NotificationModel(
      projectId: projectId,
      message: message,
      isRead: false,
      id: 0,
    );

    final newNotification =
        await ProjectDataSource.instance.create(notification);
    state = [...state, newNotification];
  }

  Future<void> updateNotification(int notificationId, bool isRead) async {
    await ProjectDataSource.instance.update(notificationId);

    final updatedNotifications = state.map((notification) {
      return notification.id == notificationId
          ? notification.copyWith(isRead: isRead)
          : notification;
    }).toList();

    state = updatedNotifications;
  }

  int get count {
    return state.length;
  }

  // Future<int> getCountOfUnreadNotifications() async {
  //   int unreadCount = 0;
  //   for (var notification in state) {
  //     if (!notification.isRead) {
  //       unreadCount++;
  //     }
  //   }
  //   return unreadCount;
  // }

  Future<int> getCountOfUnreadNotifications() async {
    try {
      final int unreadCount = await _repository.getCountOfUnreadNotifications();
      print('unreadCount ---- $unreadCount');
      return unreadCount;
    } catch (e) {
      throw CustomException('message');
    }
  }
}
