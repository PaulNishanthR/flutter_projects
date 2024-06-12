// //project form working good--->
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

  late DateTime startDate = DateTime.now();
  late DateTime endDate = DateTime.now();
  // late DateTime projectEndDate;
  late int numberOfTasks = 0;
  List<Task> tasks = [];

  late TextEditingController _textEditingController;
  List<String> filteredTeamMembers = [];
  List<String> filteredManagers = [];
  List<String> teamMembers = [];

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

  // void _filterTeamMembers(String query) {
  //   setState(() {
  //     filteredTeamMembers = widget.teamMembers
  //         .where((member) => member.toLowerCase().contains(query.toLowerCase()))
  //         .toList();
  //   });
  // }

  void _filterManagers(String query) {
    setState(() {
      filteredManagers = widget.managers
          .where(
              (manager) => manager.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 15)),
      lastDate: DateTime(2025),
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
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: startDate,
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
        endDatePicked = true;
      });
    }
  }

  // void _addTeamMember(String member) {
  //   setState(() {
  //     for (int i = 0; i < tasks.length; i++) {
  //       if (!tasks[i].teamMembers!.contains(member)) {
  //         tasks[i].teamMembers!.add(member);
  //       }
  //     }
  //     _textEditingController.clear();
  //   });
  // }

  void _addManager(String? manager) {
    if (manager != null) {
      setState(() {
        ownerController.text = manager;
      });
    }
  }

  String? _validateDates() {
    if (!startDatePicked || !endDatePicked) {
      if (formSubmitted) {
        return 'Select dates';
      }
    }
    return null;
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
              const SizedBox(height: 12),
              //Date Field--->
              // Row(
              //   children: [
              //     Expanded(
              //       child: Container(
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(8.0),
              //           border: Border.all(color: Colors.blue[900]!),
              //           color: Colors.blueGrey[50],
              //         ),
              //         child: ListTile(
              //           title: Text(AppLocalizations.of(context)!.from),
              //           subtitle: Text("${startDate.toLocal()}".split(' ')[0]),
              //           onTap: () async {
              //             await _selectStartDate(context);
              //           },
              //           trailing: const Icon(Icons.calendar_month),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 12),
              //     Expanded(
              //       child: Container(
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(8.0),
              //           border: Border.all(color: Colors.blue[900]!),
              //           color: Colors.blueGrey[50],
              //         ),
              //         child: ListTile(
              //           title: Text(AppLocalizations.of(context)!.to),
              //           subtitle: Text("${endDate.toLocal()}".split(' ')[0]),
              //           onTap: () async {
              //             await _selectEndDate(context);
              //           },
              //           trailing: const Icon(Icons.calendar_month),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.blue[900]!),
                  color: Colors.blueGrey[50],
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(AppLocalizations.of(context)!.from),
                      subtitle: Text("${startDate.toLocal()}".split(' ')[0]),
                      onTap: () async {
                        await _selectStartDate(context);
                      },
                      trailing: const Icon(Icons.calendar_month),
                    ),
                    ListTile(
                      title: Text(AppLocalizations.of(context)!.to),
                      subtitle: Text("${endDate.toLocal()}".split(' ')[0]),
                      onTap: () async {
                        await _selectEndDate(context);
                      },
                      trailing: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
              if (_validateDates() != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _validateDates()!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
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
                    child: TextFormField(
                      controller: ownerController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        suffixIcon: DropdownButton<String>(
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          onChanged: _addManager,
                          items: filteredManagers
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      style: const TextStyle(fontSize: 14),
                      onChanged: _filterManagers,
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
              // const SizedBox(height: 12),
              // TextFormField(
              //   autovalidateMode: AutovalidateMode.onUserInteraction,
              //   inputFormatters: [LengthLimitingTextInputFormatter(2)],
              //   decoration: InputDecoration(
              //     labelText: AppLocalizations.of(context)!.numberoftasks,
              //     labelStyle: const TextStyle(color: Colors.black),
              //     border: OutlineInputBorder(
              //       borderSide: BorderSide(color: Colors.blue[900]!),
              //       borderRadius: BorderRadius.circular(8.0),
              //       gapPadding: 8.0,
              //     ),
              //     enabledBorder: OutlineInputBorder(
              //       borderSide: BorderSide(color: Colors.blue[900]!),
              //       borderRadius: BorderRadius.circular(8.0),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: BorderSide(color: Colors.blue[900]!),
              //       borderRadius: BorderRadius.circular(8.0),
              //     ),
              //     filled: true,
              //     fillColor: Colors.blueGrey[50],
              //   ),
              //   style: const TextStyle(fontSize: 14),
              //   keyboardType: TextInputType.number,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter the number of tasks';
              //     }
              //     if (value.length > 2) {
              //       return 'Only 2 digits are allowed';
              //     }
              //     return null;
              //   },
              //   onChanged: (value) {
              //     setState(() {
              //       numberOfTasks = int.tryParse(value) ?? 0;
              //       tasks.clear();
              //     });
              //   },
              // ),
              // if (numberOfTasks > 0)
              //   ..._buildTaskFields(endDate, _addTeamMember),
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

/// this is second attempt, but not working ***drop down looks good*** --->
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_projects/domain/model/project.dart';
// import 'package:flutter_projects/domain/model/task.dart';
// import 'package:flutter_projects/presentation/providers/project_provider.dart';
// import 'package:flutter_projects/presentation/providers/allocation_provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class ProjectForm extends ConsumerStatefulWidget {
//   final void Function(Project) addProject;
//   final List<String> teamMembers;
//   final List<String> managers;
//   final int userId;

//   const ProjectForm({
//     Key? key,
//     required this.addProject,
//     required this.teamMembers,
//     required this.managers,
//     required this.userId,
//   }) : super(key: key);

//   @override
//   ConsumerState<ProjectForm> createState() => _ProjectFormState();
// }

// class _ProjectFormState extends ConsumerState<ProjectForm> {
//   final _formKey = GlobalKey<FormState>();

//   late TextEditingController projectNameController;
//   late TextEditingController descriptionController;
//   late TextEditingController ownerController;
//   late TextEditingController workHoursController;
//   late TextEditingController teamMembersController;

//   late DateTime startDate = DateTime.now();
//   late DateTime endDate = DateTime.now();
//   late int numberOfTasks = 0;
//   List<Task> tasks = [];

//   late TextEditingController _textEditingController;
//   List<String> filteredTeamMembers = [];
//   List<String> filteredManagers = [];

//   bool isSubmitting = false;
//   bool showSuccessAnimation = false;

//   bool formSubmitted = false;
//   bool startDatePicked = false;
//   bool endDatePicked = false;

//   @override
//   void initState() {
//     super.initState();
//     projectNameController = TextEditingController();
//     descriptionController = TextEditingController();
//     ownerController = TextEditingController();
//     filteredManagers = widget.managers;
//     workHoursController = TextEditingController();
//     teamMembersController = TextEditingController();
//     _textEditingController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     projectNameController.dispose();
//     descriptionController.dispose();
//     ownerController.dispose();
//     workHoursController.dispose();
//     teamMembersController.dispose();
//     _textEditingController.dispose();
//     super.dispose();
//   }

//   void addTask(Task task) {
//     setState(() {
//       tasks.add(task);
//     });
//   }

//   void _filterTeamMembers(String query) {
//     setState(() {
//       filteredTeamMembers = widget.teamMembers
//           .where((member) => member.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }

//   void _filterManagers(String query) {
//     setState(() {
//       filteredManagers = widget.managers
//           .where(
//               (manager) => manager.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }

//   Future<void> _selectStartDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: startDate,
//       firstDate: DateTime.now().subtract(const Duration(days: 15)),
//       lastDate: DateTime(2025),
//     );
//     if (picked != null && picked != startDate) {
//       setState(() {
//         startDate = picked;
//         startDatePicked = true;
//         if (endDate.isBefore(startDate)) {
//           endDate = startDate.add(const Duration(days: 1));
//           endDatePicked = true;
//         }
//       });
//     }
//   }

//   Future<void> _selectEndDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: endDate,
//       firstDate: startDate,
//       lastDate: DateTime(2025),
//     );
//     if (picked != null && picked != endDate) {
//       setState(() {
//         endDate = picked;
//         endDatePicked = true;
//       });
//     }
//   }

//   void _addTeamMember(String member) {
//     if (!ref.read(allocationProvider.notifier).isAllocated(member)) {
//       setState(() {
//         for (int i = 0; i < tasks.length; i++) {
//           if (!tasks[i].teamMembers!.contains(member)) {
//             tasks[i].teamMembers!.add(member);
//             ref.read(allocationProvider.notifier).allocate(member);
//           }
//         }
//         _textEditingController.clear();
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content:
//               Text('$member is already allocated to another project\'s task.'),
//         ),
//       );
//     }
//   }

//   void _addManager(String? manager) {
//     if (manager != null) {
//       setState(() {
//         ownerController.text = manager;
//       });
//     }
//   }

//   String? _validateDates() {
//     if (!startDatePicked || !endDatePicked) {
//       if (formSubmitted) {
//         return 'Select dates';
//       }
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             TextFormField(
//               controller: projectNameController,
//               autovalidateMode: AutovalidateMode.onUserInteraction,
//               inputFormatters: [LengthLimitingTextInputFormatter(25)],
//               decoration: InputDecoration(
//                 labelText: AppLocalizations.of(context)!.projectName,
//                 labelStyle: const TextStyle(color: Colors.black),
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.blue[900]!),
//                   borderRadius: BorderRadius.circular(8.0),
//                   gapPadding: 8.0,
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.blue[900]!),
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.blue[900]!),
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 filled: true,
//                 fillColor: Colors.blueGrey[50],
//               ),
//               style: const TextStyle(fontSize: 14),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return AppLocalizations.of(context)!.enterprojectname;
//                 }
//                 if (value.length > 25) {
//                   return 'Only 25 characters are allowed.';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 12),
//             TextFormField(
//               controller: descriptionController,
//               autovalidateMode: AutovalidateMode.onUserInteraction,
//               inputFormatters: [LengthLimitingTextInputFormatter(30)],
//               decoration: InputDecoration(
//                 labelText: AppLocalizations.of(context)!.description,
//                 labelStyle: const TextStyle(color: Colors.black),
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.blue[900]!),
//                   borderRadius: BorderRadius.circular(8.0),
//                   gapPadding: 8.0,
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.blue[900]!),
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.blue[900]!),
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 filled: true,
//                 fillColor: Colors.blueGrey[50],
//               ),
//               style: const TextStyle(fontSize: 14),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return AppLocalizations.of(context)!.enterprojectdesc;
//                 }
//                 if (value.length > 30) {
//                   return 'Only 30 characters are allowed.';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 12),
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8.0),
//                 color: Colors.blueGrey[50],
//                 border: Border.all(
//                   color: Colors.blue[900]!,
//                   width: 1.0,
//                 ),
//               ),
//               child: Autocomplete<String>(
//                 optionsBuilder: (TextEditingValue textEditingValue) {
//                   if (textEditingValue.text.isEmpty) {
//                     return const Iterable<String>.empty();
//                   }
//                   return filteredManagers.where((String manager) {
//                     return manager
//                         .toLowerCase()
//                         .contains(textEditingValue.text.toLowerCase());
//                   });
//                 },
//                 displayStringForOption: (String option) => option,
//                 fieldViewBuilder: (BuildContext context,
//                     TextEditingController fieldTextEditingController,
//                     FocusNode fieldFocusNode,
//                     VoidCallback onFieldSubmitted) {
//                   return TextFormField(
//                     controller: fieldTextEditingController,
//                     focusNode: fieldFocusNode,
//                     decoration: InputDecoration(
//                       labelText: 'Project Owner',
//                       labelStyle: const TextStyle(color: Colors.black),
//                       border: InputBorder.none,
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 12.0, horizontal: 12.0),
//                     ),
//                     style: const TextStyle(fontSize: 14),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter a project owner.';
//                       }
//                       return null;
//                     },
//                   );
//                 },
//                 onSelected: (String selection) {
//                   _addManager(selection);
//                 },
//               ),
//             ),
//             const SizedBox(height: 12),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ElevatedButton(
//                   onPressed: () => _selectStartDate(context),
//                   child: Text(startDatePicked
//                       ? 'Start Date: ${startDate.toLocal()}'.split(' ')[0]
//                       : 'Select Start Date'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => _selectEndDate(context),
//                   child: Text(endDatePicked
//                       ? 'End Date: ${endDate.toLocal()}'.split(' ')[0]
//                       : 'Select End Date'),
//                 ),
//                 if (_validateDates() != null)
//                   Text(
//                     _validateDates()!,
//                     style: const TextStyle(color: Colors.red),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             TextFormField(
//               controller: workHoursController,
//               keyboardType: TextInputType.number,
//               inputFormatters: [
//                 FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
//               ],
//               decoration: InputDecoration(
//                 labelText: 'Work Hours',
//                 labelStyle: const TextStyle(color: Colors.black),
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.blue[900]!),
//                   borderRadius: BorderRadius.circular(8.0),
//                   gapPadding: 8.0,
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.blue[900]!),
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.blue[900]!),
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 filled: true,
//                 fillColor: Colors.blueGrey[50],
//               ),
//               style: const TextStyle(fontSize: 14),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter work hours.';
//                 }
//                 if (int.tryParse(value) == null) {
//                   return 'Please enter a valid number.';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 12),
//             TextFormField(
//               controller: _textEditingController,
//               decoration: InputDecoration(
//                 labelText: 'Search Team Members',
//                 labelStyle: const TextStyle(color: Colors.black),
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.blue[900]!),
//                   borderRadius: BorderRadius.circular(8.0),
//                   gapPadding: 8.0,
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.blue[900]!),
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.blue[900]!),
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 filled: true,
//                 fillColor: Colors.blueGrey[50],
//               ),
//               style: const TextStyle(fontSize: 14),
//               onChanged: _filterTeamMembers,
//             ),
//             const SizedBox(height: 12),
//             Wrap(
//               spacing: 8.0,
//               runSpacing: 4.0,
//               children: filteredTeamMembers.map((member) {
//                 return InputChip(
//                   label: Text(member),
//                   onPressed: () => _addTeamMember(member),
//                 );
//               }).toList(),
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: isSubmitting
//                   ? null
//                   : () {
//                       if (_formKey.currentState!.validate() &&
//                           startDatePicked &&
//                           endDatePicked) {
//                         // final newProject = Project(
//                         //   projectName: projectNameController.text,
//                         //   description: descriptionController.text,
//                         //   startDate: startDate,
//                         //   endDate: endDate,
//                         //   owner: ownerController.text,
//                         //   numberOfTasks: numberOfTasks,
//                         //   // teamMembers: teamMembersController.text,
//                         //   tasks: tasks,
//                         //   userId: widget.userId,
//                         //   // workHours: int.parse(workHoursController.text),
//                         //   workHours: workHoursController.text,
//                         // );
//                         Project newProject = Project(
//                           userId: widget.userId,
//                           projectName: projectNameController.text,
//                           description: descriptionController.text,
//                           owner: ownerController.text,
//                           startDate: startDate,
//                           endDate: endDate,
//                           workHours: workHoursController.text,
//                           teamMembers: teamMembersController.text,
//                           tasks: tasks,
//                         );
//                         //           widget.addProject(newProject);
//                         //           setState(() {
//                         //             showSuccessAnimation = true;
//                         //           });
//                         //         }
//                         //       },
//                         // child:
//                         const Text('Create Project');
//                         ref
//                             .watch(projectsProvider.notifier)
//                             .addProject(newProject, widget.userId);
//                         setState(() {
//                           isSubmitting = false;
//                         });
//                         Navigator.pop(context);
//                       }
//                     },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//                 side: BorderSide(color: Colors.blue[900]!),
//               ),
//               child: isSubmitting
//                   ? const CircularProgressIndicator()
//                   : Text(
//                       AppLocalizations.of(context)!.submit,
//                       style: const TextStyle(fontSize: 16, color: Colors.black),
//                     ),
//             ),
//             // ),
//           ]),
//           // ],
//         ),
//       ),
//       // ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_projects/domain/model/project.dart';
// import 'package:flutter_projects/domain/model/task.dart';
// import 'package:flutter_projects/presentation/providers/project_provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// // Global list to track allocated team members
// List<String> allocatedTeamMembers = [];

