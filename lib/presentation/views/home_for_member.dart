// // import 'package:flutter/material.dart';
// // import 'package:flutter_projects/data/datasources/project_datasource.dart';
// // import 'package:flutter_projects/domain/model/project.dart';

// // class HomeForMember extends StatefulWidget {
// //   final String memberName;
// //   const HomeForMember({Key? key, required this.memberName}) : super(key: key);

// //   @override
// //   State<HomeForMember> createState() => _HomeForMemberState();
// // }

// // class _HomeForMemberState extends State<HomeForMember> {
// //   List<Project> assignedProjects = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchAssignedProjectsAndTasks();
// //   }

// //   Future<void> fetchAssignedProjectsAndTasks() async {
// //     try {
// //       final List<Project> projects =
// //           await ProjectDataSource.instance.getAssignedProjectsAndTasks(
// //         widget.memberName.split('@').first,
// //       );
// //       print('before setState---> $projects');
// //       setState(() {
// //         assignedProjects = projects;
// //       });
// //       print('projects for member--->>> $assignedProjects, $projects');
// //     } catch (e) {
// //       print("Error fetching assigned projects: $e");
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final userNamePrefix = widget.memberName.split('@').first;
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("KS ProjectHub - Welcome $userNamePrefix"),
// //         backgroundColor: Colors.lightBlue,
// //       ),
// //       body: ListView.builder(
// //         itemCount: assignedProjects.length,
// //         itemBuilder: (context, index) {
// //           final project = assignedProjects[index];
// //           return Card(
// //             child: ExpansionTile(
// //               title: Text(project.projectName),
// //               subtitle: Text(project.description),
// //               children: project.tasks.map((task) {
// //                 return ListTile(
// //                   title: Text(task.taskName),
// //                   subtitle: Text(task.description),
// //                 );
// //               }).toList(),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// // import 'package:flutter/material.dart';
// // import 'package:flutter_projects/data/datasources/project_datasource.dart';
// // import 'package:flutter_projects/domain/model/project.dart';

// // class HomeForMember extends StatefulWidget {
// //   final String memberName;
// //   const HomeForMember({Key? key, required this.memberName}) : super(key: key);

// //   @override
// //   State<HomeForMember> createState() => _HomeForMemberState();
// // }

// // class _HomeForMemberState extends State<HomeForMember> {
// //   List<Project> assignedProjects = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchAssignedProjectsAndTasks();
// //   }

