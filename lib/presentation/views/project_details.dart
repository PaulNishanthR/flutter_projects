// import 'package:animated_snack_bar/animated_snack_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_projects/domain/model/project.dart';
// import 'package:flutter_projects/domain/model/task.dart';
// import 'package:flutter_projects/presentation/providers/project_provider.dart';
// import 'package:flutter_projects/presentation/views/task_form.dart';
// import 'package:flutter_projects/utils/constants/custom_exception.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class ProjectDetailsPage extends ConsumerStatefulWidget {
//   final Project project;
//   final List<String> teamMembers;

//   const ProjectDetailsPage({
//     super.key,
//     required this.project,
//     required this.teamMembers,
//   });

//   @override
//   ConsumerState createState() => _ProjectDetailsPageState();
// }

// class _ProjectDetailsPageState extends ConsumerState<ProjectDetailsPage> {
//   final _formKey = GlobalKey<FormState>();

//   List<Task> tasks = [];
//   List<String> filteredTeamMembers = [];

//   void _filterTeamMembers(String query) {
//     setState(() {
//       filteredTeamMembers = widget.teamMembers
//           .where((member) => member.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadTasks();
//   }

//   Future<void> loadTasks() async {
//     try {
//       final taskList = await ref
//           .read(projectsProvider.notifier)
//           .getTasks(widget.project.id!);
//       setState(() {
//         tasks = taskList;
//       });
//     } catch (e) {
//       // print("Error loading tasks: $e");
//     }
//   }

