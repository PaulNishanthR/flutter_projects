import 'package:flutter/material.dart';
import 'package:flutter_projects/domain/model/project.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskFields {
  static List<Widget> buildTaskFields(
    List<Task> tasks,
    int numberOfTasks,
    List<String> teamMembers,
    Function setState,
    // ignore: no_leading_underscores_for_local_identifiers
    Function _filterTeamMembers,
    BuildContext context,
  ) {
    List<Widget> taskFields = [];
    for (int i = 0; i < numberOfTasks; i++) {
      if (i >= tasks.length) {
        tasks.add(Task(
          taskName: '',
          description: '',
          dueDate: DateTime.now(),
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
                return null;
              },
              onChanged: (value) {
                setState(() {
                  tasks[i].description = value;
                });
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              title: const Text("Due Date"),
              subtitle: Text("${tasks[i].dueDate.toLocal()}".split(' ')[0]),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: tasks[i].dueDate,
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
            ),
            const SizedBox(height: 12),
            TextField(
              onChanged: (value) {
                _filterTeamMembers(value);
              },
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.searchTeamMembers,
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
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: teamMembers.take(9).map<Widget>((member) {
                  return FilterChip(
                    label: Text(member),
                    selected: tasks[i].teamMembers?.contains(member) ?? false,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          tasks[i].teamMembers!.add(member);
                        } else {
                          tasks[i].teamMembers!.remove(member);
                        }
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
}