// class ProjectForm extends ConsumerStatefulWidget {
//   final void Function(Project) addProject;
//   final List<String> teamMembers;
//   final List<String> managers;
//   final int userId;

//   const ProjectForm({
//     Key? key,
//     required this.addProject,
//     required this.teamMembers,
//     required this.managers,
//     required this.userId,
//   }) : super(key: key);

//   @override
//   ConsumerState<ProjectForm> createState() => _ProjectFormState();
// }

// class _ProjectFormState extends ConsumerState<ProjectForm> {
//   final _formKey = GlobalKey<FormState>();

//   late TextEditingController projectNameController;
//   late TextEditingController descriptionController;
//   late TextEditingController ownerController;
//   late TextEditingController workHoursController;
//   late TextEditingController teamMembersController;

//   late DateTime startDate = DateTime.now();
//   late DateTime endDate = DateTime.now();
//   late int numberOfTasks = 0;
//   List<Task> tasks = [];

//   late TextEditingController _textEditingController;
//   List<String> filteredTeamMembers = [];
//   List<String> filteredManagers = [];

//   bool isSubmitting = false;
//   bool showSuccessAnimation = false;

//   bool formSubmitted = false;
//   bool startDatePicked = false;
//   bool endDatePicked = false;

//   @override
//   void initState() {
//     super.initState();
//     projectNameController = TextEditingController();
//     descriptionController = TextEditingController();
//     ownerController = TextEditingController();
//     filteredManagers = widget.managers;
//     workHoursController = TextEditingController();
//     teamMembersController = TextEditingController();
//     _textEditingController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     projectNameController.dispose();
//     descriptionController.dispose();
//     ownerController.dispose();
//     workHoursController.dispose();
//     teamMembersController.dispose();
//     _textEditingController.dispose();
//     super.dispose();
//   }

