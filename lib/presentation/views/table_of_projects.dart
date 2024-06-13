import 'package:flutter/material.dart';
import 'package:flutter_projects/domain/model/project.dart';
import 'package:flutter_projects/presentation/providers/project_provider.dart';
import 'package:flutter_projects/presentation/widgets/generate_pdf.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectsTable extends ConsumerStatefulWidget {
  final int userId;

  const ProjectsTable({Key? key, required this.userId}) : super(key: key);

  @override
  ConsumerState<ProjectsTable> createState() => _ProjectsTableState();
}

class _ProjectsTableState extends ConsumerState<ProjectsTable> {
  List<int> selectedProjectIds = [];

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsProvider);

    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.yourProjects),
          backgroundColor: Colors.lightBlue,
        ),
        body: projects.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    final isChecked = selectedProjectIds.contains(project.id);

                    return Card(
                      color: project.completed
                          ? Colors.green
                          : isChecked
                              ? Colors.green
                              : Colors.blue[200],
                      child: ListTile(
                        title: Row(
                          children: [
                            Checkbox(
                              value: isChecked,
                              onChanged: (value) {
                                _markProjectAsCompleted(project.id!);
                              },
                            ),
                            Text(
                              project.projectName,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        trailing: project.completed
                            ? null
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Colors.green[800],
                                    ),
                                    onPressed: () {
                                      _editProject(context, project);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      _deleteProject(context, project);
                                    },
                                  ),
                                ],
                              ),
                        onTap: () {
                          _showProjectDetails(context, project);
                        },
                      ),
                    );
                  },
                ),
              )
            : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset('assets/empty_projects.json'),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.noprojects,
                      style: const TextStyle(
                          fontSize: 16, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ));
  }

  void _markProjectAsCompleted(int projectId) async {
    await ref.read(projectsProvider.notifier).markProjectAsCompleted(projectId);
    // await ref.read(projectsProvider.notifier).fetchProjects();

    final taskList =
        await ref.read(projectsProvider.notifier).getTasks(projectId);

    // final project =
    ref.read(projectsProvider).firstWhere((p) => p.id == projectId);

    for (final task in taskList) {
      task.status = true;
    }
    await ref
        .read(projectsProvider.notifier)
        .updateProjectTasks(projectId, taskList);
  }

  void _showProjectDetails(
    BuildContext context,
    Project project,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Project: ${project.projectName}',
                style: const TextStyle(fontSize: 10),
              ),
              IconButton(
                  icon: const Icon(Icons.picture_as_pdf),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PDFGenerator(
                                project: project,
                              )),
                    );
                  }),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description: ${project.description}'),
                const SizedBox(height: 8),
                Text('Manager: ${project.owner}'),
                const SizedBox(height: 8),
                Text('Start Date: ${_formatDate(project.startDate)}'),
                const SizedBox(height: 8),
                Text('End Date: ${_formatDate(project.endDate)}'),
                const SizedBox(height: 8),
                Text('Work Hours: ${project.workHours}'),
                // const SizedBox(height: 8),
                // Text('Team Members: ${project.teamMembers}'),
                const SizedBox(height: 8),
                const Text('Tasks:'),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: project.tasks.map((task) {
                    return Text('- ${task.taskName}');
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
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

  void _editProject(BuildContext context, Project project) {
    TextEditingController projectNameController =
        TextEditingController(text: project.projectName);
    TextEditingController descriptionController =
        TextEditingController(text: project.description);
    TextEditingController ownerController =
        TextEditingController(text: project.owner);
    TextEditingController startDateController =
        TextEditingController(text: _formatDate(project.startDate));
    TextEditingController endDateController =
        TextEditingController(text: _formatDate(project.endDate));
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

                if (startDate != null && endDate != null) {
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

  String _formatDate(DateTime date) {
    return '${date.year}-${_addLeadingZeroIfNeeded(date.month)}-${_addLeadingZeroIfNeeded(date.day)}';
  }

  String _addLeadingZeroIfNeeded(int value) {
    if (value < 10) {
      return '0$value';
    }
    return value.toString();
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    DateTime initialDate = DateTime.now();

    if (controller.text.isNotEmpty) {
      DateTime parsedDate = _parseDateTime(controller.text)!;
      if (parsedDate.isAfter(initialDate)) {
        initialDate = parsedDate;
      }
    }

    return GestureDetector(
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (selectedDate != null) {
          setState(() {
            controller.text = _formatDate(selectedDate);
          });
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
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
}
