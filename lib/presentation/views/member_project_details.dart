import 'package:flutter/material.dart';
import 'package:flutter_projects/domain/model/task.dart';

class MemberProjectDetailsPage extends StatelessWidget {
  final List<Task> tasks;

  const MemberProjectDetailsPage({Key? key, required this.tasks})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return ListTile(
              title: Text(task.taskName),
              subtitle: Text('Due Date: ${task.dueDate.toString()}'),
            );
          },
        ),
      ),
    );
  }
}
