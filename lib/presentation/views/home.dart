// import 'package:flutter/material.dart';
// import 'package:flutter_projects/domain/model/project.dart';
// import 'package:flutter_projects/presentation/providers/project_provider.dart';
// import 'package:flutter_projects/presentation/views/project_details.dart';
// import 'package:flutter_projects/presentation/views/sidebar.dart';
// import 'package:flutter_projects/presentation/views/create_project.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:lottie/lottie.dart';

// class MyHomePage extends ConsumerStatefulWidget {
//   final String title;
//   final String username;
//   final dynamic userId;

//   const MyHomePage(
//       {Key? key, required this.title, required this.username, this.userId})
//       : super(key: key);

//   @override
//   ConsumerState<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends ConsumerState<MyHomePage> {
//   @override
//   void initState() {
//     super.initState();
//     loadProjects();
//   }

//   Future<void> loadProjects() async {
//     await ref.read(projectsProvider.notifier).getProjects(widget.userId);
//   }

//   List<Project> projects = [];

//   void addProject(Project project) {
//     setState(() {
//       projects.add(project);
//     });
//   }

//   load() {
//     String userId = widget.username;
//     ref.read(projectsProvider.notifier).getProjects(userId as int);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final projects = ref.watch(projectsProvider);
//     final incompleteProjects =
//         projects.where((project) => !project.completed).toList();
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         backgroundColor: Colors.lightBlue,
//       ),
//       drawer: Navbar(
//         projects: projects,
//         addProject: addProject,
//         username: widget.username,
//         userId: widget.userId,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
//         child: Column(
//           children: [
//             _buildCreateNewProjectCard(context),
//             Expanded(
//               child: incompleteProjects.isEmpty
//                   ? Center(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Lottie.asset('assets/empty_projects.json'),
//                           const SizedBox(height: 20),
//                           Text(
//                             AppLocalizations.of(context)!.noprojects,
//                             style: const TextStyle(
//                                 fontSize: 16, fontStyle: FontStyle.italic),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     )
//                   : ListView.builder(
//                       itemCount: projects.length,
//                       itemBuilder: (context, index) {
//                         final project = projects[index];
//                         if (project.completed) return const SizedBox.shrink();

//                         return _buildProjectCard(projects[index]);
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCreateNewProjectCard(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10.0),
//         color: Colors.greenAccent,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => CreateProjectPage(
//                 addProject: addProject,
//                 projects: projects,
//                 userId: widget.userId,
//               ),
//             ),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.add, size: 40, color: Colors.black),
//               const SizedBox(width: 16),
//               Text(
//                 AppLocalizations.of(context)!.createNewProject,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProjectCard(Project project) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10.0),
//         color: Colors.lightBlueAccent,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ProjectDetailsPage(
//                 project: project,
//                 teamMembers: const [],
//                 userId: widget.userId,
//               ),
//             ),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 project.projectName,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 project.description,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     '${AppLocalizations.of(context)!.manager}: ${project.owner}',
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: Colors.black,
//                     ),
//                   ),
//                   Text(
//                     '${AppLocalizations.of(context)!.enddate}: ${DateFormat('dd-MM-yyyy').format(project.endDate)}',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontStyle: FontStyle.italic,
//                       color: Colors.red[800],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:flutter_projects/domain/model/project.dart';
// // import 'package:flutter_projects/presentation/providers/project_provider.dart';
// // import 'package:flutter_projects/presentation/views/project_details.dart';
// // import 'package:flutter_projects/presentation/views/sidebar.dart';
// // import 'package:flutter_projects/presentation/views/create_project.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:intl/intl.dart';
// // import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// // import 'package:lottie/lottie.dart';

// // class MyHomePage extends ConsumerStatefulWidget {
// //   final String title;
// //   final String username;
// //   final dynamic userId;

// //   const MyHomePage(
// //       {Key? key, required this.title, required this.username, this.userId})
// //       : super(key: key);

// //   @override
// //   ConsumerState<MyHomePage> createState() => _MyHomePageState();
// // }

// // class _MyHomePageState extends ConsumerState<MyHomePage> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     loadProjects();
// //   }

// //   Future<void> loadProjects() async {
// //     await ref.read(projectsProvider.notifier).getProjects(widget.userId);
// //   }

// //   List<Project> projects = [];

// //   void addProject(Project project) {
// //     setState(() {
// //       projects.add(project);
// //     });
// //   }

// //   load() {
// //     String userId = widget.username;
// //     ref.read(projectsProvider.notifier).getProjects(userId as int);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final projects = ref.watch(projectsProvider);
// //     final incompleteProjects =
// //         projects.where((project) => !project.completed).toList();
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(widget.title),
// //         backgroundColor: Colors.lightBlue,
// //       ),
// //       drawer: Navbar(
// //         projects: projects,
// //         addProject: addProject,
// //         username: widget.username,
// //         userId: widget.userId,
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
// //         child: Column(
// //           children: [
// //             _buildCreateNewProjectCard(context),
// //             Expanded(
// //               child: incompleteProjects.isEmpty
// //                   ? Center(
// //                       child: Column(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           Lottie.asset('assets/empty_projects.json'),
// //                           const SizedBox(height: 20),
// //                           Text(
// //                             AppLocalizations.of(context)!.noprojects,
// //                             style: const TextStyle(
// //                                 fontSize: 16, fontStyle: FontStyle.italic),
// //                             textAlign: TextAlign.center,
// //                           ),
// //                         ],
// //                       ),
// //                     )
// //                   : ListView.builder(
// //                       itemCount: projects.length,
// //                       itemBuilder: (context, index) {
// //                         final project = projects[index];
// //                         if (project.completed) return const SizedBox.shrink();

