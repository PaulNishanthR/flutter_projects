// // import 'package:flutter/material.dart';
// // import 'package:flutter_projects/data/datasources/project_datasource.dart';
// // import 'package:flutter_projects/domain/model/project.dart';
// // import 'package:flutter_projects/domain/model/task.dart';
// // import 'package:flutter_projects/presentation/providers/lang_provider.dart';
// // import 'package:flutter_projects/presentation/providers/project_provider.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:flutter_projects/presentation/views/login.dart';
// // import 'package:flutter_projects/presentation/providers/notification_provider.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// // class HomeForMember extends ConsumerStatefulWidget {
// //   final String memberName;

// //   const HomeForMember({Key? key, required this.memberName}) : super(key: key);

// //   @override
// //   ConsumerState<HomeForMember> createState() => _HomeForMemberState();
// // }

// // class _HomeForMemberState extends ConsumerState<HomeForMember>
// //     with SingleTickerProviderStateMixin {
// //   late TabController _tabController;
// //   List<Project> assignedProjects = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _tabController = TabController(length: 3, vsync: this);
// //   }

// //   @override
// //   void dispose() {
// //     _tabController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   void didChangeDependencies() {
// //     load();
// //     // fetchAssignedProjectsAndTasks();
// //     super.didChangeDependencies();
// //   }

// //   void load() {
// //     fetchAssignedProjectsAndTasks();
// //   }

// //   Future<void> fetchAssignedProjectsAndTasks() async {
// //     try {
// //       final List<Project> projects = await ref
// //           .watch(projectsProvider.notifier)
// //           .getProjectsAndTasksForTeamMember(
// //             widget.memberName.split('@').first.toLowerCase(),
// //           );
// //       print('Fetched projects: ${projects.map((p) => p.projectName)}');
// //       for (var project in projects) {
// //         for (var task in project.tasks) {
// //           await task.loadStatusFromPrefs(widget.memberName);
// //         }
// //       }
// //       setState(() {
// //         assignedProjects = projects;
// //       });
// //     } catch (e) {
// //       print("Error fetching assigned projects: $e");
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final userNamePrefix = widget.memberName.split('@').first;

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(AppLocalizations.of(context)!.ksProjectHub),
// //         automaticallyImplyLeading: false,
// //         leading: PopupMenuButton<Locale>(
// //           icon: const Icon(Icons.translate),
// //           onSelected: (Locale selectedLocale) {
// //             ref.read(languageProvider.notifier).changeLocale(selectedLocale);
// //             _showToastMessage(context, selectedLocale);
// //           },
// //           itemBuilder: (BuildContext context) => [
// //             const PopupMenuItem<Locale>(
// //               value: Locale('en'),
// //               child: Row(
// //                 children: [
// //                   Icon(Icons.translate, color: Colors.blue),
// //                   SizedBox(width: 10),
// //                   Text('English'),
// //                 ],
// //               ),
// //             ),
// //             const PopupMenuItem<Locale>(
// //               value: Locale('ta'),
// //               child: Row(
// //                 children: [
// //                   Icon(Icons.translate, color: Colors.green),
// //                   SizedBox(width: 10),
// //                   Text('தமிழ்'),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.exit_to_app),
// //             onPressed: () {
// //               Navigator.pushReplacement(
// //                 context,
// //                 MaterialPageRoute(builder: (_) => const LoginScreen()),
// //               );
// //             },
// //           ),
// //         ],
// //         centerTitle: true,
// //       ),
// //       body: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   '${AppLocalizations.of(context)!.welcomewithoutcomma}, $userNamePrefix!',
// //                   style: const TextStyle(
// //                       fontSize: 24, fontWeight: FontWeight.bold),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 Text(
// //                   "You're assigned to, ${assignedProjects[0].projectName.toUpperCase()}",
// //                   style: const TextStyle(
// //                       fontSize: 18, fontWeight: FontWeight.normal),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 TabBar(
// //                   indicatorColor: Colors.black,
// //                   controller: _tabController,
// //                   tabs: const [
// //                     Row(
// //                       children: [
// //                         Icon(
// //                           Icons.all_inbox,
// //                           color: Colors.black,
// //                         ),
// //                         Tab(
// //                           child: Text(
// //                             'All',
// //                             style: TextStyle(color: Colors.black),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     Row(
// //                       children: [
// //                         Icon(
// //                           Icons.pending,
// //                           color: Colors.black,
// //                         ),
// //                         Tab(
// //                           // text: 'Progress',
// //                           child: Text(
// //                             'Progress',
// //                             style: TextStyle(color: Colors.black),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     Row(
// //                       children: [
// //                         Icon(
// //                           Icons.done_all,
// //                           color: Colors.black,
// //                         ),
// //                         Tab(
// //                           // text: 'Done',
// //                           child: Text(
// //                             'Done',
// //                             style: TextStyle(color: Colors.black),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Expanded(
// //             child: TabBarView(
// //               controller: _tabController,
// //               children: [
// //                 _buildTaskList(UserStatus.values, context),
// //                 _buildTaskList([UserStatus.onProgress], context),
// //                 _buildTaskList([UserStatus.done], context),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Future<void> _updateMemberStatus(
// //       Task task, String member, UserStatus newStatus) async {
// //     try {
// //       final normalizedMember =
// //           widget.memberName.split('@').first.toLowerCase().trim();
// //       print(
// //           "Updating status for task: ${task.taskName}, member: $normalizedMember");

