import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_projects/domain/model/project.dart';
import 'package:flutter_projects/domain/model/task.dart';
import 'package:flutter_projects/presentation/providers/project_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectForm extends ConsumerStatefulWidget {
  final void Function(Project) addProject;
  final List<String> teamMembers;
  final List<String> managers;
  final int userId;

  const ProjectForm({
    Key? key,
    required this.addProject,
    required this.teamMembers,
    required this.managers,
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

  late DateTime startDate;
  late DateTime endDate;
  late int numberOfTasks = 0;
  List<Task> tasks = [];

  late TextEditingController _textEditingController;
  List<String> filteredTeamMembers = [];
  List<String> filteredManagers = [];
  List<String> teamMembers = [];
  String? selectedManager;

  bool isSubmitting = false;
  bool showSuccessAnimation = false;

  bool formSubmitted = false;
  bool startDatePicked = false;
  bool endDatePicked = false;

  @override
  void initState() {
    super.initState();
    projectNameController = TextEditingController();
    descriptionController = TextEditingController();
    ownerController = TextEditingController();
    filteredManagers = widget.managers;
    workHoursController = TextEditingController();
    teamMembersController = TextEditingController();
    _textEditingController = TextEditingController();
    startDate = DateTime.now();
    endDate = DateTime.now().add(const Duration(days: 1));
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

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 15)),
      lastDate: DateTime(2025),
      helpText: 'Select Start Date',
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
        startDatePicked = true;
        if (endDate.isBefore(startDate)) {
          endDate = startDate.add(const Duration(days: 1));
          endDatePicked = true;
        }
      });
      _formKey.currentState!.validate();
    } else {
      setState(() {
        startDatePicked = false;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: startDate,
      lastDate: DateTime(2025),
      helpText: 'Select End Date',
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
        endDatePicked = true;
      });
      _formKey.currentState!.validate();
    } else {
      setState(() {
        endDatePicked = false;
      });
    }
  }

  void _addManager(String? manager) {
    if (manager != null) {
      setState(() {
        ownerController.text = manager;
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: [LengthLimitingTextInputFormatter(25)],
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
                    return AppLocalizations.of(context)!.enterprojectname;
                  }
                  if (value.length > 25) {
                    return 'Only 25 characters are allowed.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: [LengthLimitingTextInputFormatter(30)],
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
                    return AppLocalizations.of(context)!.enterprojectdesc;
                  }
                  if (value.length > 30) {
                    return 'Only 30 characters are allowed.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: startDatePicked
                            ? "${startDate.toLocal()}".split(' ')[0]
                            : AppLocalizations.of(context)!.from,
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
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_month),
                          onPressed: () => _selectStartDate(context),
                        ),
                      ),
                      style: const TextStyle(fontSize: 14),
                      validator: (value) {
                        if (!startDatePicked) {
                          return 'Enter start date';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: endDatePicked
                            ? "${endDate.toLocal()}".split(' ')[0]
                            : AppLocalizations.of(context)!.to,
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
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_month),
                          onPressed: () => _selectEndDate(context),
                        ),
                      ),
                      style: const TextStyle(fontSize: 14),
                      validator: (value) {
                        if (!endDatePicked) {
                          return 'select end date';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: workHoursController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: [LengthLimitingTextInputFormatter(3)],
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
                    return AppLocalizations.of(context)!.enterprojecthours;
                  }
                  if (value.length > 3) {
                    return 'Only 2 digits are allowed here.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      value: selectedManager,
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
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      onChanged: (newValue) {
                        setState(() {
                          selectedManager = newValue;
                        });
                        _addManager(newValue);
                      },
                      items: filteredManagers
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.enterowner;
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: teamMembersController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: [LengthLimitingTextInputFormatter(3)],
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
                    return AppLocalizations.of(context)!.entermembers;
                  }
                  if (value.length > 100) {
                    return 'Only 3 digits are allowed';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isSubmitting = true;
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
                      setState(() {
                        isSubmitting = false;
                      });
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    side: BorderSide(color: Colors.blue[900]!),
                  ),
                  child: isSubmitting
                      ? const CircularProgressIndicator()
                      : Text(
                          AppLocalizations.of(context)!.submit,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