//   void addTask(Task task) {
//     setState(() {
//       tasks.add(task);
//     });
//   }

//   void _filterTeamMembers(String query) {
//     setState(() {
//       filteredTeamMembers = widget.teamMembers
//           .where((member) =>
//               !allocatedTeamMembers.contains(member) &&
//               member.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }

//   void _filterManagers(String query) {
//     setState(() {
//       filteredManagers = widget.managers
//           .where(
//               (manager) => manager.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }

//   Future<void> _selectStartDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: startDate,
//       firstDate: DateTime.now().subtract(const Duration(days: 15)),
//       lastDate: DateTime(2025),
//     );
//     if (picked != null && picked != startDate) {
//       setState(() {
//         startDate = picked;
//         startDatePicked = true;
//         if (endDate.isBefore(startDate)) {
//           endDate = startDate.add(const Duration(days: 1));
//           endDatePicked = true;
//         }
//       });
//     }
//   }

//   Future<void> _selectEndDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: endDate,
//       firstDate: startDate,
//       lastDate: DateTime(2025),
//     );
//     if (picked != null && picked != endDate) {
//       setState(() {
//         endDate = picked;
//         endDatePicked = true;
//       });
//     }
//   }

//   void _addTeamMember(String member) {
//     setState(() {
//       for (int i = 0; i < tasks.length; i++) {
//         if (!tasks[i].teamMembers!.contains(member)) {
//           tasks[i].teamMembers!.add(member);
//         }
//       }
//       _textEditingController.clear();
//       allocatedTeamMembers.add(member);
//     });
//   }