// //                         return _buildProjectCard(project);
// //                       },
// //                     ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildCreateNewProjectCard(BuildContext context) {
// //     return Container(
// //       margin: const EdgeInsets.symmetric(vertical: 8.0),
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(10.0),
// //         color: Colors.greenAccent,
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.3),
// //             spreadRadius: 2,
// //             blurRadius: 5,
// //             offset: const Offset(0, 3),
// //           ),
// //         ],
// //       ),
// //       child: InkWell(
// //         onTap: () {
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(
// //               builder: (context) => CreateProjectPage(
// //                 addProject: addProject,
// //                 projects: projects,
// //                 userId: widget.userId,
// //               ),
// //             ),
// //           );
// //         },
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               const Icon(Icons.add, size: 40, color: Colors.black),
// //               const SizedBox(width: 16),
// //               Text(
// //                 AppLocalizations.of(context)!.createNewProject,
// //                 style: const TextStyle(
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.black,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildProjectCard(Project project) {
// //     return ProjectCard(
// //       title: project.projectName,
// //       subtitle: project.description,
// //       status: 'Ongoing',
// //       dueDate: project.endDate,
// //       completion: project.tasks.where((task) => task.status).length,
// //       teamMembers: project.teamMembers,
// //     );
// //   }
// // }

// // class ProjectCard extends StatelessWidget {
// //   final String title;
// //   final String subtitle;
// //   final String status;
// //   final DateTime dueDate;
// //   final int completion;
// //   final String teamMembers;

// //   ProjectCard({
// //     required this.title,
// //     required this.subtitle,
// //     required this.status,
// //     required this.dueDate,
// //     required this.completion,
// //     required this.teamMembers,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       margin: const EdgeInsets.symmetric(vertical: 8.0),
// //       padding: const EdgeInsets.all(16.0),
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(20.0),
// //         gradient: const LinearGradient(
// //           colors: [Colors.yellow, Colors.orangeAccent],
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //         ),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.1),
// //             blurRadius: 10,
// //             offset: const Offset(0, 5),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               Text(
// //                 status,
// //                 style: const TextStyle(
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.white,
// //                 ),
// //               ),
// //               const Spacer(),
// //               const Icon(Icons.more_vert, color: Colors.white),
// //             ],
// //           ),
// //           const SizedBox(height: 8),
// //           Text(
// //             title,
// //             style: const TextStyle(
// //               fontSize: 18,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.white,
// //             ),
// //           ),
// //           const SizedBox(height: 4),
// //           Text(
// //             subtitle,
// //             style: const TextStyle(
// //               fontSize: 14,
// //               color: Colors.white,
// //             ),
// //           ),
// //           const SizedBox(height: 16),
// //           Row(
// //             children: [
// //               Text(
// //                 'Due: ${DateFormat('dd MMM').format(dueDate)}',
// //                 style: const TextStyle(
// //                   fontSize: 12,
// //                   color: Colors.white,
// //                 ),
// //               ),
// //               const Spacer(),
// //               Text(
// //                 'Completion: $completion/3',
// //                 style: const TextStyle(
// //                   fontSize: 12,
// //                   color: Colors.white,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:flutter_projects/domain/model/project.dart';
import 'package:flutter_projects/presentation/providers/project_provider.dart';
import 'package:flutter_projects/presentation/views/project_details.dart';
import 'package:flutter_projects/presentation/views/sidebar.dart';
import 'package:flutter_projects/presentation/widgets/create_project.dart';
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
    final incompleteProjects =
        projects.where((project) => !project.completed).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        // backgroundColor: Colors.white,
        centerTitle: true,
      ),
      drawer: Navbar(
        projects: projects,
        addProject: addProject,
        username: widget.username,
        userId: widget.userId,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        child: Column(
          children: [
            _buildCreateNewProjectCard(context),
            Expanded(
              child: incompleteProjects.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Lottie.asset('assets/empty_projects.json'),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 15),
                            child: Lottie.asset(
                              "assets/empty_projects.json",
                              width: 300,
                              height: 200,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            AppLocalizations.of(context)!.noprojects,
                            style: const TextStyle(
                                fontSize: 16, fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        final project = projects[index];
                        if (project.completed) return const SizedBox.shrink();

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
        color: Colors.black,
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
              const Icon(Icons.add, size: 40, color: Colors.white),
              const SizedBox(width: 16),
              Text(
                AppLocalizations.of(context)!.createNewProject,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
      height: 150,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        // gradient: const LinearGradient(
        //   colors: [Colors.black, Colors.white],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
        color: Colors.purple.shade300,
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
              builder: (context) => ProjectDetailsPage(
                project: project,
                teamMembers: const [],
                userId: widget.userId,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.projectName} : ${project.projectName}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  // PopupMenuButton<String>(
                  //   onSelected: (value) {},
                  //   itemBuilder: (BuildContext context) {
                  //     return {'Edit', 'Delete'}.map((String choice) {
                  //       return PopupMenuItem<String>(
                  //         value: choice,
                  //         child: Text(choice),
                  //       );
                  //     }).toList();
                  //   },
                  // ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${AppLocalizations.of(context)!.description}: ${project.description}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Total tasks : ${project.tasks.length}',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.manager}: ${project.owner}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.enddate}: ${DateFormat('dd-MM-yyyy').format(project.endDate)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
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