// //       setState(() {
// //         task.updateUserStatus(member, newStatus);
// //       });
// //       await task.saveStatusToPrefs(member, newStatus);

// //       await ProjectDataSource.instance.updateTaskStatus(
// //         assignedProjects[0].id!,
// //         task.taskName,
// //         member,
// //         newStatus,
// //       );

// //       final message =
// //           '$normalizedMember changed Task status to ${newStatus.toString().split('.').last} for task ${task.taskName}';
// //       ref.read(notificationProvider.notifier).addNotification(
// //             assignedProjects[0].id!,
// //             message,
// //           );
// //       _showNotification(
// //           'Member status updated to ${newStatus.toString().split('.').last}');
// //     } catch (e) {
// //       print("Error updating member status: $e");
// //     }
// //   }

// //   void _showNotification(String message) {
// //     Fluttertoast.showToast(
// //       msg: message,
// //       toastLength: Toast.LENGTH_SHORT,
// //       gravity: ToastGravity.BOTTOM,
// //       timeInSecForIosWeb: 1,
// //       backgroundColor: Colors.black,
// //       textColor: Colors.white,
// //       fontSize: 16.0,
// //     );
// //   }

// //   Widget _buildTaskList(List<UserStatus> filterStatuses, BuildContext context) {
// //     List<Task> filteredTasks = [];

// //     for (var project in assignedProjects) {
// //       for (var task in project.tasks) {
// //         // if (filterStatuses.contains(task.memberStatuses[widget.memberName])) {
// //         filteredTasks.add(task);
// //         task.loadStatusFromPrefs(widget.memberName);
// //         // }
// //       }
// //     }

// //     return filteredTasks.isEmpty
// //         ? const Center(
// //             child: Text(
// //               'No tasks found for selected status.',
// //               style: TextStyle(fontSize: 18, color: Colors.grey),
// //             ),
// //           )
// //         : ListView.builder(
// //             padding: const EdgeInsets.all(16.0),
// //             itemCount: filteredTasks.length,
// //             itemBuilder: (context, index) {
// //               final task = filteredTasks[index];

// //               // IconData priorityIcon = Icons.info;
// //               Color priorityColor = Colors.black;
// //               Color cardColor = Colors.white;

