import 'package:flutter/material.dart';
import 'package:flutter_projects/presentation/providers/api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_projects/domain/model/project.dart';
import 'package:flutter_projects/presentation/views/member_project_details.dart';

class MemberHomeScreen extends ConsumerStatefulWidget {
  const MemberHomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _MemberHomeScreenState();
}

class _MemberHomeScreenState extends ConsumerState<MemberHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: const Text("kumaran's Projects"),
        backgroundColor: Colors.blue,
        // actions: [
        // IconButton(
        //   icon: const Icon(Icons.exit_to_app),
        //   onPressed: () {
        //     Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(builder: (context) => const LoginScreen()),
        //     );
        //   },
        // ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer(
          builder: (context, watch, _) {
            final projects = ref.watch(apiProvider);
            return ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return GestureDetector(
                  onTap: () {
                    if (project.tasks.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MemberProjectDetailsPage(
                            tasks: project.tasks,
                          ),
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
                  child: _buildProjectCard(context, project),
                );
              },
            );
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
