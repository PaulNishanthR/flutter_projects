// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_projects/domain/model/project.dart';
// // import 'package:flutter_projects/domain/model/task.dart';
// // import 'package:flutter_projects/presentation/providers/project_provider.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// // class ProjectForm extends ConsumerStatefulWidget {
// //   final void Function(Project) addProject;
// //   final List<String> teamMembers;
// //   final List<String> managers;
// //   final int userId;

// //   const ProjectForm({
// //     Key? key,
// //     required this.addProject,
// //     required this.teamMembers,
// //     required this.managers,
// //     required this.userId,
// //   }) : super(key: key);

// //   @override
// //   ConsumerState<ProjectForm> createState() => _ProjectFormState();
// // }

// // class _ProjectFormState extends ConsumerState<ProjectForm> {
// //   final _formKey = GlobalKey<FormState>();

// //   late TextEditingController projectNameController;
// //   late TextEditingController descriptionController;
// //   late TextEditingController ownerController;
// //   late TextEditingController workHoursController;
// //   late TextEditingController teamMembersController;

// //   late DateTime startDate;
// //   late DateTime endDate;
// //   late int numberOfTasks = 0;
// //   List<Task> tasks = [];

// //   late TextEditingController _textEditingController;
// //   List<String> filteredTeamMembers = [];
// //   List<String> filteredManagers = [];
// //   List<String> teamMembers = [];
// //   String? selectedManager;

// //   bool isSubmitting = false;
// //   bool showSuccessAnimation = false;

// //   bool formSubmitted = false;
// //   bool startDatePicked = false;
// //   bool endDatePicked = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     projectNameController = TextEditingController();
// //     descriptionController = TextEditingController();
// //     ownerController = TextEditingController();
// //     filteredManagers = widget.managers;
// //     workHoursController = TextEditingController();
// //     teamMembersController = TextEditingController();
// //     _textEditingController = TextEditingController();
// //     startDate = DateTime.now();
// //     endDate = DateTime.now().add(const Duration(days: 1));
// //   }

// //   @override
// //   void dispose() {
// //     projectNameController.dispose();
// //     descriptionController.dispose();
// //     ownerController.dispose();
// //     workHoursController.dispose();
// //     teamMembersController.dispose();
// //     _textEditingController.dispose();
// //     super.dispose();
// //   }

// //   void addTask(Task task) {
// //     setState(() {
// //       tasks.add(task);
// //     });
// //   }

// //   Future<void> _selectStartDate(BuildContext context) async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: startDate,
// //       firstDate: DateTime.now().subtract(const Duration(days: 15)),
// //       lastDate: DateTime(2025),
// //       helpText: 'Select Start Date',
// //     );
// //     if (picked != null && picked != startDate) {
// //       setState(() {
// //         startDate = picked;
// //         startDatePicked = true;
// //         if (endDate.isBefore(startDate)) {
// //           endDate = startDate.add(const Duration(days: 1));
// //           endDatePicked = true;
// //         }
// //       });
// //       _formKey.currentState!.validate();
// //     } else {
// //       setState(() {
// //         startDatePicked = false;
// //       });
// //     }
// //   }

// //   Future<void> _selectEndDate(BuildContext context) async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: endDate,
// //       firstDate: startDate,
// //       lastDate: DateTime(2025),
// //       helpText: 'Select End Date',
// //     );
// //     if (picked != null && picked != endDate) {
// //       setState(() {
// //         endDate = picked;
// //         endDatePicked = true;
// //       });
// //       _formKey.currentState!.validate();
// //     } else {
// //       setState(() {
// //         endDatePicked = false;
// //       });
// //     }
// //   }