// //               switch (task.taskPriority) {
// //                 case TaskPriority.low:
// //                   // priorityIcon = Icons.arrow_downward;
// //                   priorityColor = Colors.green;
// //                   cardColor = Colors.green[50]!;
// //                   break;
// //                 case TaskPriority.medium:
// //                   // priorityIcon = Icons.circle;
// //                   priorityColor = Colors.orange;
// //                   cardColor = Colors.orange[50]!;
// //                   break;
// //                 case TaskPriority.high:
// //                   // priorityIcon = Icons.warning;
// //                   priorityColor = Colors.red;
// //                   cardColor = Colors.red[50]!;
// //                   break;
// //                 default:
// //                   break;
// //               }

// //               return Container(
// //                 margin:
// //                     const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22),
// //                 decoration: BoxDecoration(
// //                   color: cardColor,
// //                   borderRadius: BorderRadius.circular(10),
// //                   border: Border.all(color: priorityColor, width: 1),
// //                 ),
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(16.0),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           Text(
// //                             '${AppLocalizations.of(context)!.taskName} : ${task.taskName.toUpperCase()}',
// //                             style: const TextStyle(
// //                               fontSize: 16,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 8),
// //                       Text(
// //                         '${AppLocalizations.of(context)!.taskDescription} : ${task.description}',
// //                         style: const TextStyle(fontSize: 14),
// //                       ),
// //                       const SizedBox(height: 8),
// //                       Text(
// //                         '${AppLocalizations.of(context)!.duedate}: ${_formatDate(task.dueDate)}',
// //                         style:
// //                             const TextStyle(fontSize: 12, color: Colors.black),
// //                       ),
// //                       const SizedBox(height: 8),
// //                       Row(
// //                         children: [
// //                           Text(
// //                             '${AppLocalizations.of(context)!.status}: ',
// //                             style: const TextStyle(
// //                               fontSize: 12,
// //                               color: Colors.black,
// //                             ),
// //                           ),
// //                           Text(
// //                             task.memberStatuses[widget.memberName]
// //                                     ?.toString()
// //                                     .split('.')
// //                                     .last ??
// //                                 'Not Started',
// //                             style: const TextStyle(
// //                               fontSize: 12,
// //                               color: Colors.black,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 8),
// //                       Row(
// //                         children: [
// //                           Text(
// //                             'Priority: ${task.taskPriority.toString().split('.').last}',
// //                             style: const TextStyle(
// //                               fontSize: 12,
// //                               color: Colors.black,
// //                             ),
// //                           ),
// //                           // Icon(
// //                           //   priorityIcon,
// //                           //   color: priorityColor,
// //                           //   size: 16,
// //                           // ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 8),
// //                       DropdownButton<UserStatus>(
// //                         value: task.memberStatuses[widget.memberName],
// //                         items: UserStatus.values.map((UserStatus status) {
// //                           return DropdownMenuItem<UserStatus>(
// //                             value: status,
// //                             child: Text(status.toString().split('.').last),
// //                           );
// //                         }).toList(),
// //                         onChanged: (UserStatus? newValue) {
// //                           if (newValue != null) {
// //                             _updateMemberStatus(
// //                                 task, widget.memberName, newValue);
// //                           }
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               );
// //             },
// //           );
// //   }

// //   String _formatDate(DateTime date) {
// //     return '${date.day}-${date.month}-${date.year}';
// //   }

// //   void _showToastMessage(BuildContext context, Locale locale) {
// //     String message;
// //     if (locale.languageCode == 'en') {
// //       message = 'Language changed to English';
// //     } else if (locale.languageCode == 'ta') {
// //       message = 'மொழி தமிழுக்கு மாற்றப்பட்டது';
// //     } else {
// //       message = 'Language changed';
// //     }

// //     Fluttertoast.showToast(
// //       msg: message,
// //       toastLength: Toast.LENGTH_SHORT,
// //       gravity: ToastGravity.BOTTOM,
// //       timeInSecForIosWeb: 1,
// //       backgroundColor: Colors.black,
// //       textColor: Colors.white,
// //       fontSize: 16.0,
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_projects/data/datasources/project_datasource.dart';
// import 'package:flutter_projects/domain/model/project.dart';
// import 'package:flutter_projects/domain/model/task.dart';
// import 'package:flutter_projects/presentation/providers/lang_provider.dart';
// import 'package:flutter_projects/presentation/providers/project_provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_projects/presentation/views/login.dart';
// import 'package:flutter_projects/presentation/providers/notification_provider.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class HomeForMember extends ConsumerStatefulWidget {
//   final String memberName;

