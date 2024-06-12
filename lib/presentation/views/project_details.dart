import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/domain/model/project.dart';
import 'package:flutter_projects/domain/model/task.dart';
import 'package:flutter_projects/presentation/providers/project_provider.dart';
import 'package:flutter_projects/presentation/views/task_form.dart';
import 'package:flutter_projects/utils/constants/custom_exception.dart';
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
    // print('count of team members---->>>${widget.project.teamMembers}');
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
                    // setState,
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
                  // bool isValid =
                  //     await validateTeamMembers(newTask.teamMembers!);
                  // if (!isValid) {
                  //   print(
                  //       "Validation failed: Some team members are already assigned to another project");
                  //   return;
                  // }

                  try {
                    int totalHours = tasks.fold(
                        0, (sum, task) => sum + int.parse(task.hours!));
                    totalHours += int.parse(newTask.hours!);

                    if (totalHours > int.parse(widget.project.workHours)) {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //     content: Text('totalHoursExceeded'),
                      //     backgroundColor: Colors.red,
                      //   ),
                      // );
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
                  //setState,
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
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //     content: Text('totalHoursExceeded'),
                      //     backgroundColor: Colors.red,
                      //   ),
                      // );
                      AnimatedSnackBar.material(
                        'total Hours Exceeded',
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
                      AnimatedSnackBar.material('Error Team members',
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
    // final projectProvider =
    ref.watch(projectsProvider.notifier);
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
                        widget.project.teamMembers.toString()),
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
              'Task Hours : ${task.hours!}',
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

  void _addTeamMember(String member) {
    if (!allocatedTeamMembers.contains(member)) {
      setState(() {
        allocatedTeamMembers.add(member);
      });
    }
  }

  Future<bool> validateTeamMembers(List<String> teamMembers) async {
    try {
      for (var member in teamMembers) {
        bool isAssigned = await ref
            .read(projectsProvider.notifier)
            .isMemberAssignedToAnotherProject(member);
        if (isAssigned) {
          // print("Team member $member is already assigned to another project");
          return false;
        }
      }
      return true;
    } catch (e) {
      // print("Error validating team members: $e");
      return false;
    }
  }
}