// //   Future<void> fetchAssignedProjectsAndTasks() async {
// //     try {
// //       final List<Project> projects =
// //           await ProjectDataSource.instance.getAssignedProjectsAndTasks(
// //         widget.memberName.split('@').first,
// //       );
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
// //         title: const Text("KS ProjectHub"),
// //         backgroundColor: Colors.lightBlue,
// //         // automaticallyImplyLeading: true,
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.notifications),
// //             onPressed: () {},
// //           ),
// //         ],
// //         centerTitle: true,
// //       ),
// //       body: assignedProjects.isEmpty
// //           ? const Center(
// //               child: Text(
// //                 'No projects assigned yet.',
// //                 style: TextStyle(fontSize: 18, color: Colors.grey),
// //               ),
// //             )
// //           : ListView.builder(
// //               padding: const EdgeInsets.all(16.0),
// //               itemCount: assignedProjects.length,
// //               itemBuilder: (context, index) {
// //                 final project = assignedProjects[index];
// //                 return Card(
// //                   margin: const EdgeInsets.symmetric(vertical: 8.0),
// //                   elevation: 4,
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                   child: ExpansionTile(
// //                     backgroundColor: Colors.white,
// //                     title: Text(
// //                       project.projectName,
// //                       style: const TextStyle(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     subtitle: Text(
// //                       project.description,
// //                       style: const TextStyle(fontSize: 14, color: Colors.grey),
// //                     ),
// //                     children: project.tasks.map((task) {
// //                       return ListTile(
// //                         leading: Icon(
// //                           Icons.task_alt,
// //                           color: task.status ? Colors.green : Colors.red,
// //                         ),
// //                         title: Text(
// //                           task.taskName,
// //                           style: const TextStyle(
// //                             fontSize: 16,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                         subtitle: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text(
// //                               task.description,
// //                               style: const TextStyle(fontSize: 14),
// //                             ),
// //                             const SizedBox(height: 4),
// //                             Text(
// //                               'Due Date: ${_formatDate(task.dueDate)}',
// //                               style: const TextStyle(
// //                                 fontSize: 12,
// //                                 color: Colors.grey,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       );
// //                     }).toList(),
// //                   ),
// //                 );
// //               },
// //             ),
// //     );
// //   }

// //   String _formatDate(DateTime date) {
// //     return '${date.day}-${date.month}-${date.year}';
// //   }
// // }

/// Working Code --->>>
// import 'package:animated_snack_bar/animated_snack_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_projects/data/datasources/project_datasource.dart';
// import 'package:flutter_projects/domain/model/project.dart';
// import 'package:flutter_projects/domain/model/task.dart';
// import 'package:flutter_projects/presentation/providers/notification_provider.dart';
// import 'package:flutter_projects/presentation/views/login.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class HomeForMember extends ConsumerStatefulWidget {
//   final String memberName;
//   const HomeForMember({Key? key, required this.memberName}) : super(key: key);

//   @override
//   ConsumerState<HomeForMember> createState() => _HomeForMemberState();
// }

// class _HomeForMemberState extends ConsumerState<HomeForMember> {
//   List<Project> assignedProjects = [];
//   final List<UserStatus> userStatuses = UserStatus.values;

//   @override
//   void initState() {
//     super.initState();
//     fetchAssignedProjectsAndTasks();
//   }

//   Future<void> fetchAssignedProjectsAndTasks() async {
//     try {
//       final List<Project> projects =
//           await ProjectDataSource.instance.getProjectsAndTasksForTeamMember(
//         widget.memberName.split('@').first.toLowerCase(),
//       );
//       print('inside try projects---- $projects');
//       setState(() {
//         assignedProjects = projects;
//       });
//       print('inside try after setstate---- $assignedProjects, $projects');
//     } catch (e) {
//       print("Error fetching assigned projects: $e");
//     }
//   }

//   // Future<void> fetchAssignedProjectsAndTasks() async {
//   //   try {
//   //     final List<Project> projects =
//   //         await ProjectDataSource.instance.getProjectsAndTasksForTeamMember(
//   //       widget.memberName.split('@').first.toLowerCase(),
//   //     );
//   //     final List<Project> clonedProjects = projects.map((project) {
//   //       final List<Task> clonedTasks = project.tasks
//   //           .map((task) => Task(
//   //                 id: task.id,
//   //                 taskName: task.taskName,
//   //                 description: task.description,
//   //                 dueDate: task.dueDate,
//   //                 status: task.status,
//   //                 teamMembers: List<String>.from(task.teamMembers ?? []),
//   //                 assignedMembers:
//   //                     List<String>.from(task.assignedMembers ?? []),
//   //                 hours: task.hours,
//   //                 taskStatus: task.taskStatus,
//   //                 userStatus: task.userStatus,
//   //               ))
//   //           .toList();
//   //       return Project(
//   //         id: project.id,
//   //         projectName: project.projectName,
//   //         description: project.description,
//   //         owner: project.owner,
//   //         workHours: project.workHours,
//   //         startDate: project.startDate,
//   //         endDate: project.endDate,
//   //         teamMembers: project.teamMembers,
//   //         tasks: clonedTasks,
//   //         userId: project.userId,
//   //         assignedTeamMembers:
//   //             List<String>.from(project.assignedTeamMembers ?? []),
//   //         completed: project.completed,
//   //       );
//   //     }).toList();
//   //     setState(() {
//   //       assignedProjects = clonedProjects;
//   //     });
//   //   } catch (e) {
//   //     print("Error fetching assigned projects: $e");
//   //   }
//   // }

//   Future<void> _updateUserStatus(Task task, UserStatus newStatus) async {
//     try {
//       final normalizedMember = widget.memberName.split('@').first.toLowerCase();
//       print(
//           "Updating status for task: ${task.taskName}, member: $normalizedMember");
//       setState(() {
//         task.userStatus = newStatus;
//       });

//       ProjectDataSource.instance.updateTaskStatus(
//         assignedProjects[0].id!,
//         task.taskName,
//         normalizedMember,
//         newStatus,
//       );

//       final message =
//           '$normalizedMember changed Task status to ${newStatus.toString().split('.').last} for task ${task.taskName}';
//       ref.read(notificationProvider.notifier).addNotification(
//             assignedProjects[0].id!,
//             message,
//           );
//       _showNotification(
//           'User status updated to ${newStatus.toString().split('.').last}');
//     } catch (e) {
//       print("Error updating user status: $e");
//     }
//   }

//   void _showNotification(String message) {
//     AnimatedSnackBar.material(
//       message,
//       type: AnimatedSnackBarType.success,
//       duration: const Duration(seconds: 3),
//     ).show(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userNamePrefix = widget.memberName.split('@').first;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("KS ProjectHub"),
//         backgroundColor: Colors.lightBlue,
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.exit_to_app),
//             onPressed: () {
//               Navigator.pushReplacement(context,
//                   MaterialPageRoute(builder: (_) => const LoginScreen()));
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
//             child: Text(
//               'Welcome, $userNamePrefix!',
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: assignedProjects.isEmpty
//                 ? const Center(
//                     child: Text(
//                       'No projects assigned yet.',
//                       style: TextStyle(fontSize: 18, color: Colors.grey),
//                     ),
//                   )
//                 : ListView.builder(
//                     padding: const EdgeInsets.all(16.0),
//                     itemCount: assignedProjects.length,
//                     itemBuilder: (context, index) {
//                       final project = assignedProjects[index];
//                       return Card(
//                         margin: const EdgeInsets.symmetric(vertical: 8.0),
//                         elevation: 4,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: ExpansionTile(
//                           backgroundColor: Colors.white,
//                           title: Text(
//                             project.projectName,
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           subtitle: Text(
//                             project.description,
//                             style: const TextStyle(
//                                 fontSize: 14, color: Colors.grey),
//                           ),
//                           children: project.tasks.map((task) {
//                             return ListTile(
//                               leading: Icon(
//                                 Icons.task_alt,
//                                 color: task.userStatus == UserStatus.done
//                                     ? Colors.green
//                                     : task.userStatus == UserStatus.onProgress
//                                         ? Colors.orange
//                                         : Colors.red,
//                               ),
//                               title: Text(
//                                 task.taskName,
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     task.description,
//                                     style: const TextStyle(fontSize: 14),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     'Due Date: ${_formatDate(task.dueDate)}',
//                                     style: const TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   DropdownButton<UserStatus>(
//                                     value: task.userStatus,
//                                     // items:
//                                     //     userStatuses.map((UserStatus status)
//                                     items: UserStatus.values
//                                         .map((UserStatus status) {
//                                       return DropdownMenuItem<UserStatus>(
//                                         value: status,
//                                         child: Text(
//                                             status.toString().split('.').last),
//                                       );
//                                     }).toList(),
//                                     onChanged: (UserStatus? newValue) {
//                                       if (newValue != null) {
//                                         _updateUserStatus(task, newValue);
//                                         // setState(() {
//                                         //   task.userStatus = newValue;
//                                         // });
//                                         try {
//                                           ProjectDataSource.instance
//                                               .updateTaskStatus(
//                                                   project.id!,
//                                                   task.taskName,
//                                                   widget.memberName
//                                                       .split('@')
//                                                       .first
//                                                       .toLowerCase(),
//                                                   newValue);
//                                           print(
//                                               'nameeee----->>> ${widget.memberName.split('@').first.toLowerCase()}');
//                                           final message =
//                                               '$userNamePrefix changed Task status to ${newValue.toString().split('.').last} for task ${task.taskName}';
//                                           ref
//                                               .read(
//                                                   notificationProvider.notifier)
//                                               .addNotification(
//                                                   project.id!, message);
//                                           _showNotification(
//                                               'You changed the ${task.taskName} status to ${newValue.toString().split('.').last}');
//                                         } catch (e) {
//                                           print(
//                                               "Error updating user task status: $e");
//                                         }
//                                       }
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}-${date.month}-${date.year}';
//   }
// }