//   const HomeForMember({Key? key, required this.memberName}) : super(key: key);

//   @override
//   ConsumerState<HomeForMember> createState() => _HomeForMemberState();
// }

// class _HomeForMemberState extends ConsumerState<HomeForMember>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   List<Project> assignedProjects = [];
//   List<Task> allTasks = [];
//   List<Task> progressTasks = [];
//   List<Task> doneTasks = [];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     fetchAssignedProjectsAndTasks();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<void> fetchAssignedProjectsAndTasks() async {
//     try {
//       final List<Project> projects = await ref
//           .watch(projectsProvider.notifier)
//           .getProjectsAndTasksForTeamMember(
//             widget.memberName.split('@').first.toLowerCase(),
//           );
//       for (var project in projects) {
//         for (var task in project.tasks) {
//           await task.loadStatusFromPrefs(widget.memberName);
//           final status = task.memberStatuses[widget.memberName];
//           allTasks.add(task);
//           if (status == UserStatus.onProgress) {
//             progressTasks.add(task);
//           } else if (status == UserStatus.done) {
//             doneTasks.add(task);
//           }
//         }
//       }
//       setState(() {
//         assignedProjects = projects;
//       });
//     } catch (e) {
//       print("Error fetching assigned projects: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userNamePrefix = widget.memberName.split('@').first;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.ksProjectHub),
//         automaticallyImplyLeading: false,
//         leading: PopupMenuButton<Locale>(
//           icon: const Icon(Icons.translate),
//           onSelected: (Locale selectedLocale) {
//             ref.read(languageProvider.notifier).changeLocale(selectedLocale);
//             _showToastMessage(context, selectedLocale);
//           },
//           itemBuilder: (BuildContext context) => [
//             const PopupMenuItem<Locale>(
//               value: Locale('en'),
//               child: Row(
//                 children: [
//                   Icon(Icons.translate, color: Colors.blue),
//                   SizedBox(width: 10),
//                   Text('English'),
//                 ],
//               ),
//             ),
//             const PopupMenuItem<Locale>(
//               value: Locale('ta'),
//               child: Row(
//                 children: [
//                   Icon(Icons.translate, color: Colors.green),
//                   SizedBox(width: 10),
//                   Text('தமிழ்'),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.exit_to_app),
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => const LoginScreen()),
//               );
//             },
//           ),
//         ],
//         centerTitle: true,
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '${AppLocalizations.of(context)!.welcomewithoutcomma}, $userNamePrefix!',
//                   style: const TextStyle(
//                       fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   "You're assigned to, ${assignedProjects.isNotEmpty ? assignedProjects[0].projectName.toUpperCase() : 'No Project'}",
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.normal),
//                 ),
//                 const SizedBox(height: 8),
//                 TabBar(
//                   indicatorColor: Colors.black,
//                   controller: _tabController,
//                   tabs: const [
//                     Tab(
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.all_inbox,
//                             color: Colors.black,
//                           ),
//                           Text(
//                             'All',
//                             style: TextStyle(color: Colors.black),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Tab(
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.pending,
//                             color: Colors.black,
//                           ),
//                           Text(
//                             'Progress',
//                             style: TextStyle(color: Colors.black),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Tab(
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.done_all,
//                             color: Colors.black,
//                           ),
//                           Text(
//                             'Done',
//                             style: TextStyle(color: Colors.black),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildTaskList(allTasks, context),
//                 _buildTaskList(progressTasks, context),
//                 _buildTaskList(doneTasks, context),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _updateMemberStatus(
//       Task task, String member, UserStatus newStatus) async {
//     try {
//       final normalizedMember =
//           widget.memberName.split('@').first.toLowerCase().trim();
//       print(
//           "Updating status for task: ${task.taskName}, member: $normalizedMember");

