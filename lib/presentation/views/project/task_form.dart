import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_projects/domain/model/project/task.dart';

import '../../../domain/model/project/project.dart';

List<String> allocatedTeamMembers = [];
String? selectedTeamMember;

class TaskFields {
  static List<Widget> buildTaskFields(
    List<Task> tasks,
    int numberOfTasks,
    List<String> teamMembers,
    Function setState,
    DateTime endDate,
    Function filterTeamMembers,
    Function addTeamMember,
    BuildContext context,
    int maxTeamMembers,
    Project project, {
    TextEditingController? taskNameController,
    TextEditingController? descriptionController,
    TextEditingController? hoursController,
  }) {
    teamMembers = [
      'Nishanth',
      'Kumaran',
      'Murugan',
      'Kohli',
      'Sachin',
      'Naren',
      'Jega',
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

    List<Widget> taskFields = [];
    for (int i = 0; i < numberOfTasks; i++) {
      if (i >= tasks.length) {
        tasks.add(Task(
          taskName: '',
          description: '',
          dueDate: endDate,
          status: false,
          teamMembers: [],
          hours: '',
        ));
      }

      List<String> availableTeamMembers = List.from(teamMembers)
        ..removeWhere((member) => allocatedTeamMembers.contains(member));

      taskFields.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            TextFormField(
              controller: taskNameController ?? TextEditingController(),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: [LengthLimitingTextInputFormatter(20)],
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.taskName,
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.entertaskname;
                }
                if (value.length > 20) {
                  return 'Only 20 characters are allowed';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  tasks[i].taskName = value;
                });
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: descriptionController ?? TextEditingController(),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: [LengthLimitingTextInputFormatter(25)],
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.taskDescription,
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.entertaskdesc;
                }
                if (value.length > 25) {
                  return 'Only 25 characters are allowed';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  tasks[i].description = value;
                });
              },
            ),
            const SizedBox(height: 12),
            dueDate(tasks, i, context, setState, endDate),
            const SizedBox(height: 12),
            TextFormField(
              controller: hoursController ?? TextEditingController(),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: [LengthLimitingTextInputFormatter(4)],
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.taskHours,
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.entertaskhours;
                }
                if (value.length > 4) {
                  return 'Only 4 characters are allowed';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  tasks[i].hours = value;
                });
              },
            ),
            const SizedBox(height: 12),
            // Row(
            //   children: [
            //     Expanded(
            //       child: DropdownButtonFormField(
            //         autovalidateMode: AutovalidateMode.onUserInteraction,
            //         onChanged: (value) {
            //           filterTeamMembers(value);
            //         },
            //         decoration: InputDecoration(
            //           labelText:
            //               AppLocalizations.of(context)!.searchTeamMembers,
            //           labelStyle: const TextStyle(color: Colors.black),
            //           border: OutlineInputBorder(
            //             borderSide: BorderSide(color: Colors.blue[900]!),
            //             borderRadius: BorderRadius.circular(8.0),
            //             gapPadding: 8.0,
            //           ),
            //           enabledBorder: OutlineInputBorder(
            //             borderSide: BorderSide(color: Colors.blue[900]!),
            //             borderRadius: BorderRadius.circular(8.0),
            //           ),
            //           focusedBorder: OutlineInputBorder(
            //             borderSide: BorderSide(color: Colors.blue[900]!),
            //             borderRadius: BorderRadius.circular(8.0),
            //           ),
            //           filled: true,
            //           fillColor: Colors.blueGrey[50],
            //           suffixIcon: DropdownButton<String>(
            //             icon: const Icon(Icons.arrow_drop_down),
            //             iconSize: 24,
            //             elevation: 16,
            //             onChanged: (String? newValue) {
            //               if (newValue != null) {
            //                 _addTeamMember(newValue, tasks[i], setState,
            //                     allocatedTeamMembers, maxTeamMembers);
            //                 // print(
            //                 //     'Added member "$newValue" for task "${tasks[i].taskName}". Total members: ${tasks[i].teamMembers!.length}');
            //               }
            //             },
            //             items: availableTeamMembers
            //                 .map<DropdownMenuItem<String>>((String value) {
            //               return DropdownMenuItem<String>(
            //                 value: value,
            //                 child: Text(value),
            //               );
            //             }).toList(),
            //           ),
            //         ),
            //         style: const TextStyle(fontSize: 14),
            //       ),
            //     ),
            //   ],
            // ),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    value: selectedTeamMember,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.taskMembers,
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
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    onChanged: (newValue) {
                      setState(() {
                        _addTeamMember(newValue as String, tasks[i], setState,
                            allocatedTeamMembers, maxTeamMembers);
                      });
                    },
                    items: availableTeamMembers
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.toString().isEmpty) {
                        return AppLocalizations.of(context)!.enterTaskMembers;
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 160,
              child: Wrap(
                spacing: 2.0,
                runSpacing: 2.0,
                children: tasks[i].teamMembers!.map<Widget>((member) {
                  return Chip(
                    label: Text(member),
                    onDeleted: () {
                      setState(() {
                        tasks[i].teamMembers!.remove(member);
                        allocatedTeamMembers.remove(member);
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    }
    return taskFields;
  }

  static void _addTeamMember(
    String newValue,
    Task task,
    Function setState,
    List<String> availableTeamMembers,
    int maxTeamMembers,
  ) {
    if (task.teamMembers!.length <= maxTeamMembers) {
      task.teamMembers!.add(newValue);
      availableTeamMembers.remove(newValue);
      setState(() {});
    }
  }

  static ListTile dueDate(List<Task> tasks, int i, BuildContext context,
      Function setState, DateTime endDate) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.duedate),
      subtitle: Text("${tasks[i].dueDate.toLocal()}".split(' ')[0]),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: endDate,
          firstDate: DateTime(2022),
          lastDate: DateTime(2025),
        );
        if (picked != null && picked != tasks[i].dueDate) {
          setState(() {
            tasks[i].dueDate = picked;
          });
        }
      },
      trailing: const Icon(Icons.calendar_month),
      tileColor: const Color.fromARGB(255, 240, 234, 238),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Colors.purple.shade300),
      ),
    );
  }
}