/// just display error --->>>
import 'package:flutter/material.dart';
import 'package:flutter_projects/data/datasources/project_datasource.dart';
import 'package:flutter_projects/domain/model/project.dart';
import 'package:flutter_projects/domain/model/task.dart';
import 'package:flutter_projects/presentation/providers/lang_provider.dart';
import 'package:flutter_projects/presentation/providers/project_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_projects/presentation/views/login.dart';
import 'package:flutter_projects/presentation/providers/notification_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeForMember extends ConsumerStatefulWidget {
  final String memberName;

  const HomeForMember({Key? key, required this.memberName}) : super(key: key);

  @override
  ConsumerState<HomeForMember> createState() => _HomeForMemberState();
}

class _HomeForMemberState extends ConsumerState<HomeForMember> {
  List<Project> assignedProjects = [];

  @override
  void initState() {
    // load();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    load();
    super.didChangeDependencies();
  }

  void load() {
    fetchAssignedProjectsAndTasks();
  }

  Future<void> fetchAssignedProjectsAndTasks() async {
    try {
      // final List<Project> projects =
      //     await ProjectDataSource.instance.getProjectsAndTasksForTeamMember(
      //   widget.memberName.split('@').first.toLowerCase(),
      // );
      final List<Project> projects = await ref
          .watch(projectsProvider.notifier)
          .getProjectsAndTasksForTeamMember(
            widget.memberName.split('@').first.toLowerCase(),
          );
      print('Fetched projects: $projects');
      for (var project in projects) {
        for (var task in project.tasks) {
          await task.loadStatusFromPrefs(widget.memberName);
          // await task.saveStatusToPrefs(widget.memberName, task.memberStatuses);
        }
      }
      setState(() {
        assignedProjects = projects;
      });
    } catch (e) {
      print("Error fetching assigned projects: $e");
    }
  }