//       setState(() {
//         task.updateUserStatus(member, newStatus);
//         if (newStatus == UserStatus.onProgress) {
//           if (!progressTasks.contains(task)) {
//             progressTasks.add(task);
//             doneTasks.remove(task);
//           }
//         } else if (newStatus == UserStatus.done) {
//           if (!doneTasks.contains(task)) {
//             doneTasks.add(task);
//             progressTasks.remove(task);
//           }
//         }
//       });
//       await task.saveStatusToPrefs(member, newStatus);

//       await ProjectDataSource.instance.updateTaskStatus(
//         assignedProjects[0].id!,
//         task.taskName,
//         member,
//         newStatus,
//       );

//       final message =
//           '$normalizedMember changed Task status to ${newStatus.toString().split('.').last} for task ${task.taskName}';
//       ref.read(notificationProvider.notifier).addNotification(
//             assignedProjects[0].id!,
//             message,
//           );
//       _showNotification(
//           'Member status updated to ${newStatus.toString().split('.').last}');
//     } catch (e) {
//       print("Error updating member status: $e");
//     }
//   }

//   void _showNotification(String message) {
//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.black,
//       textColor: Colors.white,
//       fontSize: 16.0,
//     );
//   }

//   Widget _buildTaskList(List<Task> tasks, BuildContext context) {
//     return tasks.isEmpty
//         ? const Center(
//             child: Text(
//               'No tasks found for selected status.',
//               style: TextStyle(fontSize: 18, color: Colors.grey),
//             ),
//           )
//         : ListView.builder(
//             padding: const EdgeInsets.all(16.0),
//             itemCount: tasks.length,
//             itemBuilder: (context, index) {
//               final task = tasks[index];

//               // IconData priorityIcon = Icons.info;
//               Color priorityColor = Colors.black;
//               Color cardColor = Colors.white;

//               switch (task.taskPriority) {
//                 case TaskPriority.low:
//                   // priorityIcon = Icons.arrow_downward;
//                   priorityColor = Colors.green;
//                   cardColor = Colors.green[50]!;
//                   break;
//                 case TaskPriority.medium:
//                   // priorityIcon = Icons.circle;
//                   priorityColor = Colors.orange;
//                   cardColor = Colors.orange[50]!;
//                   break;
//                 case TaskPriority.high:
//                   // priorityIcon = Icons.warning;
//                   priorityColor = Colors.red;
//                   cardColor = Colors.red[50]!;
//                   break;
//                 default:
//                   break;
//               }

//               return Container(
//                 margin:
//                     const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22),
//                 decoration: BoxDecoration(
//                   color: cardColor,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: priorityColor, width: 2),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           const Icon(
//                             Icons.task,
//                             color: Colors.black,
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             task.taskName,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         '${AppLocalizations.of(context)!.taskDescription} : ${task.description}',
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         '${AppLocalizations.of(context)!.duedate}: ${_formatDate(task.dueDate)}',
//                         style:
//                             const TextStyle(fontSize: 12, color: Colors.black),
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Text(
//                             '${AppLocalizations.of(context)!.status}: ',
//                             style: const TextStyle(
//                               fontSize: 12,
//                               color: Colors.black,
//                             ),
//                           ),
//                           Text(
//                             task.memberStatuses[widget.memberName]
//                                     ?.toString()
//                                     .split('.')
//                                     .last ??
//                                 'Not Started',
//                             style: const TextStyle(
//                               fontSize: 12,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Text(
//                             'Priority: ${task.taskPriority.toString().split('.').last}',
//                             style: const TextStyle(
//                               fontSize: 12,
//                               color: Colors.black,
//                             ),
//                           ),
//                           // Icon(
//                           //   priorityIcon,
//                           //   color: priorityColor,
//                           //   size: 16,
//                           // ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       DropdownButton<UserStatus>(
//                         value: task.memberStatuses[widget.memberName],
//                         items: UserStatus.values.map((UserStatus status) {
//                           return DropdownMenuItem<UserStatus>(
//                             value: status,
//                             child: Text(status.toString().split('.').last),
//                           );
//                         }).toList(),
//                         onChanged: (UserStatus? newValue) {
//                           if (newValue != null) {
//                             _updateMemberStatus(
//                                 task, widget.memberName, newValue);
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}-${date.month}-${date.year}';
//   }