// List<String> result = getUsersForProject(1, projects, teamMembers);
    // print('yyyyyyyyyyy $result');
    // List<int> selectedTeamMembersCount = List.filled(numberOfTasks, 0);

// List<String> getUsersForProject(
//   int projectId,
//   List<Project> projects,
//   List<String> teamMembers,
// ) {
//   Set<String> assignedUsers = {};
//   Set<String> otherProjectUsers = {};
//   // Check if projects list is empty
//   if (projects.isEmpty) {
//     return teamMembers; // Return the original list if no projects are available
//   }
//   // Find the specified project
//   Project? project = projects.firstWhere(
//     (proj) => proj.id == projectId,
//   );
//   if (project != null) {
//     // Collect users assigned to tasks in the specified project
//     for (var task in project.tasks) {
//       assignedUsers.addAll(task.teamMembers!);
//     }
//     // Collect users assigned to tasks in other projects
//     for (var proj in projects) {
//       if (proj.id != projectId) {
//         for (var task in proj.tasks) {
//           otherProjectUsers.addAll(task.teamMembers!);
//         }
//       }
//     }
//     // Remove users assigned to other projects from the list of assigned users
//     assignedUsers.removeWhere((user) => otherProjectUsers.contains(user));
//     // Collect the final list of users including those not assigned to any project
//     List<String> resultUsers =
//         teamMembers.where((user) => !otherProjectUsers.contains(user)).toList();
//     resultUsers.addAll(assignedUsers);
//     return resultUsers;
//   } else {
//     return teamMembers; // If the project is not found, return the original list
//   }
// }