  // Future<void> changeTaskStatus() async {
  //   try {
  //     final List<Project> projects = await ref
  //         .watch(projectsProvider.notifier)
  //         .getProjectsAndTasksForTeamMember(
  //           widget.memberName.split('@').first.toLowerCase(),
  //         );
  //     print('Fetched projects: $projects');
  //     for (var project in projects) {
  //       for (var task in project.tasks) {
  //         // await task.saveStatusToPrefs(widget.memberName, task.memberStatuses);
  //         await task.loadAllMemberStatuses();
  //       }
  //     }
  //     setState(() {
  //       assignedProjects = projects;
  //     });
  //   } catch (e) {
  //     print("Error fetching assigned projects: $e");
  //   }
  // }

  // Future<void> _updateMemberStatus(
  //     Task task, String member, UserStatus newStatus) async {
  //   try {
  //     final normalizedMember =
  //         widget.memberName.split('@').first.toLowerCase().trim();
  //     print(
  //         "Updating status for task: ${task.taskName}, member: $normalizedMember");

  //     setState(() {
  //       task.updateUserStatus(member, newStatus);
  //     });
  //     // task.updateUserStatus(member, newStatus);

  //     await ProjectDataSource.instance.updateTaskStatus(
  //       assignedProjects[0].id!,
  //       task.taskName,
  //       member,
  //       newStatus,
  //     );
  //     // Trigger a state update to refresh the UI
  //     // setState(() {
  //     //   final updatedProjects = assignedProjects.map((project) {
  //     //     if (project.id == assignedProjects[0].id) {
  //     //       return project.copyWith(
  //     //         tasks: project.tasks.map((t) {
  //     //           return t.taskName == task.taskName ? task.copyWith() : t;
  //     //         }).toList(),
  //     //       );
  //     //     }
  //     //     return project;
  //     //   }).toList();
  //     //   assignedProjects = updatedProjects;
  //     // });
  //     // await ref.read(projectsProvider.notifier).updateTaskStatus(
  //     //       assignedProjects[0].id!,
  //     //       task.taskName,
  //     //       member,
  //     //       newStatus,
  //     //     );
  //     // await ref.read(projectsProvider.notifier).changeStatus(assignedProjects);
  //     final message =
  //         '$normalizedMember changed Task status to ${newStatus.toString().split('.').last} for task ${task.taskName}';
  //     ref.read(notificationProvider.notifier).addNotification(
  //           assignedProjects[0].id!,
  //           message,
  //         );
  //     _showNotification(
  //         'Member status updated to ${newStatus.toString().split('.').last}');
  //   } catch (e) {
  //     print("Error updating member status: $e");
  //   }
  // }

