// import 'dart:ui';
// import 'package:animated_snack_bar/animated_snack_bar.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/domain/model/project/project.dart';
import 'package:flutter_projects/domain/model/project/task.dart';
import 'package:flutter_projects/presentation/providers/project/notification_provider.dart';
import 'package:flutter_projects/presentation/providers/project/project_provider.dart';
// import 'package:flutter_projects/presentation/views/home/home.dart';
import 'package:flutter_projects/presentation/views/notifications/project_notification.dart';
import 'package:flutter_projects/utils/app_notifications/app_notification.dart';
import 'package:flutter_projects/utils/constants/custom_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

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
  bool hasUnreadNotifications = false;

  List<Task> tasks = [];
  List<String> filteredTeamMembers = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkUnreadNotifications();
    _refreshNotifications();
  }

  Future<void> _refreshNotifications() async {
    await ref
        .read(notificationProvider.notifier)
        .getCountOfUnreadNotifications();
  }

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void _checkUnreadNotifications() {
    final notifications = ref.watch(notificationProvider);
    final projectNotifications = notifications
        .where((notification) => notification.projectId == widget.project.id)
        .toList();

    setState(() {
      hasUnreadNotifications =
          projectNotifications.any((notification) => !notification.isRead);
    });
  }

  Future<void> loadTasks() async {
    try {
      final taskList = await ref
          .read(projectsProvider.notifier)
          .getTasks(widget.project.id!);
      setState(() {
        tasks = taskList;
      });
      print('tasks   --- $tasks');
    } catch (e) {
      print("Error loading tasks: $e");
    }
  }

  /// Add Task Working GOOD --->>>
  void _addTask() {
    Task newTask = Task(
      taskName: '',
      description: '',
      dueDate: widget.project.endDate,
      status: false,
      teamMembers: [],
      taskPriority: TaskPriority.low,
    );

    TextEditingController taskNameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController hoursController = TextEditingController();
    TextEditingController dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(newTask.dueDate),
    );

    List<String> teamMembers = [
      'Nishanth',
      'Kumaran',
      'Murugan',
      'Kohli',
      'Sachin',
      'Naren',
      'Jaga',
      'Jhaya',
      'Logesh',
      'Hari',
      'Selvin',
      'Saravanan',
      'John',
      'Peter',
      'Yusuf',
      'Naresh',
      'Vallarasu',
      'Siva',
      'Arjun',
      'Sekar',
      'Poovan',
      'Naveen',
      'Sivaram',
      'Sudhakar',
      'Pooja',
      'Sowmiya',
      'Nandhini',
      'Roobini',
      'Karthika',
      'Revathy',
      'Mohammed',
      'Ajith',
      'Rajini',
      'Kamal'
    ];

    List<String> selectedTeamMembers = [];
    TaskPriority selectedPriority = TaskPriority.low;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.addtask,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: taskNameController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.taskName,
                            labelStyle: const TextStyle(color: Colors.black),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .entertaskname;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            newTask.taskName = value;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: descriptionController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText:
                                AppLocalizations.of(context)!.description,
                            labelStyle: const TextStyle(color: Colors.black),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .entertaskdesc;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            newTask.description = value;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: hoursController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.taskHours,
                            labelStyle: const TextStyle(color: Colors.black),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .entertaskhours;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            newTask.hours = value;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: dateController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.duedate,
                            labelStyle: const TextStyle(color: Colors.black),
                          ),
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: newTask.dueDate,
                              firstDate: widget.project.startDate
                                  .add(const Duration(days: 1)),
                              lastDate: widget.project.endDate,
                              helpText:
                                  AppLocalizations.of(context)!.duedateForTask,
                            );
                            if (pickedDate != null) {
                              newTask.dueDate = pickedDate;
                              dateController.text =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .pleaseenterenddate;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<TaskPriority>(
                          value: selectedPriority,
                          items: TaskPriority.values.map((priority) {
                            return DropdownMenuItem<TaskPriority>(
                              value: priority,
                              child: Text(priority.toString().split('.').last),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedPriority = value ?? TaskPriority.low;
                              newTask.taskPriority = selectedPriority;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return AppLocalizations.of(context)!
                                  .pleaseSelectPriority;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.priority,
                          ),
                        ),
                        const SizedBox(height: 10),
                        MultiSelectDialogField(
                          items: teamMembers
                              .map((member) =>
                                  MultiSelectItem<String>(member, member))
                              .toList(),
                          title:
                              Text(AppLocalizations.of(context)!.teamMembers),
                          selectedColor: Theme.of(context).primaryColor,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          buttonText:
                              Text(AppLocalizations.of(context)!.teamMembers),
                          onConfirm: (results) {
                            setState(() {
                              selectedTeamMembers = results.cast<String>();
                              newTask.teamMembers = selectedTeamMembers;
                            });
                          },
                          cancelText:
                              Text(AppLocalizations.of(context)!.cancel),
                          validator: (values) {
                            if (values == null || values.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .pleaseSelectTeamMembers;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8.0,
                          children: selectedTeamMembers.map((member) {
                            return Chip(
                              label: Text(member),
                              onDeleted: () {
                                setState(() {
                                  selectedTeamMembers.remove(member);
                                  newTask.teamMembers = selectedTeamMembers;
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                Set<dynamic> uniqueTeamMembers = tasks
                                    .expand((task) => task.teamMembers!)
                                    .toSet();

                                uniqueTeamMembers.addAll(selectedTeamMembers);
                                int countMembers =
                                    int.parse(widget.project.teamMembers);

                                int totalHours = tasks.fold(
                                    0,
                                    (sum, task) =>
                                        sum + int.parse(task.hours!));
                                totalHours += int.parse(newTask.hours!);
                                if (uniqueTeamMembers.length > countMembers) {
                                  Fluttertoast.showToast(
                                    msg: AppLocalizations.of(context)!
                                        .selectedTeamMembersCountWasExceeded,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.purple.shade300,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                } else if (totalHours >
                                    int.parse(widget.project.workHours)) {
                                  Fluttertoast.showToast(
                                    msg: AppLocalizations.of(context)!
                                        .totalHoursExceeded,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.purple.shade300,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                } else {
                                  await ref
                                      .read(projectsProvider.notifier)
                                      .updateProjectTasks(widget.project.id!,
                                          [...tasks, newTask]);
                                  await loadTasks();

                                  Fluttertoast.showToast(
                                    msg: AppLocalizations.of(context)!
                                        .taskAddedSuccessfully,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.purple.shade300,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );

                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                }
                              } on CustomException {
                                Fluttertoast.showToast(
                                  msg: AppLocalizations.of(context)!
                                      .someSelectedTeamMembersAreAssignedToOtherProjectsPleaseCheck,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.purple.shade300,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              } catch (e) {
                                // print("Error adding task: $e");
                              }
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context)!.add,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        // const SizedBox(height: 10),
                        // TextButton(
                        //   onPressed: () {
                        //     Navigator.of(context).pop();
                        //   },
                        //   child: Text(AppLocalizations.of(context)!.cancel),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Edit Task Working GOOD --->>>
  void _editTask(Task task) {
    final taskNameController = TextEditingController(text: task.taskName);
    final descriptionController = TextEditingController(text: task.description);
    final hoursController = TextEditingController(text: task.hours);
    final dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(task.dueDate),
    );

    List<String> teamMembers = [
      'Nishanth',
      'Kumaran',
      'Murugan',
      'Kohli',
      'Sachin',
      'Naren',
      'Jaga',
      'Jhaya',
      'Logesh',
      'Hari',
      'Selvin',
      'Saravanan',
      'John',
      'Peter',
      'Yusuf',
      'Naresh',
      'Vallarasu',
      'Siva',
      'Arjun',
      'Sekar',
      'Poovan',
      'Naveen',
      'Sivaram',
      'Sudhakar',
      'Pooja',
      'Sowmiya',
      'Nandhini',
      'Roobini',
      'Karthika',
      'Revathy',
      'Mohammed',
      'Ajith',
      'Rajini',
      'Kamal'
    ];

    List<String> selectedTeamMembers = task.teamMembers!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.edittask,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: taskNameController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.taskName,
                            labelStyle: const TextStyle(color: Colors.black),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .entertaskname;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            task.taskName = value;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: descriptionController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText:
                                AppLocalizations.of(context)!.description,
                            labelStyle: const TextStyle(color: Colors.black),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .entertaskdesc;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            task.description = value;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: hoursController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.taskHours,
                            labelStyle: const TextStyle(color: Colors.black),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .entertaskhours;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            task.hours = value;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: dateController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.duedate,
                            labelStyle: const TextStyle(color: Colors.black),
                          ),
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: task.dueDate,
                              firstDate: widget.project.startDate
                                  .add(const Duration(days: 1)),
                              lastDate: widget.project.endDate,
                              helpText:
                                  AppLocalizations.of(context)!.duedateForTask,
                            );
                            if (pickedDate != null) {
                              task.dueDate = pickedDate;
                              dateController.text =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .pleaseenterenddate;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        MultiSelectDialogField(
                          items: teamMembers
                              .map((member) =>
                                  MultiSelectItem<String>(member, member))
                              .toList(),
                          title:
                              Text(AppLocalizations.of(context)!.teamMembers),
                          selectedColor: Theme.of(context).primaryColor,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          buttonText:
                              Text(AppLocalizations.of(context)!.teamMembers),
                          onConfirm: (results) {
                            setState(() {
                              selectedTeamMembers = results.cast<String>();
                              task.teamMembers = selectedTeamMembers;
                            });
                          },
                          cancelText:
                              Text(AppLocalizations.of(context)!.cancel),
                          initialValue: selectedTeamMembers,
                          validator: (values) {
                            if (values == null || values.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .pleaseSelectTeamMembers;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8.0,
                          children: selectedTeamMembers.map((member) {
                            return Chip(
                              label: Text(member),
                              onDeleted: () {
                                setState(() {
                                  selectedTeamMembers.remove(member);
                                  task.teamMembers = selectedTeamMembers;
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 10),
                        // Row(
                        // children: [
                        // ElevatedButton(
                        // style: ElevatedButton.styleFrom(
                        //   backgroundColor: Colors.purple.shade300,
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 16.0, vertical: 8.0),
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(8.0),
                        //   ),
                        // ),

                        //   onPressed: () {
                        //     Navigator.of(context).pop();
                        //   },
                        //   child: Text(
                        //     AppLocalizations.of(context)!.cancel,
                        //     style: const TextStyle(color: Colors.black),
                        //   ),
                        // ),
                        // const SizedBox(width: 200),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                int totalHours = tasks.fold(
                                    0, (sum, t) => sum + int.parse(t.hours!));
                                totalHours += int.parse(task.hours!);

                                Set<dynamic> uniqueTeamMembers = tasks
                                    .expand((task) => task.teamMembers!)
                                    .toSet();

                                uniqueTeamMembers.addAll(selectedTeamMembers);
                                int countMembers =
                                    int.parse(widget.project.teamMembers);
                                if (uniqueTeamMembers.length > countMembers) {
                                  Fluttertoast.showToast(
                                    msg: AppLocalizations.of(context)!
                                        .selectedTeamMembersCountWasExceeded,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.purple.shade300,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                } else if (totalHours >
                                    int.parse(widget.project.workHours)) {
                                  Fluttertoast.showToast(
                                    msg: AppLocalizations.of(context)!
                                        .totalHoursExceeded,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.purple.shade300,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                } else {
                                  await ref
                                      .read(projectsProvider.notifier)
                                      .updateProjectTasks(
                                        widget.project.id!,
                                        tasks,
                                      );
                                  await loadTasks();
                                  if (context.mounted) {
                                    Fluttertoast.showToast(
                                      msg: AppLocalizations.of(context)!
                                          .taskEditedSuccessfully,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.purple.shade300,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                    Navigator.of(context).pop();
                                  }
                                }
                              } on CustomException {
                                Fluttertoast.showToast(
                                  msg: AppLocalizations.of(context)!
                                      .someSelectedTeamMembersAreAssignedToOtherProjectsPleaseCheck,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.purple.shade300,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              } catch (e) {
                                // print("Error editing task: $e");
                              }
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context)!.save,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        // ],
                        // ),
                        // const SizedBox(height: 10),
                        // ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: Colors.white,
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 16.0, vertical: 8.0),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(8.0),
                        //     ),
                        //   ),
                        //   onPressed: () {
                        //     Navigator.of(context).pop();
                        //   },
                        //   child: Text(
                        //     AppLocalizations.of(context)!.cancel,
                        //     style: const TextStyle(color: Colors.black),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsProvider);

    Project? updatedProject = projects.firstWhere(
      (proj) => proj.id == widget.project.id,
      orElse: () => widget.project,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          updatedProject.projectName,
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(
                  Icons.notifications_outlined,
                  size: 30,
                  color: Colors.black,
                ),
                if (hasUnreadNotifications)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProjectMessagesPage(project: widget.project),
                ),
              );
              _checkUnreadNotifications();
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
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color.fromARGB(255, 240, 234, 238),
                border: Border.all(color: Colors.purple, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(AppLocalizations.of(context)!.description,
                        updatedProject.description),
                    _buildInfoRow(AppLocalizations.of(context)!.manager,
                        updatedProject.owner),
                    _buildInfoRow(AppLocalizations.of(context)!.startdate,
                        _formatDate(widget.project.startDate)),
                    _buildInfoRow(AppLocalizations.of(context)!.enddate,
                        _formatDate(updatedProject.endDate)),
                    _buildInfoRow(AppLocalizations.of(context)!.workHours,
                        updatedProject.workHours),
                    _buildInfoRow(AppLocalizations.of(context)!.teamMembers,
                        updatedProject.teamMembers),
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
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: Text(
                      AppLocalizations.of(context)!.addtask,
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.purple.shade300),
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
        statusColor = Colors.purple.shade300;
        break;
      case TaskStatus.inProgress:
        statusColor = Colors.amber;
        break;
      case TaskStatus.completed:
        statusColor = Colors.green.shade700;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      // elevation: 4,
      // margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(10),
      //   side: BorderSide(color: statusColor, width: 2),
      // ),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color.fromARGB(255, 240, 234, 238),
        border: Border.all(color: statusColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
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
            Text(
              '${AppLocalizations.of(context)!.priority}: ${task.taskPriority.toString().split('.').last}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
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
                      // : (TaskStatus? newValue) {
                      //     if (newValue != null) {
                      //       setState(() {
                      //         task.taskStatus = newValue;
                      //       });
                      //       if (newValue == TaskStatus.completed) {
                      //         task.status = true;
                      //       } else {
                      //         task.status = false;
                      //       }
                      //       ref
                      //           .read(projectsProvider.notifier)
                      //           .updateProjectTasks(
                      //             widget.project.id!,
                      //             tasks,
                      //           );
                      //     }
                      //   },
                      : (TaskStatus? newValue) async {
                          if (newValue != null) {
                            if (newValue == TaskStatus.completed) {
                              bool allMembersDone = task.teamMembers!.every(
                                (member) =>
                                    task.memberStatuses[member.toLowerCase()] ==
                                    UserStatus.done,
                              );
                              if (!allMembersDone) {
                                Fluttertoast.showToast(
                                  msg: AppLocalizations.of(context)!
                                      .allTeamMembersMustMarkTaskAsDone,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 3,
                                  backgroundColor: Colors.purple.shade300,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                return;
                              }
                            }
                            setState(() {
                              task.taskStatus = newValue;
                            });
                            if (newValue == TaskStatus.completed) {
                              task.status = true;
                            } else {
                              task.status = false;
                            }
                            await ref
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

  void _markProjectAsCompleted(int projectId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.markascomplete),
          content:
              Text(AppLocalizations.of(context)!.areYouSureCompleteProject),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (tasks.isEmpty) {
                  // AnimatedSnackBar.material(
                  // AppLocalizations.of(context)!
                  //     .noTasksAvailableCannotMarkProjectAsCompleted,
                  //   type: AnimatedSnackBarType.error,
                  // ).show(context);
                  Fluttertoast.showToast(
                    msg: AppLocalizations.of(context)!
                        .noTasksAvailableCannotMarkProjectAsCompleted,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 5,
                    backgroundColor: Colors.purple.shade300,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
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
                      Fluttertoast.showToast(
                        msg:
                            '${widget.project.projectName} ${AppLocalizations.of(context)!.markedAsDone}',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 5,
                        backgroundColor: Colors.purple.shade300,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      NotificationManager.showNotification(
                          fileName:
                              '${widget.project.projectName} ${AppLocalizations.of(context)!.wasCompleted}');
                    }
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  } else {
                    // AnimatedSnackBar.material(
                    //         'All tasks must be completed before marking the project as completed',
                    //         type: AnimatedSnackBarType.error)
                    //     .show(context);
                    Fluttertoast.showToast(
                      msg: AppLocalizations.of(context)!
                          .allTasksMustBeCompletedBeforeMarkingTheProjectAsCompleted,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.purple.shade300,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    // AnimatedSnackBar.material(
                    //         'Failed to mark project as completed',
                    //         type: AnimatedSnackBarType.error)
                    //     .show(context);
                    Fluttertoast.showToast(
                      msg: AppLocalizations.of(context)!
                          .failedToMarkProjectAsCompleted,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.purple.shade300,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                }

                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(AppLocalizations.of(context)!.ok),
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

  /// Edit Project is Working GOOD --->>>
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.editproject,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: projectNameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.projectName,
                      labelStyle: const TextStyle(color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.enterprojectname;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      projectNameController.text = value;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: descriptionController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.description,
                      labelStyle: const TextStyle(color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.enterprojectdesc;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      descriptionController.text = value;
                    },
                  ),
                  // const SizedBox(height: 8),
                  // TextFormField(
                  //   controller: ownerController,
                  //   autovalidateMode: AutovalidateMode.onUserInteraction,
                  //   decoration: InputDecoration(
                  //       labelText: AppLocalizations.of(context)!.projectOwner),
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return AppLocalizations.of(context)!.enterowner;
                  //     }
                  //     return null;
                  //   },
                  //   onChanged: (value) {
                  //     ownerController.text = value;
                  //   },
                  // ),
                  const SizedBox(height: 8),
                  _buildDateField(
                      AppLocalizations.of(context)!.enddate, endDateController),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: workHoursController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.workHours,
                      labelStyle: const TextStyle(color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.enterprojecthours;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      workHoursController.text = value;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: teamMembersController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.teamMembers,
                      labelStyle: const TextStyle(color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.entermembers;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      teamMembersController.text = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () async {
                      DateTime? startDate =
                          _parseDateTime(startDateController.text);
                      DateTime? endDate =
                          _parseDateTime(endDateController.text);

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
                          ref
                              .read(projectsProvider.notifier)
                              .getProjects(widget.userId);
                          if (context.mounted) {
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                              msg: AppLocalizations.of(context)!
                                  .projectDetailsWasEditedSuccessfully,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.purple.shade300,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        } else {
                          Fluttertoast.showToast(
                            msg: AppLocalizations.of(context)!
                                .failedToUpdateTheProject,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.purple.shade300,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)!.invalidDateFormat,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.purple.shade300,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.save,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _deleteProject(BuildContext context, Project project) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.deleteproject),
          content: Text(AppLocalizations.of(context)!.areYouSureDeleteProject),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await ref
                    .read(projectsProvider.notifier)
                    .deleteProject(project.id!);
                if (context.mounted) {
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg:
                        '${widget.project.projectName} ${AppLocalizations.of(context)!.wasDeletedSuccessfully}',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 5,
                    backgroundColor: Colors.purple.shade300,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              },
              child: Text(AppLocalizations.of(context)!.delete),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ],
        );
      },
    );
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
