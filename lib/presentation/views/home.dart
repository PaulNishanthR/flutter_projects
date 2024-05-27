import 'package:flutter/material.dart';
import 'package:flutter_projects/domain/model/project.dart';
import 'package:flutter_projects/presentation/providers/project_provider.dart';
import 'package:flutter_projects/presentation/views/project_details.dart';
import 'package:flutter_projects/presentation/views/sidebar.dart';
import 'package:flutter_projects/presentation/views/create_project.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';

class MyHomePage extends ConsumerStatefulWidget {
  final String title;
  final String username;
  final dynamic userId;

  const MyHomePage(
      {Key? key, required this.title, required this.username, this.userId})
      : super(key: key);

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  void initState() {
    super.initState();
    loadProjects();
  }

  Future<void> loadProjects() async {
    await ref.read(projectsProvider.notifier).getProjects(widget.userId);
  }

  List<Project> projects = [];

  void addProject(Project project) {
    setState(() {
      projects.add(project);
    });
  }

  load() {
    String userId = widget.username;
    ref.read(projectsProvider.notifier).getProjects(userId as int);
  }

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.lightBlue,
      ),
      drawer: Navbar(
        projects: projects,
        addProject: addProject,
        username: widget.username,
        userId: widget.userId,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        // child: ListView.builder(
        //   itemCount: projects.length + 1,
        //   itemBuilder: (context, index) {
        //     // print('Projects list length: ${projects.length}');
        //     if (index == 0) {
        //       Lottie.asset('assets/empty_projects.json');
        //       return _buildCreateNewProjectCard(context);
        //     } else {
        //       final projectIndex = index - 1;
        //       return _buildProjectCard(projects[projectIndex]);
        //     }
        //   },
        // ),
        child: Column(
          children: [
            _buildCreateNewProjectCard(context),
            Expanded(
              child: projects.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset('assets/empty_projects.json'),
                          const SizedBox(height: 20),
                          const Text(
                            'No projects available.',
                            style: TextStyle(
                                fontSize: 16, fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        return _buildProjectCard(projects[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateNewProjectCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.greenAccent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateProjectPage(
                addProject: addProject,
                projects: projects,
                userId: widget.userId,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, size: 40, color: Colors.black),
              const SizedBox(width: 16),
              Text(
                AppLocalizations.of(context)!.createNewProject,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(Project project) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.lightBlueAccent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectDetailsPage(project: project),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.projectName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                project.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Owner: ${project.owner}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Due Date: ${DateFormat('dd-MM-yyyy').format(project.endDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.red[800],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
