import 'package:flutter/material.dart';
import 'package:flutter_projects/domain/model/project.dart';

class ProjectMessagesPage extends StatefulWidget {
  final Project project;

  const ProjectMessagesPage({super.key, required this.project});

  @override
  State<ProjectMessagesPage> createState() => _ProjectMessagesPageState();
}

class _ProjectMessagesPageState extends State<ProjectMessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages for ${widget.project.projectName}'),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          'Here are the messages for ${widget.project.projectName}',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
