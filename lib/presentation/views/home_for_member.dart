// import 'package:flutter/material.dart';
// import 'package:flutter_projects/data/datasources/project_datasource.dart';
// import 'package:flutter_projects/domain/model/project.dart';

// class HomeForMember extends StatefulWidget {
//   final String memberName;
//   const HomeForMember({Key? key, required this.memberName}) : super(key: key);

//   @override
//   State<HomeForMember> createState() => _HomeForMemberState();
// }

// class _HomeForMemberState extends State<HomeForMember> {
//   List<Project> assignedProjects = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchAssignedProjectsAndTasks();
//   }

//   Future<void> fetchAssignedProjectsAndTasks() async {
//     try {
//       final List<Project> projects =
//           await ProjectDataSource.instance.getAssignedProjectsAndTasks(
//         widget.memberName.split('@').first,
//       );
//       print('before setState---> $projects');
//       setState(() {
//         assignedProjects = projects;
//       });
//       print('projects for member--->>> $assignedProjects, $projects');
//     } catch (e) {
//       print("Error fetching assigned projects: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userNamePrefix = widget.memberName.split('@').first;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("KS ProjectHub - Welcome $userNamePrefix"),
//         backgroundColor: Colors.lightBlue,
//       ),
//       body: ListView.builder(
//         itemCount: assignedProjects.length,
//         itemBuilder: (context, index) {
//           final project = assignedProjects[index];
//           return Card(
//             child: ExpansionTile(
//               title: Text(project.projectName),
//               subtitle: Text(project.description),
//               children: project.tasks.map((task) {
//                 return ListTile(
//                   title: Text(task.taskName),
//                   subtitle: Text(task.description),
//                 );
//               }).toList(),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_projects/data/datasources/project_datasource.dart';
// import 'package:flutter_projects/domain/model/project.dart';

// class HomeForMember extends StatefulWidget {
//   final String memberName;
//   const HomeForMember({Key? key, required this.memberName}) : super(key: key);

//   @override
//   State<HomeForMember> createState() => _HomeForMemberState();
// }

// class _HomeForMemberState extends State<HomeForMember> {
//   List<Project> assignedProjects = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchAssignedProjectsAndTasks();
//   }

//   Future<void> fetchAssignedProjectsAndTasks() async {
//     try {
//       final List<Project> projects =
//           await ProjectDataSource.instance.getAssignedProjectsAndTasks(
//         widget.memberName.split('@').first,
//       );
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
//         title: const Text("KS ProjectHub"),
//         backgroundColor: Colors.lightBlue,
//         // automaticallyImplyLeading: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             onPressed: () {},
//           ),
//         ],
//         centerTitle: true,
//       ),
//       body: assignedProjects.isEmpty
//           ? const Center(
//               child: Text(
//                 'No projects assigned yet.',
//                 style: TextStyle(fontSize: 18, color: Colors.grey),
//               ),
//             )
//           : ListView.builder(
//               padding: const EdgeInsets.all(16.0),
//               itemCount: assignedProjects.length,
//               itemBuilder: (context, index) {
//                 final project = assignedProjects[index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8.0),
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: ExpansionTile(
//                     backgroundColor: Colors.white,
//                     title: Text(
//                       project.projectName,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     subtitle: Text(
//                       project.description,
//                       style: const TextStyle(fontSize: 14, color: Colors.grey),
//                     ),
//                     children: project.tasks.map((task) {
//                       return ListTile(
//                         leading: Icon(
//                           Icons.task_alt,
//                           color: task.status ? Colors.green : Colors.red,
//                         ),
//                         title: Text(
//                           task.taskName,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               task.description,
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               'Due Date: ${_formatDate(task.dueDate)}',
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 );
//               },
//             ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}-${date.month}-${date.year}';
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_projects/data/datasources/project_datasource.dart';
import 'package:flutter_projects/domain/model/project.dart';
import 'package:flutter_projects/domain/model/task.dart';
import 'package:flutter_projects/presentation/views/login.dart';

class HomeForMember extends StatefulWidget {
  final String memberName;
  const HomeForMember({Key? key, required this.memberName}) : super(key: key);

  @override
  State<HomeForMember> createState() => _HomeForMemberState();
}

class _HomeForMemberState extends State<HomeForMember> {
  List<Project> assignedProjects = [];
  final List<TaskStatus> taskStatuses = TaskStatus.values;

  @override
  void initState() {
    super.initState();
    fetchAssignedProjectsAndTasks();
  }

  Future<void> fetchAssignedProjectsAndTasks() async {
    try {
      final List<Project> projects =
          await ProjectDataSource.instance.getAssignedProjectsAndTasks(
        widget.memberName.split('@').first,
      );
      setState(() {
        assignedProjects = projects;
      });
    } catch (e) {
      print("Error fetching assigned projects: $e");
    }
  }

  Future<void> _updateTaskStatus(Task task, TaskStatus newStatus) async {
    try {
      // Update the task status here (e.g., send a request to your backend)
      // For now, we are just updating the status locally
      setState(() {
        task.taskStatus = newStatus;
      });
      _showNotification(
          'Task status updated to ${newStatus.toString().split('.').last}');
    } catch (e) {
      print("Error updating task status: $e");
    }
  }

  void _showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userNamePrefix = widget.memberName.split('@').first;
    return Scaffold(
      appBar: AppBar(
        title: const Text("KS ProjectHub"),
        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          ),
        ],
        centerTitle: true,
      ),
      body: assignedProjects.isEmpty
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
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    children: project.tasks.map((task) {
                      return ListTile(
                        leading: Icon(
                          Icons.task_alt,
                          color: task.taskStatus == TaskStatus.completed
                              ? Colors.green
                              : task.taskStatus == TaskStatus.inProgress
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
                            DropdownButton<TaskStatus>(
                              value: task.taskStatus,
                              items: taskStatuses.map((TaskStatus status) {
                                return DropdownMenuItem<TaskStatus>(
                                  value: status,
                                  child:
                                      Text(status.toString().split('.').last),
                                );
                              }).toList(),
                              onChanged: (TaskStatus? newValue) {
                                if (newValue != null) {
                                  _updateTaskStatus(task, newValue);
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
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }
}
