import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_projects/domain/model/task.dart';

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
  ) {
    List<Widget> taskFields = [];
    for (int i = 0; i < numberOfTasks; i++) {
      if (i >= tasks.length) {
        tasks.add(Task(
          taskName: '',
          description: '',
          dueDate: endDate,
          status: false,
          teamMembers: [],
        ));
      }
      taskFields.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: [LengthLimitingTextInputFormatter(20)],
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.taskName,
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
                  return 'Please enter task name';
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: [LengthLimitingTextInputFormatter(25)],
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.taskDescription,
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
                  return 'Please enter description of the task';
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
            //       TextField(
            //         onChanged: (value) {
            //           filterTeamMembers(value);
            //         },
            //         decoration: InputDecoration(
            //           labelText: AppLocalizations.of(context)!.searchTeamMembers,
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
            //         ),
            //         style: const TextStyle(fontSize: 14),
            //       ),
            //       const SizedBox(height: 10),
            //       SizedBox(
            //         height: 150,
            //         child: Wrap(
            //           spacing: 8.0,
            //           runSpacing: 8.0,
            //           children: teamMembers.take(9).map<Widget>((member) {
            //             return FilterChip(
            //               label: Text(member),
            //               selected: tasks[i].teamMembers?.contains(member) ?? false,
            //               onSelected: (bool selected) {
            //                 setState(() {
            //                   if (selected) {
            //                     tasks[i].teamMembers!.add(member);
            //                   } else {
            //                     tasks[i].teamMembers!.remove(member);
            //                   }
            //                 });
            //               },
            //             );
            //           }).toList(),
            //         ),
            //       ),
            //     ],
            //   ),
            // );
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onChanged: (value) {
                      filterTeamMembers(value);
                    },
                    decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)!.searchTeamMembers,
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
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            _addTeamMember(newValue, tasks[i], setState);
                            print(
                                'Added member "$newValue" for task "${tasks[i].taskName}". Total members: ${tasks[i].teamMembers!.length}');
                          }
                        },
                        items: teamMembers
                            .take(10)
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                // Cancel option
                // IconButton(
                //   onPressed: () {
                //     setState(() {
                //       // Clear the search team members field
                //       filterTeamMembers('');
                //     });
                //   },
                //   icon: const Icon(Icons.cancel),
                // ),
              ],
            ),

            // Selected team members display
            SizedBox(
              height: 80,
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: tasks[i].teamMembers!.map<Widget>((member) {
                  return Chip(
                    label: Text(member),
                    onDeleted: () {
                      setState(() {
                        tasks[i].teamMembers!.remove(member);
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

  static void _addTeamMember(String newValue, Task task, Function setState) {
    setState(() {
      if (task.teamMembers != null && !task.teamMembers!.contains(newValue)) {
        task.teamMembers!.add(newValue);
        print(
            'Added member "$newValue" for task "${task.taskName}". Total members: ${task.teamMembers!.length}');
      }
    });
  }

  static ListTile dueDate(List<Task> tasks, int i, BuildContext context,
      Function setState, DateTime endDate) {
    return ListTile(
      title: const Text("Due Date"),
      subtitle: Text("${tasks[i].dueDate.toLocal()}".split(' ')[0]),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          // initialDate: tasks[i].dueDate,
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
      tileColor: Colors.blueGrey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Colors.blue[900]!),
      ),
    );
  }
}