//   void _addManager(String? manager) {
//     if (manager != null) {
//       setState(() {
//         ownerController.text = manager;
//       });
//     }
//   }

//   String? _validateDates() {
//     if (!startDatePicked || !endDatePicked) {
//       if (formSubmitted) {
//         return 'Select dates';
//       }
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 controller: projectNameController,
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 inputFormatters: [LengthLimitingTextInputFormatter(25)],
//                 decoration: InputDecoration(
//                   labelText: AppLocalizations.of(context)!.projectName,
//                   labelStyle: const TextStyle(color: Colors.black),
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue[900]!),
//                     borderRadius: BorderRadius.circular(8.0),
//                     gapPadding: 8.0,
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue[900]!),
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue[900]!),
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   filled: true,
//                   fillColor: Colors.blueGrey[50],
//                 ),
//                 style: const TextStyle(fontSize: 14),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return AppLocalizations.of(context)!.enterprojectname;
//                   }
//                   if (value.length > 25) {
//                     return 'Only 25 characters are allowed.';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: descriptionController,
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 inputFormatters: [LengthLimitingTextInputFormatter(30)],
//                 decoration: InputDecoration(
//                   labelText: AppLocalizations.of(context)!.description,
//                   labelStyle: const TextStyle(color: Colors.black),
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue[900]!),
//                     borderRadius: BorderRadius.circular(8.0),
//                     gapPadding: 8.0,
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue[900]!),
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue[900]!),
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   filled: true,
//                   fillColor: Colors.blueGrey[50],
//                 ),
//                 style: const TextStyle(fontSize: 14),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return AppLocalizations.of(context)!.enterprojectdesc;
//                   }
//                   if (value.length > 30) {
//                     return 'Only 30 characters are allowed.';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 12),
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8.0),
//                   border: Border.all(color: Colors.blue[900]!),
//                   color: Colors.blueGrey[50],
//                 ),
//                 child: Column(
//                   children: [
//                     ListTile(
//                       title: Text(AppLocalizations.of(context)!.from),
//                       subtitle: Text("${startDate.toLocal()}".split(' ')[0]),
//                       onTap: () async {
//                         await _selectStartDate(context);
//                       },
//                       trailing: const Icon(Icons.calendar_month),
//                     ),
//                     ListTile(
//                       title: Text(AppLocalizations.of(context)!.to),
//                       subtitle: Text("${endDate.toLocal()}".split(' ')[0]),
//                       onTap: () async {
//                         await _selectEndDate(context);
//                       },
//                       trailing: const Icon(Icons.calendar_month),
//                     ),
//                   ],
//                 ),
//               ),
//               if (_validateDates() != null)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: Text(
//                     _validateDates()!,
//                     style: const TextStyle(color: Colors.red),
//                   ),
//                 ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: workHoursController,
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                 decoration: InputDecoration(
//                   labelText: AppLocalizations.of(context)!.workHours,
//                   labelStyle: const TextStyle(color: Colors.black),
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue[900]!),
//                     borderRadius: BorderRadius.circular(8.0),
//                     gapPadding: 8.0,
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue[900]!),
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue[900]!),
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   filled: true,
//                   fillColor: Colors.blueGrey[50],
//                 ),
//                 style: const TextStyle(fontSize: 14),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return AppLocalizations.of(context)!.workHours;
//                   }
//                   if (int.tryParse(value) == null) {
//                     return 'Please enter a valid number';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 controller: teamMembersController,
//                 decoration: InputDecoration(
//                   labelText: AppLocalizations.of(context)!.teamMembers,
//                   labelStyle: const TextStyle(color: Colors.black),
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue[900]!),
//                     borderRadius: BorderRadius.circular(8.0),
//                     gapPadding: 8.0,
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue[900]!),
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue[900]!),
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   filled: true,
//                   fillColor: Colors.blueGrey[50],
//                 ),
//                 style: const TextStyle(fontSize: 14),
//                 onChanged: (value) {
//                   _filterTeamMembers(value);
//                 },
//               ),
//               const SizedBox(height: 8.0),
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: filteredTeamMembers.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(filteredTeamMembers[index]),
//                     onTap: () {
//                       _addTeamMember(filteredTeamMembers[index]);
//                     },
//                   );
//                 },
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 controller: ownerController,
//                 decoration: InputDecoration(
//                   labelText: AppLocalizations.of(context)!.manager,
//                   labelStyle: const TextStyle(color: Colors.black),
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue[900]!),
//                     borderRadius: BorderRadius.circular(8.0),
//                     gapPadding: 8.0,
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue[900]!),
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue[900]!),
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   filled: true,
//                   fillColor: Colors.blueGrey[50],
//                 ),
//                 style: const TextStyle(fontSize: 14),
//                 onChanged: (value) {
//                   _filterManagers(value);
//                 },
//               ),
//               const SizedBox(height: 8.0),
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: filteredManagers.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(filteredManagers[index]),
//                     onTap: () {
//                       _addManager(filteredManagers[index]);
//                     },
//                   );
//                 },
//               ),
//               const SizedBox(height: 12),
//               if (isSubmitting)
//                 Center(
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       Colors.blue[900]!,
//                     ),
//                   ),
//                 )
//               else
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         formSubmitted = true;
//                       });

//                       if (_formKey.currentState?.validate() ?? false) {
//                         final project = Project(
//                           // projectId: 0, // Assuming this is auto-generated
//                           projectName: projectNameController.text,
//                           description: descriptionController.text,
//                           startDate: startDate,
//                           endDate: endDate,
//                           owner: ownerController.text,
//                           workHours: workHoursController.text,
//                           teamMembers: teamMembersController.text,
//                           userId: widget.userId,
//                           tasks: tasks,
//                         );

//                         setState(() {
//                           isSubmitting = true;
//                         });

//                         // Simulate an asynchronous operation, e.g., network request
//                         Future.delayed(const Duration(seconds: 2), () {
//                           setState(() {
//                             isSubmitting = false;
//                             showSuccessAnimation = true;
//                           });

//                           widget.addProject(project);

//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('projectAdded'),
//                               duration: Duration(seconds: 2),
//                             ),
//                           );

//                           Navigator.of(context).pop();
//                         });
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue[900],
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 16.0),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     ),
//                     child: const Text('addProject'),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
