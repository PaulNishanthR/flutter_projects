import 'package:flutter/material.dart';
import 'package:flutter_projects/domain/model/project.dart';
import 'package:flutter_projects/presentation/providers/project_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'task_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// final projectDemoProvider = StateNotifierProvider<ProjectDemo, Project>((ref) {
//   return ProjectDemo();
// });

class ProjectForm extends ConsumerStatefulWidget {
  final void Function(Project) addProject;
  final List<String> teamMembers;
  final int userId;

  const ProjectForm({
    Key? key,
    required this.addProject,
    required this.teamMembers,
    required this.userId,
  }) : super(key: key);

  @override
  ConsumerState<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends ConsumerState<ProjectForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController projectNameController;
  late TextEditingController descriptionController;
  late TextEditingController ownerController;
  late TextEditingController workHoursController;
  late TextEditingController teamMembersController;

  late DateTime startDate = DateTime.now();
  late DateTime endDate = DateTime.now();
  late int numberOfTasks = 0;
  List<Task> tasks = [];

  late TextEditingController _textEditingController;
  // ignore: unused_field
  List<String> _filteredTeamMembers = [];

  bool isSubmitting = false;
  bool showSuccessAnimation = false;

  @override
  void initState() {
    super.initState();
    projectNameController = TextEditingController();
    descriptionController = TextEditingController();
    ownerController = TextEditingController();
    workHoursController = TextEditingController();
    teamMembersController = TextEditingController();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    projectNameController.dispose();
    descriptionController.dispose();
    ownerController.dispose();
    workHoursController.dispose();
    teamMembersController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  void addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  void _filterTeamMembers(String query) {
    setState(() {
      _filteredTeamMembers = widget.teamMembers
          .where((member) => member.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: projectNameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.projectName,
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900]!),
                    borderRadius: BorderRadius.circular(8.0),
                    gapPadding: 8.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900]!),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900]!),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.blueGrey[50],
                ),
                style: const TextStyle(fontSize: 14),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter project name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.description,
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900]!),
                    borderRadius: BorderRadius.circular(8.0),
                    gapPadding: 8.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900]!),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900]!),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.blueGrey[50],
                ),
                style: const TextStyle(fontSize: 14),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter project description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: ownerController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.projectOwner,
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900]!),
                    borderRadius: BorderRadius.circular(8.0),
                    gapPadding: 8.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900]!),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900]!),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.blueGrey[50],
                ),
                style: const TextStyle(fontSize: 14),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter project owner name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.blue[900]!),
                        color: Colors.blueGrey[50],
                      ),
                      child: ListTile(
                        title: const Text("From"),
                        subtitle: Text("${startDate.toLocal()}".split(' ')[0]),
                        onTap: () async {
                          await _selectStartDate(context);
                        },
                        trailing: const Icon(Icons.calendar_month),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.blue[900]!),
                        color: Colors.blueGrey[50],
                      ),
                      child: ListTile(
                        title: const Text("To"),
                        subtitle: Text("${endDate.toLocal()}".split(' ')[0]),
                        onTap: () async {
                          await _selectEndDate(context);
                        },
                        trailing: const Icon(Icons.calendar_month),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: workHoursController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.workHours,
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900]!),
                    borderRadius: BorderRadius.circular(8.0),
                    gapPadding: 8.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900]!),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900]!),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.blueGrey[50],
                ),
                style: const TextStyle(fontSize: 14),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter working hours';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: teamMembersController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.teamMembers,
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900]!),
                    borderRadius: BorderRadius.circular(8.0),
                    gapPadding: 8.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900]!),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900]!),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.blueGrey[50],
                ),
                style: const TextStyle(fontSize: 14),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter team members for the project';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.numberoftasks,
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900]!),
                    borderRadius: BorderRadius.circular(8.0),
                    gapPadding: 8.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900]!),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900]!),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.blueGrey[50],
                ),
                style: const TextStyle(fontSize: 14),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of tasks';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    numberOfTasks = int.tryParse(value) ?? 0;
                    tasks.clear();
                  });
                },
              ),
              if (numberOfTasks > 0) ..._buildTaskFields(),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // print('submitting?');
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isSubmitting = true;
                        // print('set  state');
                        showSuccessAnimation = true;
                      });
                      Project newProject = Project(
                        userId: widget.userId,
                        projectName: projectNameController.text,
                        description: descriptionController.text,
                        owner: ownerController.text,
                        startDate: startDate,
                        endDate: endDate,
                        workHours: workHoursController.text,
                        teamMembers: teamMembersController.text,
                        tasks: tasks,
                      );
                      ref
                          .watch(projectsProvider.notifier)
                          .addProject(newProject, widget.userId);
                      // print('created----$projectsProvider');
                      // print('new project------$newProject');
                      setState(() {
                        isSubmitting = false;
                      });
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: isSubmitting
                      // ? Lottie.asset('assets/success.json')
                      ? const CircularProgressIndicator()
                      : Text(AppLocalizations.of(context)!.submit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTaskFields() {
    return TaskFields.buildTaskFields(
      tasks,
      numberOfTasks,
      widget.teamMembers,
      setState,
      _filterTeamMembers,
      context,
    );
  }

  // ignore: unused_element
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Lottie.asset('assets/success.json'),
          ),
        );
      },
    );
  }
}
