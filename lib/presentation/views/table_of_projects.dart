import 'package:flutter/material.dart';
import 'package:flutter_projects/domain/model/project.dart';
import 'package:flutter_projects/presentation/providers/project_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectsTable extends ConsumerStatefulWidget {
  final int userId;

  const ProjectsTable({Key? key, required this.userId}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProjectsTableState createState() => _ProjectsTableState();
}

class _ProjectsTableState extends ConsumerState<ProjectsTable> {
  bool projectsExist = false;

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsProvider);

    projectsExist = projects.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:  Text(AppLocalizations.of(context)!.yourProjects),
        backgroundColor: Colors.lightBlue,
      ),
      body: projectsExist
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return Card(
                    color: Colors.blue[200],
                    child: ListTile(
                      title: Text(
                        project.projectName,
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: Row(
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
                    ),
                  );
                },
              ),
            )
          : Center(
              child: Lottie.asset('assets/empty_projects.json'),
            ),
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
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
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
                _buildDateField("Start Date", startDateController),
                _buildDateField("End Date", endDateController),
                TextFormField(
                  controller: workHoursController,
                  decoration: const InputDecoration(labelText: 'Work Hours'),
                ),
                TextFormField(
                  controller: teamMembersController,
                  decoration: const InputDecoration(labelText: 'Team Members'),
                ),
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
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Failed to update project.'),
                    ));
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
    return GestureDetector(
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
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