//   void _addTask() {
//     Task newTask = Task(
//       taskName: '',
//       description: '',
//       dueDate: widget.project.endDate,
//       status: false,
//       teamMembers: [],
//     );
//     // print('count of team members---->>>${widget.project.teamMembers}');
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(AppLocalizations.of(context)!.addtask),
//           content: SingleChildScrollView(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: TaskFields.buildTaskFields(
//                     [newTask],
//                     1,
//                     widget.teamMembers,
//                     // setState,
//                     (func) => setState(func),
//                     widget.project.endDate,
//                     _filterTeamMembers,
//                     _addTeamMember,
//                     context,
//                     int.parse(widget.project.teamMembers),
//                     widget.project),
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 if (_formKey.currentState!.validate()) {
//                   try {
//                     int totalHours = tasks.fold(
//                         0, (sum, task) => sum + int.parse(task.hours!));
//                     totalHours += int.parse(newTask.hours!);

//                     if (totalHours > int.parse(widget.project.workHours)) {
//                       AnimatedSnackBar.material(
//                         'total Hours Exceeded',
//                         type: AnimatedSnackBarType.warning,
//                       ).show(context);
//                     } else {
//                       newTask.teamMembers = newTask.getTeamMembersList();
//                       await ref
//                           .read(projectsProvider.notifier)
//                           .updateProjectTasks(
//                         widget.project.id!,
//                         [...tasks, newTask],
//                       );
//                       setState(() {
//                         tasks.add(newTask);
//                       });
//                       if (context.mounted) {
//                         Navigator.of(context).pop();
//                       }
//                     }
//                   } on CustomException {
//                     if (context.mounted) {
//                       AnimatedSnackBar.material('Error Team members',
//                               type: AnimatedSnackBarType.warning)
//                           .show(context);
//                     }
//                   } catch (e) {
//                     // print("Error adding task: $e");
//                   }
//                 }
//               },
//               child: Text(AppLocalizations.of(context)!.add),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text(AppLocalizations.of(context)!.cancel),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _editTask(Task task) {
//     final taskNameController = TextEditingController(text: task.taskName);
//     final descriptionController = TextEditingController(text: task.description);
//     final hoursController = TextEditingController(text: task.hours);

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(AppLocalizations.of(context)!.edittask),
//           content: SingleChildScrollView(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: TaskFields.buildTaskFields(
//                   [task],
//                   1,
//                   widget.teamMembers,
//                   //setState,
//                   (func) => setState(func),
//                   widget.project.endDate,
//                   _filterTeamMembers,
//                   _addTeamMember,
//                   context,
//                   int.parse(widget.project.teamMembers),
//                   widget.project,
//                   taskNameController: taskNameController,
//                   descriptionController: descriptionController,
//                   hoursController: hoursController,
//                 ),
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 if (_formKey.currentState!.validate()) {
//                   try {
//                     task.taskName = taskNameController.text;
//                     task.description = descriptionController.text;
//                     task.hours = hoursController.text;
//                     task.teamMembers = task.getTeamMembersList();
//                     int totalHours = tasks.fold(
//                         0, (sum, task) => sum + int.parse(task.hours!));

//                     if (totalHours > int.parse(widget.project.workHours)) {
//                       AnimatedSnackBar.material(
//                         'total Hours Exceeded',
//                         type: AnimatedSnackBarType.warning,
//                       ).show(context);
//                     } else {
//                       await ref
//                           .read(projectsProvider.notifier)
//                           .updateProjectTasks(
//                             widget.project.id!,
//                             tasks,
//                           );
//                       setState(() {});
//                       if (context.mounted) {
//                         Navigator.of(context).pop();
//                       }
//                     }
//                   } on CustomException {
//                     if (context.mounted) {
//                       AnimatedSnackBar.material('Error Team members',
//                               type: AnimatedSnackBarType.warning)
//                           .show(context);
//                     }
//                   } catch (e) {
//                     // print("Error editing task: $e");
//                   }
//                 }
//               },
//               child: Text(AppLocalizations.of(context)!.save),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text(AppLocalizations.of(context)!.cancel),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     ref.watch(projectsProvider.notifier);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.project.projectName),
//         backgroundColor: Colors.lightBlue,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               elevation: 4,
//               margin: const EdgeInsets.only(bottom: 20),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 side: const BorderSide(color: Colors.blue, width: 2),
//               ),
//               color: Colors.white.withOpacity(0.8),
//               shadowColor: Colors.blue.withOpacity(0.4),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildInfoRow(AppLocalizations.of(context)!.description,
//                         widget.project.description),
//                     _buildInfoRow(AppLocalizations.of(context)!.manager,
//                         widget.project.owner),
//                     _buildInfoRow(AppLocalizations.of(context)!.startdate,
//                         _formatDate(widget.project.startDate)),
//                     _buildInfoRow(AppLocalizations.of(context)!.enddate,
//                         _formatDate(widget.project.endDate)),
//                     _buildInfoRow(AppLocalizations.of(context)!.workHours,
//                         widget.project.workHours),
//                     _buildInfoRow(AppLocalizations.of(context)!.teamMembers,
//                         widget.project.teamMembers.toString()),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   AppLocalizations.of(context)!.tasks,
//                   style: const TextStyle(
//                       fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 ElevatedButton(
//                   onPressed: _addTask,
//                   child: Text(AppLocalizations.of(context)!.addtask),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             tasks.isNotEmpty
//                 ? ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: tasks.length,
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: () => _editTask(tasks[index]),
//                         child: _buildTaskCard(tasks[index]),
//                       );
//                     },
//                   )
//                 : Text(AppLocalizations.of(context)!.notasks),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTaskCard(Task task) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//         side: const BorderSide(color: Colors.blue, width: 2),
//       ),
//       color: Colors.white.withOpacity(0.8),
//       shadowColor: Colors.blue.withOpacity(0.4),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   '${AppLocalizations.of(context)!.taskName} : ${task.taskName}',
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.edit),
//                   onPressed: () => _editTask(task),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               '${AppLocalizations.of(context)!.description} : ${task.description}',
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               '${AppLocalizations.of(context)!.duedate} : ${_formatDate(task.dueDate)}',
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Task Hours : ${task.hours!}',
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               '${AppLocalizations.of(context)!.members} : ${task.teamMembers?.join(', ') ?? ''}',
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Text(
//                   '${AppLocalizations.of(context)!.completed} : ',
//                   style: const TextStyle(fontSize: 14),
//                 ),
//                 task.status
//                     ? const Icon(Icons.check_circle, color: Colors.green)
//                     : const Icon(Icons.cancel, color: Colors.red),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '$label:',
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }

//   void _addTeamMember(String member) {
//     if (!allocatedTeamMembers.contains(member)) {
//       setState(() {
//         allocatedTeamMembers.add(member);
//       });
//     }
//   }

//   Future<bool> validateTeamMembers(List<String> teamMembers) async {
//     try {
//       for (var member in teamMembers) {
//         bool isAssigned = await ref
//             .read(projectsProvider.notifier)
//             .isMemberAssignedToAnotherProject(member);
//         if (isAssigned) {
//           // print("Team member $member is already assigned to another project");
//           return false;
//         }
//       }
//       return true;
//     } catch (e) {
//       // print("Error validating team members: $e");
//       return false;
//     }
//   }
// }

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/domain/model/project.dart';
import 'package:flutter_projects/domain/model/task.dart';
import 'package:flutter_projects/presentation/providers/project_provider.dart';
import 'package:flutter_projects/presentation/views/notifications/project_notification.dart';
import 'package:flutter_projects/presentation/views/task_form.dart';
import 'package:flutter_projects/utils/constants/custom_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectDetailsPage extends ConsumerStatefulWidget {
  final Project project;
  final List<String> teamMembers;
  final int userId;

  const ProjectDetailsPage(
      {super.key,
      required this.project,
      required this.teamMembers,
      required this.userId});

  @override
  ConsumerState createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends ConsumerState<ProjectDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  List<Task> tasks = [];
  List<String> filteredTeamMembers = [];

  void _filterTeamMembers(String query) {
    setState(() {
      filteredTeamMembers = widget.teamMembers
          .where((member) => member.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    try {
      final taskList = await ref
          .read(projectsProvider.notifier)
          .getTasks(widget.project.id!);
      setState(() {
        tasks = taskList;
      });
    } catch (e) {
      // print("Error loading tasks: $e");
    }
  }

  void _addTask() {
    Task newTask = Task(
      taskName: '',
      description: '',
      dueDate: widget.project.endDate,
      status: false,
      teamMembers: [],
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.addtask),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: TaskFields.buildTaskFields(
                    [newTask],
                    1,
                    widget.teamMembers,
                    (func) => setState(func),
                    widget.project.endDate,
                    _filterTeamMembers,
                    _addTeamMember,
                    context,
                    int.parse(widget.project.teamMembers),
                    widget.project),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    int totalHours = tasks.fold(
                        0, (sum, task) => sum + int.parse(task.hours!));
                    totalHours += int.parse(newTask.hours!);

                    if (totalHours > int.parse(widget.project.workHours)) {
                      AnimatedSnackBar.material(
                        'total Hours Exceeded',
                        type: AnimatedSnackBarType.warning,
                      ).show(context);
                    } else {
                      newTask.teamMembers = newTask.getTeamMembersList();
                      await ref
                          .read(projectsProvider.notifier)
                          .updateProjectTasks(
                        widget.project.id!,
                        [...tasks, newTask],
                      );
                      final user = newTask.getTeamMembersList().toString();
                      print('user in task---- $user');
                      // await ProjectDataSource.instance.insertAssignedTask(
                      //     widget.project.id!,
                      //     widget.project.projectName,
                      //     newTask,
                      //     user);
                      print('user in ask---- $user');
                      setState(() {
                        tasks.add(newTask);
                      });
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    }
                  } on CustomException {
                    if (context.mounted) {
                      AnimatedSnackBar.material('Error Team members',
                              type: AnimatedSnackBarType.warning)
                          .show(context);
                    }
                  } catch (e) {
                    // print("Error adding task: $e");
                  }
                }
              },
              child: Text(AppLocalizations.of(context)!.add),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ],
        );
      },
    );
  }

  void _editTask(Task task) {
    final taskNameController = TextEditingController(text: task.taskName);
    final descriptionController = TextEditingController(text: task.description);
    final hoursController = TextEditingController(text: task.hours);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.edittask),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: TaskFields.buildTaskFields(
                  [task],
                  1,
                  widget.teamMembers,
                  (func) => setState(func),
                  widget.project.endDate,
                  _filterTeamMembers,
                  _addTeamMember,
                  context,
                  int.parse(widget.project.teamMembers),
                  widget.project,
                  taskNameController: taskNameController,
                  descriptionController: descriptionController,
                  hoursController: hoursController,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    task.taskName = taskNameController.text;
                    task.description = descriptionController.text;
                    task.hours = hoursController.text;
                    task.teamMembers = task.getTeamMembersList();
                    int totalHours = tasks.fold(
                        0, (sum, task) => sum + int.parse(task.hours!));

                    if (totalHours > int.parse(widget.project.workHours)) {
                      AnimatedSnackBar.material(
                        'Total Hours Exceeded',
                        type: AnimatedSnackBarType.warning,
                      ).show(context);
                    } else {
                      await ref
                          .read(projectsProvider.notifier)
                          .updateProjectTasks(
                            widget.project.id!,
                            tasks,
                          );
                      setState(() {});
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    }
                  } on CustomException {
                    if (context.mounted) {
                      AnimatedSnackBar.material('Error Selecting Team members',
                              type: AnimatedSnackBarType.warning)
                          .show(context);
                    }
                  } catch (e) {
                    // print("Error editing task: $e");
                  }
                }
              },
              child: Text(AppLocalizations.of(context)!.save),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(projectsProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.projectName),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectMessagesPage(
                    project: widget.project,
                  ),
                ),
              );
            },
          ),
          if (!widget.project.completed)
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    _editProject(context, widget.project);
                    break;
                  case 'delete':
                    _deleteProject(context, widget.project);
                    break;
                  case 'complete':
                    _markProjectAsCompleted(widget.project.id!);
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text(AppLocalizations.of(context)!.editproject),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(AppLocalizations.of(context)!.deleteproject),
                  ),
                  PopupMenuItem(
                    value: 'complete',
                    child: Text(AppLocalizations.of(context)!.markascomplete),
                  ),
                ];
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.blue, width: 2),
              ),
              color: Colors.white.withOpacity(0.8),
              shadowColor: Colors.blue.withOpacity(0.4),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(AppLocalizations.of(context)!.description,
                        widget.project.description),
                    _buildInfoRow(AppLocalizations.of(context)!.manager,
                        widget.project.owner),
                    _buildInfoRow(AppLocalizations.of(context)!.startdate,
                        _formatDate(widget.project.startDate)),
                    _buildInfoRow(AppLocalizations.of(context)!.enddate,
                        _formatDate(widget.project.endDate)),
                    _buildInfoRow(AppLocalizations.of(context)!.workHours,
                        widget.project.workHours),
                    // _buildInfoRow(AppLocalizations.of(context)!.teamMembers,
                    //     widget.project.teamMembers),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.tasks,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!widget.project.completed)
                  ElevatedButton.icon(
                    onPressed: _addTask,
                    icon: const Icon(Icons.add),
                    label: Text(AppLocalizations.of(context)!.addtask),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            tasks.isEmpty
                ? Text(
                    AppLocalizations.of(context)!.notasks,
                    style: const TextStyle(fontSize: 16),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        // onTap: () => _editTask(tasks[index]),
                        child: _buildTaskCard(tasks[index]),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    Color statusColor;
    switch (task.taskStatus) {
      case TaskStatus.todo:
        statusColor = Colors.blue;
        break;
      case TaskStatus.inProgress:
        statusColor = Colors.orange;
        break;
      case TaskStatus.completed:
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        // side: const BorderSide(color: Colors.blue, width: 2),
        side: BorderSide(color: statusColor, width: 2),
      ),
      color: Colors.white.withOpacity(0.8),
      shadowColor: Colors.blue.withOpacity(0.4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.taskName} : ${task.taskName}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (!widget.project.completed)
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editTask(task),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              '${AppLocalizations.of(context)!.description} : ${task.description}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 3),
            Text(
              '${AppLocalizations.of(context)!.duedate} : ${_formatDate(task.dueDate)}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 3),
            Text(
              '${AppLocalizations.of(context)!.taskHours} : ${task.hours!}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 3),
            Text(
              '${AppLocalizations.of(context)!.members} : ${task.teamMembers?.join(', ') ?? ''}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                Text('${AppLocalizations.of(context)!.status} : '),
                DropdownButton<TaskStatus>(
                  value: task.taskStatus,
                  items: TaskStatus.values.map((TaskStatus status) {
                    return DropdownMenuItem<TaskStatus>(
                      value: status,
                      child: Text(status.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: widget.project.completed
                      ? null
                      : (TaskStatus? newValue) {
                          if (newValue != null) {
                            setState(() {
                              task.taskStatus = newValue;
                            });
                            if (newValue == TaskStatus.completed) {
                              task.status = true;
                            } else {
                              task.status = false;
                            }
                            ref
                                .read(projectsProvider.notifier)
                                .updateProjectTasks(
                                  widget.project.id!,
                                  tasks,
                                );
                          }
                        },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // void _markTaskAsComplete(Task task) async {
  //   try {
  //     task.status = !task.status;
  //     await ref
  //         .read(projectsProvider.notifier)
  //         .updateProjectTasks(widget.project.id!, tasks);
  //     setState(() {});
  //     if (context.mounted) {
  //       AnimatedSnackBar.material(
  //         task.status
  //             ? 'Task marked as completed'
  //             : 'Task marked as incomplete',
  //         type: task.status
  //             ? AnimatedSnackBarType.success
  //             : AnimatedSnackBarType.warning,
  //       ).show(context);
  //     }
  //   } catch (e) {
  //     if (context.mounted) {
  //       AnimatedSnackBar.material(
  //         'Failed to update task status',
  //         type: AnimatedSnackBarType.error,
  //       ).show(context);
  //     }
  //   }
  // }

  String _formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  // void _markProjectAsCompleted(int projectId) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Mark the Project as Complete'),
  //         content: const Text(
  //             'Are you sure you want to mark this project as completed?'),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () async {
  //               try {
  //                 await ref
  //                     .read(projectsProvider.notifier)
  //                     .markProjectAsCompleted(projectId);
  //                 final taskList = await ref
  //                     .read(projectsProvider.notifier)
  //                     .getTasks(projectId);
  //                 for (final task in taskList) {
  //                   task.status = true;
  //                 }
  //                 await ref
  //                     .read(projectsProvider.notifier)
  //                     .updateProjectTasks(projectId, taskList);
  //                 setState(() {
  //                   tasks = taskList;
  //                 });
  //                 if (context.mounted) {
  //                   AnimatedSnackBar.material('Project marked as completed',
  //                           type: AnimatedSnackBarType.success)
  //                       .show(context);
  //                 }
  //                 if (context.mounted) {
  //                   Navigator.of(context).pop();
  //                 }
  //               } catch (e) {
  //                 if (context.mounted) {
  //                   AnimatedSnackBar.material(
  //                           'Failed to mark project as completed',
  //                           type: AnimatedSnackBarType.error)
  //                       .show(context);
  //                 }
  //               }
  //               if (context.mounted) {
  //                 Navigator.of(context).pop();
  //               }
  //             },
  //             child: const Text('OK'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Cancel'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _markProjectAsCompleted(int projectId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mark the Project as Complete'),
          content: const Text(
              'Are you sure you want to mark this project as completed?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (tasks.isEmpty) {
                  AnimatedSnackBar.material(
                    'No tasks available. Cannot mark project as completed.',
                    type: AnimatedSnackBarType.error,
                  ).show(context);
                  Navigator.of(context).pop();
                  return;
                }
                try {
                  bool allTasksCompleted = tasks
                      .every((task) => task.taskStatus == TaskStatus.completed);

                  if (allTasksCompleted) {
                    await ref
                        .read(projectsProvider.notifier)
                        .markProjectAsCompleted(projectId);

                    final taskList = await ref
                        .read(projectsProvider.notifier)
                        .getTasks(projectId);

                    for (final task in taskList) {
                      task.status = true;
                    }
                    await ref
                        .read(projectsProvider.notifier)
                        .updateProjectTasks(projectId, taskList);
                    setState(() {
                      tasks = taskList;
                    });
                    if (context.mounted) {
                      AnimatedSnackBar.material('Project marked as completed',
                              type: AnimatedSnackBarType.success)
                          .show(context);
                    }
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  } else {
                    // Display error message if any task is not completed
                    AnimatedSnackBar.material(
                            'All tasks must be completed before marking the project as completed',
                            type: AnimatedSnackBarType.error)
                        .show(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    AnimatedSnackBar.material(
                            'Failed to mark project as completed',
                            type: AnimatedSnackBarType.error)
                        .show(context);
                  }
                }

                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _editProject(BuildContext context, Project project) {
    TextEditingController projectNameController =
        TextEditingController(text: project.projectName);
    TextEditingController descriptionController =
        TextEditingController(text: project.description);
    TextEditingController ownerController =
        TextEditingController(text: project.owner);
    TextEditingController startDateController =
        TextEditingController(text: _formatDateForProject(project.startDate));
    TextEditingController endDateController =
        TextEditingController(text: _formatDateForProject(project.endDate));
    TextEditingController workHoursController =
        TextEditingController(text: project.workHours);
    TextEditingController teamMembersController =
        TextEditingController(text: project.teamMembers);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Project'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: projectNameController,
                  decoration: const InputDecoration(labelText: 'Project Name'),
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextFormField(
                  controller: ownerController,
                  decoration: const InputDecoration(labelText: 'Owner'),
                ),
                _buildDateField("End Date", endDateController),
                TextFormField(
                  controller: workHoursController,
                  decoration: const InputDecoration(labelText: 'Work Hours'),
                ),
                TextFormField(
                  controller: teamMembersController,
                  decoration: const InputDecoration(labelText: 'Team Members'),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                DateTime? startDate = _parseDateTime(startDateController.text);
                DateTime? endDate = _parseDateTime(endDateController.text);

                if (project.id != null &&
                    startDate != null &&
                    endDate != null) {
                  Project updatedProject = Project(
                    id: project.id,
                    userId: widget.userId,
                    projectName: projectNameController.text,
                    description: descriptionController.text,
                    owner: ownerController.text,
                    startDate: startDate,
                    endDate: endDate,
                    workHours: workHoursController.text,
                    teamMembers: teamMembersController.text,
                    tasks: project.tasks,
                  );

                  final success = await ref
                      .read(projectsProvider.notifier)
                      .editProject(project.id!, updatedProject);

                  if (success) {
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Failed to update project.'),
                      ));
                    }
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Invalid date format.'),
                  ));
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteProject(BuildContext context, Project project) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Project'),
          content: const Text('Are you sure you want to delete the project?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await ref
                    .read(projectsProvider.notifier)
                    .deleteProject(project.id!);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _addTeamMember(String newMember) {
    if (!filteredTeamMembers.contains(newMember)) {
      setState(() {
        filteredTeamMembers.add(newMember);
      });
    }
  }

  Widget _buildDateField(String label, TextEditingController? controller) {
    DateTime initialDate = DateTime.now();

    if (controller != null && controller.text.isNotEmpty) {
      DateTime? parsedDate = _parseDateTime(controller.text);
      if (parsedDate != null && parsedDate.isAfter(initialDate)) {
        initialDate = parsedDate;
      }
    }

    TextEditingController textEditingController =
        controller ?? TextEditingController();

    return GestureDetector(
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (selectedDate != null) {
          textEditingController.text = _formatDateForProject(selectedDate);
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: textEditingController,
          decoration: InputDecoration(
            labelText: label,
          ),
        ),
      ),
    );
  }

  DateTime? _parseDateTime(String text) {
    if (text.isEmpty) {
      return null;
    }
    try {
      return DateTime.parse(text);
    } catch (e) {
      // print('Error parsing date: $e');
      return null;
    }
  }

  String _formatDateForProject(DateTime date) {
    return '${date.year}-${_addLeadingZeroIfNeeded(date.month)}-${_addLeadingZeroIfNeeded(date.day)}';
  }

  String _addLeadingZeroIfNeeded(int value) {
    if (value < 10) {
      return '0$value';
    }
    return value.toString();
  }
}
