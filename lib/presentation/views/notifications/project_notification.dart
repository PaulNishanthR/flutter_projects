// // import 'package:flutter/material.dart';
// // import 'package:flutter_projects/domain/model/project.dart';
// // import 'package:flutter_projects/presentation/providers/notification_provider.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';

// // class ProjectMessagesPage extends ConsumerStatefulWidget {
// //   final Project project;

// //   const ProjectMessagesPage({super.key, required this.project});

// //   @override
// //   ConsumerState<ProjectMessagesPage> createState() =>
// //       _ProjectMessagesPageState();
// // }

// // class _ProjectMessagesPageState extends ConsumerState<ProjectMessagesPage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     final notifications =
// //         ref.watch(notificationProvider)[widget.project.id] ?? [];
// //     print('notifications $notifications');
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Messages for ${widget.project.projectName}'),
// //         backgroundColor: Colors.lightBlue,
// //         elevation: 0,
// //       ),
// //       body: notifications.isNotEmpty
// //           ? ListView.builder(
// //               itemCount: notifications.length,
// //               itemBuilder: (context, index) {
// //                 return ListTile(
// //                   title: Text(notifications[index]),
// //                 );
// //               },
// //             )
// //           : Center(
// //               child: Text(
// //                 'No messages for ${widget.project.projectName}',
// //                 style: const TextStyle(fontSize: 18),
// //               ),
// //             ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_projects/domain/model/project.dart';
// import 'package:flutter_projects/presentation/providers/notification_provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ProjectMessagesPage extends ConsumerStatefulWidget {
//   final Project project;

//   const ProjectMessagesPage({super.key, required this.project});

//   @override
//   ConsumerState<ProjectMessagesPage> createState() =>
//       _ProjectMessagesPageState();
// }

// class _ProjectMessagesPageState extends ConsumerState<ProjectMessagesPage> {
//   @override
//   Widget build(BuildContext context) {
//     final notifications =
//         ref.watch(notificationProvider)[widget.project.id] ?? [];
//     print('notifications $notifications');
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notifications'),
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: notifications.isNotEmpty
//             ? ListView.builder(
//                 itemCount: notifications.length,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8.0),
//                     elevation: 2,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: ListTile(
//                       leading: Icon(
//                         Icons.notifications,
//                         color: Colors.purple.shade300,
//                       ),
//                       title: Text(
//                         notifications[index],
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               )
//             : Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(
//                       Icons.notifications_off,
//                       size: 80,
//                       color: Colors.grey,
//                     ),
//                     const SizedBox(height: 20),
//                     Text(
//                       'No messages for ${widget.project.projectName}',
//                       style: const TextStyle(fontSize: 18, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_projects/domain/model/project/project.dart';
import 'package:flutter_projects/presentation/providers/project/notification_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectMessagesPage extends ConsumerStatefulWidget {
  final Project project;

  const ProjectMessagesPage({super.key, required this.project});

  @override
  ConsumerState<ProjectMessagesPage> createState() =>
      _ProjectMessagesPageState();
}

// class _ProjectMessagesPageState extends ConsumerState<ProjectMessagesPage> {
//   @override
//   Widget build(BuildContext context) {
//     final notifications =
//         ref.watch(notificationProvider)[widget.project.id] ?? [];
//     print('notifications $notifications');
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notifications'),
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: notifications.isNotEmpty
//             ? ListView.builder(
//                 itemCount: notifications.length,
//                 itemBuilder: (context, index) {
//                   final notification = notifications[index];
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8.0),
//                     elevation: 2,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: ListTile(
//                       leading: Icon(
//                         Icons.notifications,
//                         color: Colors.purple.shade300,
//                       ),
//                       title: Text(
//                         notification.message,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       subtitle: Text(
//                         notification.isRead ? 'Read' : 'Unread',
//                         style: const TextStyle(
//                           color: Colors.grey,
//                         ),
//                       ),
//                       trailing: IconButton(
//                         icon: Icon(
//                           notification.isRead
//                               ? Icons.mark_email_read
//                               : Icons.mark_email_unread,
//                           color:
//                               notification.isRead ? Colors.green : Colors.red,
//                         ),
//                         onPressed: () async {
//                           print('POO       - ${widget.project.id}');
//                           await ref
//                               .read(notificationProvider.notifier)
//                               .updateNotification(widget.project.id!);
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               )
//             : Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(
//                       Icons.notifications_off,
//                       size: 80,
//                       color: Colors.grey,
//                     ),
//                     const SizedBox(height: 20),
//                     Text(
//                       'No messages for ${widget.project.projectName}',
//                       style: const TextStyle(fontSize: 18, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }
class _ProjectMessagesPageState extends ConsumerState<ProjectMessagesPage> {
  // @override
  // void initState() {
  //   super.initState();
  //   _markNotificationsAsRead();
  // }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _markNotificationsAsRead();
  }

  Future<void> _markNotificationsAsRead() async {
    final notifications = ref.watch(notificationProvider);
    final projectNotifications = notifications
        .where((notification) => notification.projectId == widget.project.id)
        .toList();

    for (var notification in projectNotifications) {
      if (!notification.isRead) {
        await ref
            .read(notificationProvider.notifier)
            .updateNotification(notification.id, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationProvider);
    final projectNotifications = notifications
        .where((notification) => notification.projectId == widget.project.id)
        .toList();

    print('notifications $projectNotifications');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: projectNotifications.isNotEmpty
            ? ListView.builder(
                itemCount: projectNotifications.length,
                itemBuilder: (context, index) {
                  final notification = projectNotifications[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.notifications,
                        color: Colors.purple.shade300,
                      ),
                      title: Text(
                        notification.message,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // subtitle: Text(
                      //   notification.isRead ? 'Read' : 'Unread',
                      //   style: const TextStyle(
                      //     color: Colors.grey,
                      //   ),
                      // ),
                      trailing: IconButton(
                        icon: Icon(
                          notification.isRead
                              ? Icons.mark_email_read
                              : Icons.mark_email_unread,
                          color:
                              notification.isRead ? Colors.green : Colors.red,
                        ),
                        onPressed: () async {},
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.notifications_off,
                      size: 80,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No messages for ${widget.project.projectName}',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