  Future<void> _updateMemberStatus(
      Task task, String member, UserStatus newStatus) async {
    try {
      final normalizedMember =
          widget.memberName.split('@').first.toLowerCase().trim();
      print(
          "Updating status for task: ${task.taskName}, member: $normalizedMember");

      setState(() {
        task.updateUserStatus(member, newStatus);
      });

      // Save the new status to preferences
      print('llllllllllllllllll  =    $newStatus');
      await task.saveStatusToPrefs(member, newStatus);
      print('00000000000 =    $newStatus');

      setState(() {});
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
                  Icon(Icons.translate, color: Colors.blue),
                  SizedBox(width: 10),
                  Text('English'),
                ],
              ),
            ),
            const PopupMenuItem<Locale>(
              value: Locale('ta'),
              child: Row(
                children: [
                  Icon(Icons.translate, color: Colors.green),
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
            child: Text(
              '${AppLocalizations.of(context)!.welcomewithoutcomma}, $userNamePrefix!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: assignedProjects.isEmpty
                ? const Center(
                    child: Text(
                      'No projects assigned yet.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: assignedProjects.length,
                    itemBuilder: (context, index) {
                      final project = assignedProjects[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ExpansionTile(
                          backgroundColor: Colors.white,
                          title: Text(
                            project.projectName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            project.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          children: project.tasks.map((task) {
                            return ListTile(
                              leading: Icon(
                                Icons.task_alt,
                                color: task.memberStatuses[widget.memberName] ==
                                        UserStatus.done
                                    ? Colors.green
                                    : task.memberStatuses[widget.memberName] ==
                                            UserStatus.onProgress
                                        ? Colors.orange
                                        : Colors.red,
                              ),
                              title: Text(
                                task.taskName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.description,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Due Date: ${_formatDate(task.dueDate)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Text(
                                        'Status: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        task.memberStatuses[widget.memberName]
                                                ?.toString()
                                                .split('.')
                                                .last ??
                                            'Not Set',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  DropdownButton<UserStatus>(
                                    value:
                                        task.memberStatuses[widget.memberName],
                                    items: UserStatus.values
                                        .map((UserStatus status) {
                                      return DropdownMenuItem<UserStatus>(
                                        value: status,
                                        child: Text(
                                            status.toString().split('.').last),
                                      );
                                    }).toList(),
                                    onChanged: (UserStatus? newValue) {
                                      if (newValue != null) {
                                        _updateMemberStatus(
                                            task, widget.memberName, newValue);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }

  void _showLanguageDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => LanguageDropdown(),
    );
  }
}

class LanguageDropdown extends ConsumerWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLanguage = ref.watch(languageProvider);

    return PopupMenuButton<Locale>(
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
              Icon(Icons.translate, color: Colors.blue),
              SizedBox(width: 10),
              Text('English'),
            ],
          ),
        ),
        const PopupMenuItem<Locale>(
          value: Locale('ta'),
          child: Row(
            children: [
              Icon(Icons.translate, color: Colors.green),
              SizedBox(width: 10),
              Text('தமிழ்'),
            ],
          ),
        ),
      ],
    );
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
