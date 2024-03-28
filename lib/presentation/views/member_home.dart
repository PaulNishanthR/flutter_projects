// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_projects/data/datasources/projects_from_api.dart';
import 'package:flutter_projects/presentation/views/login.dart';
import 'package:intl/intl.dart';
import 'package:flutter_projects/domain/model/project.dart';
import 'package:flutter_projects/presentation/views/member_project_details.dart';

class MemberHomeScreen extends StatefulWidget {
  const MemberHomeScreen({Key? key}) : super(key: key);

  @override
  _MemberHomeScreenState createState() => _MemberHomeScreenState();
}

class _MemberHomeScreenState extends State<MemberHomeScreen> {
  List<Project> projects = [];

  @override
  void initState() {
    super.initState();
    fetchProjectsFromApi();
  }

  void fetchProjectsFromApi() async {
    try {
      final List<Project> fetchedProjects = await APiFetch().getHttp();
      setState(() {
        projects = fetchedProjects;
      });
    } catch (e) {
      // print('Error fetching projects: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Home'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return _buildProjectCard(context, project);
          },
        ),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, Project project) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.blue,
      child: ListTile(
        onTap: () {
          if (project.tasks.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    MemberProjectDetailsPage(tasks: project.tasks.first),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No tasks available for this project'),
              ),
            );
          }
        },
        title: Text(project.projectName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${project.description}'),
            Text(
              'Due Date: ${DateFormat('dd-MM-yyyy').format(project.endDate)}',
              style: TextStyle(color: Colors.red[800]),
            ),
          ],
        ),
      ),
    );
  }
}
