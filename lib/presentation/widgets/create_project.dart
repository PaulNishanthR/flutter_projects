import 'package:flutter/material.dart';
import 'package:flutter_projects/domain/model/project.dart';
import 'package:flutter_projects/presentation/views/project_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateProjectPage extends StatelessWidget {
  final void Function(Project) addProject;
  final List<Project> projects;

  final List<String> teamMembers = [];

  final List<String> managers = ['Saravanakumar', 'Devika', 'Amit'];
  final int userId;
  CreateProjectPage({
    super.key,
    required this.projects,
    required this.addProject,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.createNewProject),
        // backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ProjectForm(
                addProject: addProject,
                teamMembers: teamMembers,
                managers: managers,
                userId: userId,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