//   void _showToastMessage(BuildContext context, Locale locale) {
//     String message;
//     if (locale.languageCode == 'en') {
//       message = 'Language changed to English';
//     } else if (locale.languageCode == 'ta') {
//       message = 'மொழி தமிழுக்கு மாற்றப்பட்டது';
//     } else {
//       message = 'Language changed';
//     }

//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.black,
//       textColor: Colors.white,
//       fontSize: 16.0,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_projects/data/datasources/project_datasource.dart';
import 'package:flutter_projects/domain/model/project/project.dart';
import 'package:flutter_projects/domain/model/project/task.dart';
import 'package:flutter_projects/presentation/providers/language/lang_provider.dart';
import 'package:flutter_projects/presentation/providers/project/project_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_projects/presentation/views/auth_pages/login.dart';
import 'package:flutter_projects/presentation/providers/project/notification_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeForMember extends ConsumerStatefulWidget {
  final String memberName;

  const HomeForMember({Key? key, required this.memberName}) : super(key: key);

  @override
  ConsumerState<HomeForMember> createState() => _HomeForMemberState();
}

class _HomeForMemberState extends ConsumerState<HomeForMember>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Project> assignedProjects = [];
  List<Task> allTasks = [];
  List<Task> progressTasks = [];
  List<Task> doneTasks = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchAssignedProjectsAndTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchAssignedProjectsAndTasks() async {
    try {
      allTasks.clear();
      progressTasks.clear();
      doneTasks.clear();

      final List<Project> projects = await ref
          .watch(projectsProvider.notifier)
          .getProjectsAndTasksForTeamMember(
            widget.memberName.split('@').first.toLowerCase(),
          );
      for (var project in projects) {
        for (var task in project.tasks) {
          await task.loadStatusFromPrefs(widget.memberName);
          final status = task.memberStatuses[widget.memberName];
          allTasks.add(task);
          if (status == UserStatus.onProgress) {
            progressTasks.add(task);
          } else if (status == UserStatus.done) {
            doneTasks.add(task);
          }
        }
      }
      setState(() {
        assignedProjects = projects;
      });
    } catch (e) {
      print("Error fetching assigned projects: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final userNamePrefix = widget.memberName.split('@').first;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.ksProjectHub),
        automaticallyImplyLeading: false,
        leading: PopupMenuButton<Locale>(
          icon: const Icon(Icons.translate),
          onSelected: (Locale selectedLocale) {
            ref.read(languageProvider.notifier).changeLocale(selectedLocale);
            _showToastMessage(context, selectedLocale);
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<Locale>(
              value: Locale('en'),
              child: Row(
                children: [
                  Icon(Icons.translate, color: Colors.black),
                  SizedBox(width: 10),
                  Text('English'),
                ],
              ),
            ),
            const PopupMenuItem<Locale>(
              value: Locale('ta'),
              child: Row(
                children: [
                  Icon(Icons.translate, color: Colors.black),
                  SizedBox(width: 10),
                  Text('தமிழ்'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    '${AppLocalizations.of(context)!.welcomewithoutcomma}, $userNamePrefix!',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                if (assignedProjects.isEmpty)
                  Center(
                    child: Text(AppLocalizations.of(context)!.noprojects),
                  ),
                if (assignedProjects.isNotEmpty)
                  Center(
                    child: Text(
                      "${AppLocalizations.of(context)!.yourProjects} ${assignedProjects[0].projectName.toUpperCase()}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                  ),
                const SizedBox(height: 8),
                TabBar(
                  indicatorColor: Colors.black,
                  controller: _tabController,
                  tabs: [
                    Tab(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.all_inbox,
                            color: Colors.black,
                          ),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.all,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.pending,
                            color: Colors.black,
                          ),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.progress,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.done_all,
                            color: Colors.black,
                          ),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.done,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTaskList(allTasks, context),
                _buildTaskList(progressTasks, context),
                _buildTaskList(doneTasks, context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateMemberStatus(
      Task task, String member, UserStatus newStatus) async {
    try {
      final normalizedMember =
          widget.memberName.split('@').first.toLowerCase().trim();
      print(
          "Updating status for task: ${task.taskName}, member: $normalizedMember");

      setState(() {
        task.updateUserStatus(member, newStatus);
        if (newStatus == UserStatus.onProgress) {
          if (!progressTasks.contains(task)) {
            progressTasks.add(task);
            doneTasks.remove(task);
          }
        } else if (newStatus == UserStatus.done) {
          if (!doneTasks.contains(task)) {
            doneTasks.add(task);
            progressTasks.remove(task);
          }
        }
      });
      await task.saveStatusToPrefs(member, newStatus);

      await ProjectDataSource.instance.updateTaskStatus(
        assignedProjects[0].id!,
        task.taskName,
        member,
        newStatus,
      );

      final message =
          '$normalizedMember changed Task status to ${newStatus.toString().split('.').last} for task ${task.taskName}';
      ref.read(notificationProvider.notifier).addNotification(
            assignedProjects[0].id!,
            message,
          );
      _showNotification(
          'Member status updated to ${newStatus.toString().split('.').last}');
    } catch (e) {
      print("Error updating member status: $e");
    }
  }

  void _showNotification(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Widget _buildTaskList(List<Task> tasks, BuildContext context) {
    return tasks.isEmpty
        ? const Center(
            child: Text(
              'No tasks found for selected status.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              Color priorityColor = Colors.black;
              Color cardColor = Colors.white;

              switch (task.taskPriority) {
                case TaskPriority.low:
                  priorityColor = Colors.green;
                  cardColor = Colors.green[50]!;
                  break;
                case TaskPriority.medium:
                  priorityColor = Colors.orange;
                  cardColor = Colors.orange[50]!;
                  break;
                case TaskPriority.high:
                  priorityColor = Colors.red;
                  cardColor = Colors.red[50]!;
                  break;
                default:
                  break;
              }

              final TaskStatus =
                  task.memberStatuses[widget.memberName] ?? UserStatus.todo;

              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: priorityColor, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.task,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            task.taskName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${AppLocalizations.of(context)!.taskDescription} : ${task.description}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${AppLocalizations.of(context)!.duedate}: ${_formatDate(task.dueDate)}',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '${AppLocalizations.of(context)!.status}: ',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            task.memberStatuses[widget.memberName]
                                    ?.toString()
                                    .split('.')
                                    .last ??
                                'Not Started',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '${AppLocalizations.of(context)!.priority}: ${task.taskPriority.toString().split('.').last}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: priorityColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<UserStatus>(
                        // value: task.memberStatuses[widget.memberName],
                        value: TaskStatus,
                        items: UserStatus.values.map((UserStatus status) {
                          return DropdownMenuItem<UserStatus>(
                            value: status,
                            child: Text(status.toString().split('.').last),
                          );
                        }).toList(),
                        // onChanged: (UserStatus? newValue) {
                        //   if (newValue != null) {
                        //     _updateMemberStatus(
                        //         task, widget.memberName, newValue);
                        //   }
                        // },
                        onChanged: (task.status)
                            ? null
                            : (UserStatus? newValue) {
                                if (newValue != null) {
                                  _updateMemberStatus(
                                      task, widget.memberName, newValue);
                                }
                              },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  String _formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }

  void _showToastMessage(BuildContext context, Locale locale) {
    String message;
    if (locale.languageCode == 'en') {
      message = 'Language changed to English';
    } else if (locale.languageCode == 'ta') {
      message = 'மொழி தமிழுக்கு மாற்றப்பட்டது';
    } else {
      message = 'Language changed';
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
