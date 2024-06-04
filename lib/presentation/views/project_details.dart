// import 'package:flutter/material.dart';
// import 'package:flutter_projects/domain/model/project.dart';
// import 'package:flutter_projects/domain/model/task.dart';
// import 'package:flutter_projects/presentation/views/task_form.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ProjectDetailsPage extends ConsumerStatefulWidget {
//   final Project project;
//   final List<String> teamMembers;

//   const ProjectDetailsPage(
//       {super.key, required this.project, required this.teamMembers});
//   @override
//   ConsumerState createState() => _ProjectDetailsPageState();
// }

// class _ProjectDetailsPageState extends ConsumerState<ProjectDetailsPage> {
//   final _formKey = GlobalKey<FormState>();

//   late int numberOfTasks;
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
//   Widget build(BuildContext context) {
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
//                     _buildInfoRow("Description", widget.project.description),
//                     _buildInfoRow("Owner", widget.project.owner),
//                     _buildInfoRow(
//                         "Start Date", _formatDate(widget.project.startDate)),
//                     _buildInfoRow(
//                         "End Date", _formatDate(widget.project.endDate)),
//                     _buildInfoRow("Work Hours", widget.project.workHours),
//                     _buildInfoRow("Team Members", widget.project.teamMembers),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Tasks:',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             ListView.builder(
//               shrinkWrap: true,
//               itemCount: widget.project.tasks.length,
//               itemBuilder: (context, index) {
//                 return _buildTaskCard(widget.project.tasks[index]);
//               },
//             ),
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
//             Text(
//               task.taskName,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               task.description,
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Due Date: ${_formatDate(task.dueDate)}',
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Team Members: ${task.teamMembers?.join(", ") ?? "None"}',
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 const Text(
//                   'Completed: ',
//                   style: TextStyle(fontSize: 14),
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

//   List<Widget> _buildTaskFields(
//       DateTime projectEndDate, Function addTeamMember) {
//     return TaskFields.buildTaskFields(
//       tasks,
//       numberOfTasks,
//       widget.teamMembers,
//       setState,
//       projectEndDate,
//       _filterTeamMembers,
//       addTeamMember,
//       context,
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_projects/domain/model/project.dart';
// import 'package:flutter_projects/domain/model/task.dart';
// import 'package:flutter_projects/presentation/views/task_form.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ProjectDetailsPage extends ConsumerStatefulWidget {
//   final Project project;
//   final List<String> teamMembers;

//   const ProjectDetailsPage(
//       {super.key, required this.project, required this.teamMembers});

//   @override
//   ConsumerState createState() => _ProjectDetailsPageState();
// }

// class _ProjectDetailsPageState extends ConsumerState<ProjectDetailsPage> {
//   final _formKey = GlobalKey<FormState>();

//   late int numberOfTasks;
//   List<Task> tasks = [];
//   List<String> filteredTeamMembers = [];

//   void _filterTeamMembers(String query) {
//     setState(() {
//       filteredTeamMembers = widget.teamMembers
//           .where((member) => member.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }

//   void _addTask() {
//     setState(() {
//       tasks.add(Task(
//         taskName: '',
//         description: '',
//         dueDate: widget.project.endDate,
//         status: false,
//         teamMembers: [],
//       ));
//     });

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Add Task'),
//           content: SingleChildScrollView(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: TaskFields.buildTaskFields(
//                   tasks,
//                   tasks.length,
//                   widget.teamMembers,
//                   setState,
//                   widget.project.endDate,
//                   _filterTeamMembers,
//                   _addTeamMember,
//                   context,
//                 ),
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 if (_formKey.currentState!.validate()) {
//                   Navigator.of(context).pop();
//                 }
//               },
//               child: Text('Add'),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   tasks.removeLast();
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
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
//                     _buildInfoRow("Description", widget.project.description),
//                     _buildInfoRow("Owner", widget.project.owner),
//                     _buildInfoRow(
//                         "Start Date", _formatDate(widget.project.startDate)),
//                     _buildInfoRow(
//                         "End Date", _formatDate(widget.project.endDate)),
//                     _buildInfoRow("Work Hours", widget.project.workHours),
//                     _buildInfoRow("Team Members", widget.project.teamMembers),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Tasks:',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 ElevatedButton(
//                   onPressed: _addTask,
//                   child: const Text('Add Task'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             ListView.builder(
//               shrinkWrap: true,
//               itemCount: widget.project.tasks.length,
//               itemBuilder: (context, index) {
//                 return _buildTaskCard(widget.project.tasks[index]);
//               },
//             ),
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
//             Text(
//               task.taskName,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               task.description,
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Due Date: ${_formatDate(task.dueDate)}',
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Team Members: ${task.teamMembers?.join(", ") ?? "None"}',
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 const Text(
//                   'Completed: ',
//                   style: TextStyle(fontSize: 14),
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

//   void _addTeamMember(String newValue, Task task) {
//     setState(() {
//       if (task.teamMembers != null && !task.teamMembers!.contains(newValue)) {
//         task.teamMembers!.add(newValue);
//       }
//     });
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_projects/domain/model/project.dart';
// import 'package:flutter_projects/domain/model/task.dart';
// import 'package:flutter_projects/presentation/providers/project_provider.dart';
// import 'package:flutter_projects/presentation/views/task_form.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

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
//     print("aaaaaaaaaaaaaaaaaaaaaa");
//     super.initState();
//     loadTasks();
//   }

//   // Future<void> loadTasks() async {
//   //   await ref.read(projectsProvider.notifier).getTasks(widget.project.id!);
//   // }
//   Future<void> loadTasks() async {
//     try {
//       final taskList = await ref
//           .read(projectsProvider.notifier)
//           .getTasks(widget.project.id!);
//       setState(() {
//         tasks = taskList;
//       });
//     } catch (e) {
//       print("Error loading tasks: $e");
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

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Add Task'),
//           content: SingleChildScrollView(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: TaskFields.buildTaskFields(
//                   [newTask],
//                   1,
//                   widget.teamMembers,
//                   (func) => setState(func),
//                   widget.project.endDate,
//                   _filterTeamMembers,
//                   _addTeamMember,
//                   context,
//                 ),
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 if (_formKey.currentState!.validate()) {
//                   // setState(() {
//                   //   tasks.add(newTask);
//                   // });
//                   // await ref.read(projectsProvider.notifier).updateProjectTasks(
//                   //   widget.project.id!,
//                   //   [...widget.project.tasks, newTask],
//                   // );
//                   await ref.read(projectsProvider.notifier).updateProjectTasks(
//                     widget.project.id!,
//                     [...tasks, newTask],
//                   );
//                   setState(() {
//                     tasks.add(newTask);
//                   });
//                   Navigator.of(context).pop();
//                 }
//               },
//               child: Text('Add'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
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
//                     _buildInfoRow("Description", widget.project.description),
//                     _buildInfoRow("Owner", widget.project.owner),
//                     _buildInfoRow(
//                         "Start Date", _formatDate(widget.project.startDate)),
//                     _buildInfoRow(
//                         "End Date", _formatDate(widget.project.endDate)),
//                     _buildInfoRow("Work Hours", widget.project.workHours),
//                     _buildInfoRow("Team Members", widget.project.teamMembers),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Tasks:',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 ElevatedButton(
//                   onPressed: _addTask,
//                   child: const Text('Add Task'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             ListView.builder(
//               shrinkWrap: true,
//               itemCount: tasks.length,
//               itemBuilder: (context, index) {
//                 return _buildTaskCard(tasks[index]);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTaskCard(Task task) {
//     // print(task.taskName);
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
//             Text(
//               task.taskName.isNotEmpty ? task.taskName : 'Unnamed Task',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               task.description,
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Due Date: ${_formatDate(task.dueDate)}',
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Team Members: ${task.teamMembers?.join(", ") ?? "None"}',
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 const Text(
//                   'Completed: ',
//                   style: TextStyle(fontSize: 14),
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

//   // void _addTeamMember(String newValue, Task task) {
//   //   setState(() {
//   //     if (task.teamMembers != null && !task.teamMembers!.contains(newValue)) {
//   //       task.teamMembers!.add(newValue);
//   //     }
//   //   });
//   // }
//   static void _addTeamMember(String newValue, Task task, Function setState) {
//     setState(() {
//       if (task.teamMembers != null && !task.teamMembers!.contains(newValue)) {
//         task.teamMembers!.add(newValue);
//         print(
//             'Added member "$newValue" for task "${task.taskName}". Total members: ${task.teamMembers!.length}');
//       }
//     });
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_projects/domain/model/project.dart';
// import 'package:flutter_projects/domain/model/task.dart';
// import 'package:flutter_projects/presentation/providers/project_provider.dart';
// import 'package:flutter_projects/presentation/views/task_form.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

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
//       print(
//           "first time creating tasks for project(task, taskList)--->$tasks,$taskList");
//     } catch (e) {
//       print("Error loading tasks: $e");
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

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Add Task'),
//           content: SingleChildScrollView(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: TaskFields.buildTaskFields(
//                   [newTask],
//                   1,
//                   widget.teamMembers,
//                   (func) => setState(func),
//                   widget.project.endDate,
//                   _filterTeamMembers,
//                   _addTeamMember,
//                   context,
//                 ),
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 if (_formKey.currentState!.validate()) {
//                   await ref.read(projectsProvider.notifier).updateProjectTasks(
//                     widget.project.id!,
//                     [...tasks, newTask],
//                   );
//                   setState(() {
//                     tasks.add(newTask);
//                   });
//                   Navigator.of(context).pop();
//                 }
//               },
//               child: Text('Add'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
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
//                     _buildInfoRow("Description", widget.project.description),
//                     _buildInfoRow("Owner", widget.project.owner),
//                     _buildInfoRow(
//                         "Start Date", _formatDate(widget.project.startDate)),
//                     _buildInfoRow(
//                         "End Date", _formatDate(widget.project.endDate)),
//                     _buildInfoRow("Work Hours", widget.project.workHours),
//                     _buildInfoRow("Team Members", widget.project.teamMembers),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Tasks:',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 ElevatedButton(
//                   onPressed: _addTask,
//                   child: const Text('Add Task'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             ListView.builder(
//               shrinkWrap: true,
//               itemCount: tasks.length,
//               itemBuilder: (context, index) {
//                 return _buildTaskCard(tasks[index]);
//               },
//             ),
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
//             Text(
//               task.taskName.isNotEmpty ? task.taskName : 'Unnamed Task',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               task.description,
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Due Date: ${_formatDate(task.dueDate)}',
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Team Members: ${task.teamMembers?.join(", ") ?? "None"}',
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 const Text(
//                   'Completed: ',
//                   style: TextStyle(fontSize: 14),
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

//   static void _addTeamMember(String newValue, Task task, Function setState) {
//     setState(() {
//       if (task.teamMembers != null && !task.teamMembers!.contains(newValue)) {
//         task.teamMembers!.add(newValue);
//         print(
//             'Added member "$newValue" for task "${task.taskName}". Total members: ${task.teamMembers!.length}');
//       }
//     });
//   }
// }

//working correctly from line no 986--->
// import 'package:flutter/material.dart';
// import 'package:flutter_projects/domain/model/project.dart';
// import 'package:flutter_projects/domain/model/task.dart';
// import 'package:flutter_projects/presentation/providers/project_provider.dart';
// import 'package:flutter_projects/presentation/views/task_form.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

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
//   Set<String> assignedTeamMembers = {};

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
//       print("Loading tasks for project ID: ${widget.project.id!}");
//       final taskList = await ref
//           .read(projectsProvider.notifier)
//           .getTasks(widget.project.id!);
//       setState(() {
//         tasks = taskList;
//       });
//       print("Tasks loaded: $tasks");
//     } catch (e) {
//       print("Error loading tasks: $e");
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

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Add Task'),
//           content: SingleChildScrollView(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: TaskFields.buildTaskFields(
//                   [newTask],
//                   1,
//                   widget.teamMembers,
//                   (func) => setState(func),
//                   widget.project.endDate,
//                   _filterTeamMembers,
//                   _addTeamMember,
//                   context,
//                 ),
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 if (_formKey.currentState!.validate()) {
//                   await ref.read(projectsProvider.notifier).updateProjectTasks(
//                     widget.project.id!,
//                     [...tasks, newTask],
//                   );
//                   setState(() {
//                     tasks.add(newTask);
//                     assignedTeamMembers.addAll(newTask.teamMembers!);
//                   });
//                   Navigator.of(context).pop();
//                 }
//               },
//               child: const Text('Add'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
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
//                     _buildInfoRow("Description", widget.project.description),
//                     _buildInfoRow("Owner", widget.project.owner),
//                     _buildInfoRow(
//                         "Start Date", _formatDate(widget.project.startDate)),
//                     _buildInfoRow(
//                         "End Date", _formatDate(widget.project.endDate)),
//                     _buildInfoRow("Work Hours", widget.project.workHours),
//                     _buildInfoRow("Team Members", widget.project.teamMembers),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Tasks:',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 ElevatedButton(
//                   onPressed: _addTask,
//                   child: const Text('Add Task'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             tasks.isNotEmpty
//                 ? ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: tasks.length,
//                     itemBuilder: (context, index) {
//                       return _buildTaskCard(tasks[index]);
//                     },
//                   )
//                 : const Text("No tasks available."),
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
//             Text(
//               task.taskName.isNotEmpty ? task.taskName : 'Unnamed Task',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               task.description,
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Due Date: ${_formatDate(task.dueDate)}',
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Team Members: ${task.teamMembers}',
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 const Text(
//                   'Completed: ',
//                   style: TextStyle(fontSize: 14),
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

//   static void _addTeamMember(String newValue, Task task, Function setState) {
//     if (!task.teamMembers!.contains(newValue)) {
//       task.teamMembers!.add(newValue);
//       print(
//         'Added member "$newValue" for task "${task.taskName}". Total members: ${task.teamMembers!.length}',
//       );
//       setState(() {});
//     }
//   }
// }

//new code for edit---
import 'package:flutter/material.dart';
import 'package:flutter_projects/domain/model/project.dart';
import 'package:flutter_projects/domain/model/task.dart';
import 'package:flutter_projects/presentation/providers/project_provider.dart';
import 'package:flutter_projects/presentation/views/task_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectDetailsPage extends ConsumerStatefulWidget {
  final Project project;
  final List<String> teamMembers;

  const ProjectDetailsPage({
    super.key,
    required this.project,
    required this.teamMembers,
  });

  @override
  ConsumerState createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends ConsumerState<ProjectDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  List<Task> tasks = [];
  List<String> filteredTeamMembers = [];
  Set<String> assignedTeamMembers = {};

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
      // print("Loading tasks for project ID: ${widget.project.id!}");
      final taskList = await ref
          .read(projectsProvider.notifier)
          .getTasks(widget.project.id!);
      setState(() {
        tasks = taskList;
      });
      // print("Tasks loaded: $tasks");
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
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await ref.read(projectsProvider.notifier).updateProjectTasks(
                    widget.project.id!,
                    [...tasks, newTask],
                  );
                  setState(() {
                    tasks.add(newTask);
                    assignedTeamMembers.addAll(newTask.teamMembers!);
                  });
                  Navigator.of(context).pop();
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
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await ref.read(projectsProvider.notifier).updateProjectTasks(
                        widget.project.id!,
                        tasks,
                      );
                  setState(() {
                    assignedTeamMembers.addAll(task.teamMembers!);
                  });
                  Navigator.of(context).pop();
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

  // void _editTask(Task task) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Edit Task'),
  //         content: SingleChildScrollView(
  //           child: Form(
  //             key: _formKey,
  //             child: Column(
  //               children: TaskFields.buildTaskFields(
  //                 task.taskName as List<Task>,
  //                 1,
  //                 widget.teamMembers,
  //                 (func) => setState(func),
  //                 widget.project.endDate,
  //                 _filterTeamMembers,
  //                 _addTeamMember,
  //                 context,
  //               ),
  //             ),
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () async {
  //               if (_formKey.currentState!.validate()) {
  //                 await ref.read(projectsProvider.notifier).updateProjectTasks(
  //                       widget.project.id!,
  //                       tasks,
  //                     );
  //                 setState(() {
  //                   assignedTeamMembers.addAll(task.teamMembers!);
  //                 });
  //                 Navigator.of(context).pop();
  //               }
  //             },
  //             child: const Text('Save'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.projectName),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
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
                    _buildInfoRow(AppLocalizations.of(context)!.teamMembers,
                        widget.project.teamMembers),
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
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: _addTask,
                  child: Text(AppLocalizations.of(context)!.addtask),
                ),
              ],
            ),
            const SizedBox(height: 10),
            tasks.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _editTask(tasks[index]),
                        child: _buildTaskCard(tasks[index]),
                      );
                    },
                  )
                : Text(AppLocalizations.of(context)!.notasks),
          ],
        ),
      ),
    );
  }

  // Widget _buildTaskCard(Task task) {
  //   return Card(
  //     elevation: 4,
  //     margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(10),
  //       side: const BorderSide(color: Colors.blue, width: 2),
  //     ),
  //     color: Colors.white.withOpacity(0.8),
  //     shadowColor: Colors.blue.withOpacity(0.4),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           IconButton(
  //             icon: Icons.edit,
  //             iconSize: 20,
  //             color: Colors.green[800],
  //             onPressed: () {
  //               _editTask(task);
  //             },
  //           ),
  //           Text(
  //             task.taskName.isNotEmpty ? task.taskName : 'Unnamed Task',
  //             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           ),
  //           const SizedBox(height: 8),
  //           Text(
  //             task.description,
  //             style: const TextStyle(fontSize: 16),
  //           ),
  //           const SizedBox(height: 8),
  //           Text(
  //             'Due Date: ${_formatDate(task.dueDate)}',
  //             style: const TextStyle(fontSize: 14),
  //           ),
  //           const SizedBox(height: 8),
  //           Text(
  //             'Team Members: ${task.teamMembers?.join(', ') ?? ''}',
  //             style: const TextStyle(fontSize: 14),
  //           ),
  //           const SizedBox(height: 8),
  //           Row(
  //             children: [
  //               const Text(
  //                 'Completed: ',
  //                 style: TextStyle(fontSize: 14),
  //               ),
  //               task.status
  //                   ? const Icon(Icons.check_circle, color: Colors.green)
  //                   : const Icon(Icons.cancel, color: Colors.red),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildTaskCard(Task task) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // task.taskName.isNotEmpty ? task.taskName : 'Unnamed Task',
                  '${AppLocalizations.of(context)!.taskName} : ${task.taskName}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editTask(task),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${AppLocalizations.of(context)!.description} : ${task.description}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              '${AppLocalizations.of(context)!.duedate} : ${_formatDate(task.dueDate)}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              '${AppLocalizations.of(context)!.members} : ${task.teamMembers?.join(', ') ?? ''}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${AppLocalizations.of(context)!.completed} : ',
                  style: const TextStyle(fontSize: 14),
                ),
                task.status
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.cancel, color: Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static void _addTeamMember(String newValue, Task task, Function setState) {
    if (!task.teamMembers!.contains(newValue)) {
      task.teamMembers!.add(newValue);
      // print(
      //   'Added member "$newValue" for task "${task.taskName}". Total members: ${task.teamMembers!.length}',
      // );
      setState(() {});
    }
  }
}