// //   void _addManager(String? manager) {
// //     if (manager != null) {
// //       setState(() {
// //         ownerController.text = manager;
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               TextFormField(
// //                 controller: projectNameController,
// //                 autovalidateMode: AutovalidateMode.onUserInteraction,
// //                 inputFormatters: [LengthLimitingTextInputFormatter(25)],
// //                 decoration: InputDecoration(
// //                   labelText: AppLocalizations.of(context)!.projectName,
// //                   labelStyle: const TextStyle(color: Colors.black),
// //                   border: OutlineInputBorder(
// //                     borderSide: BorderSide(color: Colors.purple.shade300),
// //                     borderRadius: BorderRadius.circular(8.0),
// //                     gapPadding: 8.0,
// //                   ),
// //                   enabledBorder: OutlineInputBorder(
// //                     borderSide: BorderSide(color: Colors.purple.shade300),
// //                     borderRadius: BorderRadius.circular(8.0),
// //                   ),
// //                   focusedBorder: OutlineInputBorder(
// //                     borderSide: BorderSide(color: Colors.purple.shade300),
// //                     borderRadius: BorderRadius.circular(8.0),
// //                   ),
// //                   filled: true,
// //                   fillColor: const Color.fromARGB(255, 240, 234, 238),
// //                 ),
// //                 style: const TextStyle(fontSize: 14),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return AppLocalizations.of(context)!.enterprojectname;
// //                   }
// //                   if (value.length > 25) {
// //                     return 'Only 25 characters are allowed.';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               const SizedBox(height: 12),
// //               TextFormField(
// //                 controller: descriptionController,
// //                 autovalidateMode: AutovalidateMode.onUserInteraction,
// //                 inputFormatters: [LengthLimitingTextInputFormatter(30)],
// //                 decoration: InputDecoration(
// //                   labelText: AppLocalizations.of(context)!.description,
// //                   labelStyle: const TextStyle(color: Colors.black),
// //                   border: OutlineInputBorder(
// //                     borderSide: BorderSide(color: Colors.purple.shade300),
// //                     borderRadius: BorderRadius.circular(8.0),
// //                     gapPadding: 8.0,
// //                   ),
// //                   enabledBorder: OutlineInputBorder(
// //                     borderSide: BorderSide(color: Colors.purple.shade300),
// //                     borderRadius: BorderRadius.circular(8.0),
// //                   ),
// //                   focusedBorder: OutlineInputBorder(
// //                     borderSide: BorderSide(color: Colors.purple.shade300),
// //                     borderRadius: BorderRadius.circular(8.0),
// //                   ),
// //                   filled: true,
// //                   fillColor: const Color.fromARGB(255, 240, 234, 238),
// //                 ),
// //                 style: const TextStyle(fontSize: 14),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return AppLocalizations.of(context)!.enterprojectdesc;
// //                   }
// //                   if (value.length > 30) {
// //                     return 'Only 30 characters are allowed.';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               const SizedBox(height: 16.0),
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     child: TextFormField(
// //                       readOnly: true,
// //                       autovalidateMode: AutovalidateMode.onUserInteraction,
// //                       decoration: InputDecoration(
// //                         labelText: startDatePicked
// //                             ? "${startDate.toLocal()}".split(' ')[0]
// //                             : AppLocalizations.of(context)!.from,
// //                         labelStyle: const TextStyle(color: Colors.black),
// //                         border: OutlineInputBorder(
// //                           borderSide: BorderSide(color: Colors.purple.shade300),
// //                           borderRadius: BorderRadius.circular(8.0),
// //                           gapPadding: 8.0,
// //                         ),
// //                         enabledBorder: OutlineInputBorder(
// //                           borderSide: BorderSide(color: Colors.purple.shade300),
// //                           borderRadius: BorderRadius.circular(8.0),
// //                         ),
// //                         focusedBorder: OutlineInputBorder(
// //                           borderSide: BorderSide(color: Colors.purple.shade300),
// //                           borderRadius: BorderRadius.circular(8.0),
// //                         ),
// //                         filled: true,
// //                         fillColor: const Color.fromARGB(255, 240, 234, 238),
// //                         suffixIcon: IconButton(
// //                           icon: const Icon(
// //                             Icons.calendar_month,
// //                             color: Colors.black,
// //                           ),
// //                           onPressed: () => _selectStartDate(context),
// //                         ),
// //                       ),
// //                       style: const TextStyle(fontSize: 14),
// //                       validator: (value) {
// //                         if (!startDatePicked) {
// //                           return AppLocalizations.of(context)!
// //                               .pleaseenterstartdate;
// //                         }
// //                         return null;
// //                       },
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 16.0),
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     child: TextFormField(
// //                       readOnly: true,
// //                       autovalidateMode: AutovalidateMode.onUserInteraction,
// //                       decoration: InputDecoration(
// //                         labelText: endDatePicked
// //                             ? "${endDate.toLocal()}".split(' ')[0]
// //                             : AppLocalizations.of(context)!.to,
// //                         labelStyle: const TextStyle(color: Colors.black),
// //                         border: OutlineInputBorder(
// //                           borderSide: BorderSide(color: Colors.purple.shade300),
// //                           borderRadius: BorderRadius.circular(8.0),
// //                           gapPadding: 8.0,
// //                         ),
// //                         enabledBorder: OutlineInputBorder(
// //                           borderSide: BorderSide(color: Colors.purple.shade300),
// //                           borderRadius: BorderRadius.circular(8.0),
// //                         ),
// //                         focusedBorder: OutlineInputBorder(
// //                           borderSide: BorderSide(color: Colors.purple.shade300),
// //                           borderRadius: BorderRadius.circular(8.0),
// //                         ),
// //                         filled: true,
// //                         fillColor: const Color.fromARGB(255, 240, 234, 238),
// //                         suffixIcon: IconButton(
// //                           icon: const Icon(
// //                             Icons.calendar_month,
// //                             color: Colors.black,
// //                           ),
// //                           onPressed: () => _selectEndDate(context),
// //                         ),
// //                       ),
// //                       style: const TextStyle(fontSize: 14),
// //                       validator: (value) {
// //                         if (!endDatePicked) {
// //                           return AppLocalizations.of(context)!
// //                               .pleaseenterenddate;
// //                         }
// //                         return null;
// //                       },
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 12),
// //               TextFormField(
// //                 controller: workHoursController,
// //                 autovalidateMode: AutovalidateMode.onUserInteraction,
// //                 inputFormatters: [LengthLimitingTextInputFormatter(4)],
// //                 decoration: InputDecoration(
// //                   labelText: AppLocalizations.of(context)!.workHours,
// //                   labelStyle: const TextStyle(color: Colors.black),
// //                   border: OutlineInputBorder(
// //                     borderSide: BorderSide(color: Colors.purple.shade300),
// //                     borderRadius: BorderRadius.circular(8.0),
// //                     gapPadding: 8.0,
// //                   ),
// //                   enabledBorder: OutlineInputBorder(
// //                     borderSide: BorderSide(color: Colors.purple.shade300),
// //                     borderRadius: BorderRadius.circular(8.0),
// //                   ),
// //                   focusedBorder: OutlineInputBorder(
// //                     borderSide: BorderSide(color: Colors.purple.shade300),
// //                     borderRadius: BorderRadius.circular(8.0),
// //                   ),
// //                   filled: true,
// //                   fillColor: const Color.fromARGB(255, 240, 234, 238),
// //                 ),
// //                 style: const TextStyle(fontSize: 14),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return AppLocalizations.of(context)!.enterprojecthours;
// //                   }
// //                   if (value.length > 4) {
// //                     return 'Only 4 digits are allowed here.';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               const SizedBox(height: 12),
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     child: DropdownButtonFormField(
// //                       autovalidateMode: AutovalidateMode.onUserInteraction,
// //                       value: selectedManager,
// //                       decoration: InputDecoration(
// //                         labelText: AppLocalizations.of(context)!.projectOwner,
// //                         labelStyle: const TextStyle(color: Colors.black),
// //                         border: OutlineInputBorder(
// //                           borderSide: BorderSide(color: Colors.purple.shade300),
// //                           borderRadius: BorderRadius.circular(8.0),
// //                           gapPadding: 8.0,
// //                         ),
// //                         enabledBorder: OutlineInputBorder(
// //                           borderSide: BorderSide(color: Colors.purple.shade300),
// //                           borderRadius: BorderRadius.circular(8.0),
// //                         ),
// //                         focusedBorder: OutlineInputBorder(
// //                           borderSide: BorderSide(color: Colors.purple.shade300),
// //                           borderRadius: BorderRadius.circular(8.0),
// //                         ),
// //                         filled: true,
// //                         fillColor: const Color.fromARGB(255, 240, 234, 238),
// //                       ),
// //                       style: const TextStyle(fontSize: 14, color: Colors.black),
// //                       onChanged: (newValue) {
// //                         setState(() {
// //                           selectedManager = newValue;
// //                         });
// //                         _addManager(newValue);
// //                       },
// //                       items: filteredManagers
// //                           .map<DropdownMenuItem<String>>((String value) {
// //                         return DropdownMenuItem<String>(
// //                           value: value,
// //                           child: Text(value),
// //                         );
// //                       }).toList(),
// //                       validator: (value) {
// //                         if (value == null || value.isEmpty) {
// //                           return AppLocalizations.of(context)!.enterowner;
// //                         }
// //                         return null;
// //                       },
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 12),
// //               TextFormField(
// //                 controller: teamMembersController,
// //                 autovalidateMode: AutovalidateMode.onUserInteraction,
// //                 inputFormatters: [LengthLimitingTextInputFormatter(2)],
// //                 decoration: InputDecoration(
// //                   labelText: AppLocalizations.of(context)!.teamMembers,
// //                   labelStyle: const TextStyle(color: Colors.black),
// //                   border: OutlineInputBorder(
// //                     borderSide: BorderSide(color: Colors.purple.shade300),
// //                     borderRadius: BorderRadius.circular(8.0),
// //                     gapPadding: 8.0,
// //                   ),
// //                   enabledBorder: OutlineInputBorder(
// //                     borderSide: BorderSide(color: Colors.purple.shade300),
// //                     borderRadius: BorderRadius.circular(8.0),
// //                   ),
// //                   focusedBorder: OutlineInputBorder(
// //                     borderSide: BorderSide(color: Colors.purple.shade300),
// //                     borderRadius: BorderRadius.circular(8.0),
// //                   ),
// //                   filled: true,
// //                   fillColor: const Color.fromARGB(255, 240, 234, 238),
// //                 ),
// //                 style: const TextStyle(fontSize: 14),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return AppLocalizations.of(context)!.entermembers;
// //                   }
// //                   if (value.length > 2) {
// //                     return 'Only 2 digits are allowed';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               const SizedBox(height: 20),
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   ElevatedButton(
// //                     onPressed: () {
// //                       Navigator.pop(context);
// //                     },
// //                     style: ElevatedButton.styleFrom(
// //                         // backgroundColor: Colors.purple.shade300,
// //                         padding: const EdgeInsets.symmetric(
// //                             horizontal: 38, vertical: 16),
// //                         side: BorderSide(color: Colors.purple.shade300)),
// //                     child: Text(
// //                       'Back',
// //                       style: TextStyle(color: Colors.purple.shade300),
// //                     ),
// //                   ),
// //                   ElevatedButton(
// //                     onPressed: () async {
// //                       if (_formKey.currentState!.validate()) {
// //                         setState(() {
// //                           isSubmitting = true;
// //                           showSuccessAnimation = true;
// //                         });
// //                         Project newProject = Project(
// //                           userId: widget.userId,
// //                           projectName: projectNameController.text,
// //                           description: descriptionController.text,
// //                           owner: ownerController.text,
// //                           startDate: startDate,
// //                           endDate: endDate,
// //                           workHours: workHoursController.text,
// //                           teamMembers: teamMembersController.text,
// //                           tasks: tasks,
// //                         );
// //                         ref
// //                             .watch(projectsProvider.notifier)
// //                             .addProject(newProject, widget.userId);
// //                         setState(() {
// //                           isSubmitting = false;
// //                         });
// //                         Navigator.pop(context);
// //                       }
// //                     },
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.purple.shade300,
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 32, vertical: 16),
// //                     ),
// //                     child: isSubmitting
// //                         ? const CircularProgressIndicator()
// //                         : Text(
// //                             AppLocalizations.of(context)!.submit,
// //                             style: const TextStyle(
// //                                 fontSize: 16, color: Colors.white),
// //                           ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_projects/domain/model/project/project.dart';
import 'package:flutter_projects/domain/model/project/task.dart';
import 'package:flutter_projects/presentation/providers/project/project_provider.dart';
// import 'package:flutter_projects/presentation/providers/project_provider.dart';
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
  List<Task> tasks = [];

  late TextEditingController _textEditingController;
  List<String> filteredTeamMembers = [];
  List<String> filteredManagers = [];
  String? selectedManager;

  bool isSubmitting = false;
  bool showSuccessAnimation = false;

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
      helpText: AppLocalizations.of(context)!.selectStartDate,
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
        startDatePicked = true;
        if (endDate.isBefore(startDate)) {
          endDate = startDate.add(const Duration(days: 1));
          // endDatePicked = true;
        }
      });
      // _formKey.currentState!.validate();
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: startDate,
      lastDate: DateTime(2025),
      helpText: AppLocalizations.of(context)!.selectEndDate,
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
        endDatePicked = true;
      });
      // _formKey.currentState!.validate();
    }
  }

  void _addManager(String? manager) {
    if (manager != null) {
      setState(() {
        selectedManager = manager;
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
              _buildTextFormField(
                controller: projectNameController,
                labelText: AppLocalizations.of(context)!.projectName,
                maxLength: 25,
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
              _buildTextFormField(
                controller: descriptionController,
                labelText: AppLocalizations.of(context)!.description,
                maxLength: 30,
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
              _buildDateFormField(
                context: context,
                labelText: startDate.toLocal().toString().split(' ')[0],
                pickDate: _selectStartDate,
                validator: (value) {
                  if (!startDatePicked) {
                    return AppLocalizations.of(context)!.pleaseenterstartdate;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              _buildDateFormField(
                context: context,
                labelText: endDate.toLocal().toString().split(' ')[0],
                pickDate: _selectEndDate,
                validator: (value) {
                  if (!endDatePicked) {
                    return AppLocalizations.of(context)!.pleaseenterenddate;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildTextFormField(
                controller: workHoursController,
                labelText: AppLocalizations.of(context)!.workHours,
                maxLength: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.enterprojecthours;
                  }
                  if (value.length > 4) {
                    return 'Only 4 digits are allowed.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildDropdownFormField(
                context: context,
                value: selectedManager,
                items: filteredManagers,
                onChanged: (newValue) {
                  setState(() {
                    selectedManager = newValue;
                  });
                  _addManager(newValue);
                  _formKey.currentState!.validate();
                },
                labelText: AppLocalizations.of(context)!.projectOwner,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.enterowner;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildTextFormField(
                controller: teamMembersController,
                labelText: AppLocalizations.of(context)!.teamMembers,
                maxLength: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.entermembers;
                  }
                  if (value.length > 2) {
                    return 'Only 2 digits are allowed';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required int maxLength,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.purple.shade300),
          borderRadius: BorderRadius.circular(8.0),
          gapPadding: 8.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.purple.shade300),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.purple.shade300),
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 240, 234, 238),
      ),
      style: const TextStyle(fontSize: 14),
      validator: validator,
    );
  }

  // Widget _buildDateFormField({
  //   required BuildContext context,
  //   required String labelText,
  //   required Future<void> Function(BuildContext) pickDate,
  //   required String? Function(String?) validator,
  // }) {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: TextFormField(
  //           readOnly: true,
  //           autovalidateMode: AutovalidateMode.onUserInteraction,
  //           decoration: InputDecoration(
  //             labelText: labelText,
  //             labelStyle: const TextStyle(color: Colors.black),
  //             border: OutlineInputBorder(
  //               borderSide: BorderSide(color: Colors.purple.shade300),
  //               borderRadius: BorderRadius.circular(8.0),
  //               gapPadding: 8.0,
  //             ),
  //             enabledBorder: OutlineInputBorder(
  //               borderSide: BorderSide(color: Colors.purple.shade300),
  //               borderRadius: BorderRadius.circular(8.0),
  //             ),
  //             focusedBorder: OutlineInputBorder(
  //               borderSide: BorderSide(color: Colors.purple.shade300),
  //               borderRadius: BorderRadius.circular(8.0),
  //             ),
  //             filled: true,
  //             fillColor: const Color.fromARGB(255, 240, 234, 238),
  //             suffixIcon: IconButton(
  //               onPressed: () => pickDate(context),
  //               icon: const Icon(Icons.calendar_month),
  //               color: Colors.purple.shade300,
  //             ),
  //           ),
  //           onTap: () => pickDate(context),
  //           validator: validator,
  //           // onChanged: (value) {
  //           //   _formKey.currentState!.validate();
  //           // },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildDateFormField({
    required BuildContext context,
    required String labelText,
    required Future<void> Function(BuildContext) pickDate,
    required String? Function(String?) validator,
  }) {
    return GestureDetector(
      onTap: () => pickDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          decoration: InputDecoration(
              labelText: labelText,
              labelStyle: const TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purple.shade300),
                borderRadius: BorderRadius.circular(8.0),
                gapPadding: 8.0,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purple.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purple.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 240, 234, 238),
              suffixIcon: const Icon(
                Icons.calendar_month,
                color: Colors.purple,
              )),
        ),
      ),
    );
  }

  Widget _buildDropdownFormField({
    required BuildContext context,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required String labelText,
    required String? Function(String?) validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      icon: const Icon(
        Icons.arrow_downward,
        color: Colors.purple,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.purple.shade300),
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.purple.shade300),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.purple.shade300),
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 240, 234, 238),
      ),
      validator: validator,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            AppLocalizations.of(context)!.back,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        ElevatedButton(
          onPressed: isSubmitting ? null : _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            AppLocalizations.of(context)!.save,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isSubmitting = true;
      });

      Project newProject = Project(
        projectName: projectNameController.text,
        description: descriptionController.text,
        startDate: startDate,
        endDate: endDate,
        userId: widget.userId,
        owner: ownerController.text,
        teamMembers: teamMembersController.text,
        workHours: workHoursController.text,
        tasks: tasks,
      );

      await ref
          .read(projectsProvider.notifier)
          .addProject(newProject, widget.userId);
      widget.addProject(newProject);

      setState(() {
        isSubmitting = false;
        showSuccessAnimation = true;
      });
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}
