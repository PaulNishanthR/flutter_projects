// import 'package:animated_snack_bar/animated_snack_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_projects/domain/model/project.dart';
// import 'package:flutter_projects/presentation/providers/project_provider.dart';
// import 'package:flutter_projects/presentation/widgets/generate_pdf.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lottie/lottie.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class ProjectsTable extends ConsumerStatefulWidget {
//   final int userId;

//   const ProjectsTable({Key? key, required this.userId}) : super(key: key);

//   @override
//   ConsumerState<ProjectsTable> createState() => _ProjectsTableState();
// }

// class _ProjectsTableState extends ConsumerState<ProjectsTable> {
//   List<int> selectedProjectIds = [];

//   @override
//   Widget build(BuildContext context) {
//     final projects = ref.watch(projectsProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.reports),
//         backgroundColor: Colors.lightBlue,
//       ),
//       body: projects.isNotEmpty
//           ? Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ListView.builder(
//                 itemCount: projects.length,
//                 itemBuilder: (context, index) {
//                   final project = projects[index];
//                   final isChecked = selectedProjectIds.contains(project.id);

//                   return Card(
//                     color: project.completed
//                         ? Colors.green
//                         : isChecked
//                             ? Colors.green
//                             : Colors.blue[200],
//                     child: ListTile(
//                       title: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '${AppLocalizations.of(context)!.projectName}: ${project.projectName}',
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             '${AppLocalizations.of(context)!.manager}: ${project.owner}',
//                             style: const TextStyle(
//                               fontSize: 12,
//                               color: Colors.black,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             '${AppLocalizations.of(context)!.enddate}: ${_formatDate(project.endDate)}',
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontStyle: FontStyle.italic,
//                               color: Colors.red[800],
//                             ),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               _showProjectDetails(context, project);
//                             },
//                             child: const Text('Generate Report'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             )
//           : Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Lottie.asset('assets/empty_projects.json'),
//                   const SizedBox(height: 20),
//                   Text(
//                     AppLocalizations.of(context)!.noprojects,
//                     style: const TextStyle(
//                         fontSize: 16, fontStyle: FontStyle.italic),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   void _showProjectDetails(
//     BuildContext context,
//     Project project,
//   ) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Name: ${project.projectName}'),
//               IconButton(
//                 icon: const Icon(Icons.picture_as_pdf),
//                 onPressed: () {
//                   if (project.completed) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => PDFGenerator(
//                           project: project,
//                         ),
//                       ),
//                     );
//                   } else {
//                     AnimatedSnackBar.material(
//                             'Since Project was not completed you did not get report',
//                             type: AnimatedSnackBarType.error)
//                         .show(context);
//                   }
//                 },
//               ),
//             ],
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Description: ${project.description}'),
//                 const SizedBox(height: 8),
//                 Text('Manager: ${project.owner}'),
//                 const SizedBox(height: 8),
//                 Text('Start Date: ${_formatDate(project.startDate)}'),
//                 const SizedBox(height: 8),
//                 Text('End Date: ${_formatDate(project.endDate)}'),
//                 const SizedBox(height: 8),
//                 Text('Work Hours: ${project.workHours}'),
//                 const SizedBox(height: 8),
//                 const Text('Tasks:'),
//                 const SizedBox(height: 8),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: project.tasks.map((task) {
//                     return Text('- ${task.taskName}');
//                   }).toList(),
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   String _formatDate(DateTime date) {
//     return '${date.year}-${_addLeadingZeroIfNeeded(date.month)}-${_addLeadingZeroIfNeeded(date.day)}';
//   }

//   String _addLeadingZeroIfNeeded(int value) {
//     if (value < 10) {
//       return '0$value';
//     }
//     return value.toString();
//   }
// }

// import 'package:animated_snack_bar/animated_snack_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_projects/domain/model/project.dart';
// import 'package:flutter_projects/presentation/providers/project_provider.dart';
// import 'package:flutter_projects/presentation/widgets/generate_pdf.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lottie/lottie.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class ProjectsTable extends ConsumerStatefulWidget {
//   final int userId;

//   const ProjectsTable({Key? key, required this.userId}) : super(key: key);

//   @override
//   ConsumerState<ProjectsTable> createState() => _ProjectsTableState();
// }

// class _ProjectsTableState extends ConsumerState<ProjectsTable> {
//   List<int> selectedProjectIds = [];

//   @override
//   Widget build(BuildContext context) {
//     final projects = ref.watch(projectsProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.reports),
//         backgroundColor: Colors.lightBlue,
//       ),
//       body: projects.isNotEmpty
//           ? Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ListView.builder(
//                 itemCount: projects.length,
//                 itemBuilder: (context, index) {
//                   final project = projects[index];
//                   final isChecked = selectedProjectIds.contains(project.id);

//                   return Card(
//                     color: project.completed
//                         ? Colors.green
//                         : isChecked
//                             ? Colors.green
//                             : Colors.blue[200],
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '${AppLocalizations.of(context)!.projectName}: ${project.projectName}',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             '${AppLocalizations.of(context)!.manager}: ${project.owner}',
//                             style: const TextStyle(
//                               fontSize: 14,
//                               color: Colors.black,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             '${AppLocalizations.of(context)!.enddate}: ${_formatDate(project.endDate)}',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontStyle: FontStyle.italic,
//                               color: Colors.red[800],
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           if (project.completed)
//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   _showProjectDetails(context, project);
//                                 },
//                                 child: const Text('Generate Report'),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             )
//           : Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Lottie.asset('assets/empty_projects.json'),
//                   const SizedBox(height: 20),
//                   Text(
//                     AppLocalizations.of(context)!.noprojects,
//                     style: const TextStyle(
//                         fontSize: 16, fontStyle: FontStyle.italic),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   void _showProjectDetails(
//     BuildContext context,
//     Project project,
//   ) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Name: ${project.projectName}'),
//               IconButton(
//                 icon: const Icon(Icons.picture_as_pdf),
//                 onPressed: () {
//                   if (project.completed) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => PDFGenerator(
//                           project: project,
//                         ),
//                       ),
//                     );
//                   } else {
//                     AnimatedSnackBar.material(
//                             'Since Project was not completed you did not get report',
//                             type: AnimatedSnackBarType.error)
//                         .show(context);
//                   }
//                 },
//               ),
//             ],
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Description: ${project.description}'),
//                 const SizedBox(height: 8),
//                 Text('Manager: ${project.owner}'),
//                 const SizedBox(height: 8),
//                 Text('Start Date: ${_formatDate(project.startDate)}'),
//                 const SizedBox(height: 8),
//                 Text('End Date: ${_formatDate(project.endDate)}'),
//                 const SizedBox(height: 8),
//                 Text('Work Hours: ${project.workHours}'),
//                 const SizedBox(height: 8),
//                 const Text('Tasks:'),
//                 const SizedBox(height: 8),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: project.tasks.map((task) {
//                     return Text('- ${task.taskName}');
//                   }).toList(),
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   String _formatDate(DateTime date) {
//     return '${date.year}-${_addLeadingZeroIfNeeded(date.month)}-${_addLeadingZeroIfNeeded(date.day)}';
//   }

//   String _addLeadingZeroIfNeeded(int value) {
//     if (value < 10) {
//       return '0$value';
//     }
//     return value.toString();
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_projects/domain/model/project.dart';
import 'package:flutter_projects/presentation/providers/project_provider.dart';
import 'package:flutter_projects/presentation/widgets/generate_pdf.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ProjectsTable extends ConsumerStatefulWidget {
  final int userId;

  const ProjectsTable({Key? key, required this.userId}) : super(key: key);

  @override
  ConsumerState<ProjectsTable> createState() => _ProjectsTableState();
}

class _ProjectsTableState extends ConsumerState<ProjectsTable> {
  List<int> selectedProjectIds = [];

  @override
  Widget build(BuildContext context) {
    final projects = ref
        .watch(projectsProvider)
        .where((project) => project.completed)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.reports),
        backgroundColor: Colors.lightBlue,
      ),
      body: projects.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects.reversed.toList()[index];
                  final isChecked = selectedProjectIds.contains(project.id);

                  return Card(
                    color: isChecked ? Colors.green : Colors.blue[200],
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${AppLocalizations.of(context)!.projectName}: ${project.projectName}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${AppLocalizations.of(context)!.manager}: ${project.owner}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${AppLocalizations.of(context)!.enddate}: ${_formatDate(project.endDate)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.red[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                _showProjectDetails(context, project);
                              },
                              child: const Text('Generate Report'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset('assets/empty_projects.json'),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.noprojects,
                    style: const TextStyle(
                        fontSize: 16, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
    );
  }

  // void _showProjectDetails(
  //   BuildContext context,
  //   Project project,
  // ) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text('Name: ${project.projectName}'),
  //             IconButton(
  //               icon: const Icon(Icons.picture_as_pdf),
  //               onPressed: () {
  //                 if (project.completed) {
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => PDFGenerator(
  //                         project: project,
  //                       ),
  //                     ),
  //                   );
  //                 } else {
  //                   AnimatedSnackBar.material(
  //                           'Since Project was not completed you did not get report',
  //                           type: AnimatedSnackBarType.error)
  //                       .show(context);
  //                 }
  //               },
  //             ),
  //           ],
  //         ),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text('Description: ${project.description}'),
  //               const SizedBox(height: 8),
  //               Text('Manager: ${project.owner}'),
  //               const SizedBox(height: 8),
  //               Text('Start Date: ${_formatDate(project.startDate)}'),
  //               const SizedBox(height: 8),
  //               Text('End Date: ${_formatDate(project.endDate)}'),
  //               const SizedBox(height: 8),
  //               Text('Work Hours: ${project.workHours}'),
  //               const SizedBox(height: 8),
  //               const Text('Tasks:'),
  //               const SizedBox(height: 8),
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: project.tasks.map((task) {
  //                   return Text('- ${task.taskName}');
  //                 }).toList(),
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: const Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _showProjectDetails(BuildContext context, Project project) async {
    final pdfFile = await generatePDF(project);
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFDisplayPage(pdfFile: pdfFile),
        ),
      );
    }
  }

  Future<File> generatePDF(Project project) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(20.0),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 20.0),
              child: pw.Text(
                'Project Report',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 30,
                  color: PdfColors.blue,
                ),
              ),
            ),
          ),
          buildProjectSection(project),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final pdfFile = File('${output.path}/Completed_Project.pdf');
    await pdfFile.writeAsBytes(await pdf.save());
    return pdfFile;
  }

  pw.Widget buildProjectSection(Project project) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 10.0),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Name: ${project.projectName}',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 24,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Description: ${project.description}',
            style: const pw.TextStyle(
              fontSize: 18.0,
              color: PdfColors.black,
            ),
          ),
          pw.Text(
            'Owner: ${project.owner}',
            style: const pw.TextStyle(
              fontSize: 18.0,
              color: PdfColors.black,
            ),
          ),
          pw.Text(
            'Start Date: ${_formatDate(project.startDate)}',
            style: const pw.TextStyle(
              fontSize: 18.0,
              color: PdfColors.black,
            ),
          ),
          pw.Text(
            'End Date: ${_formatDate(project.endDate)}',
            style: const pw.TextStyle(
              fontSize: 18.0,
              color: PdfColors.black,
            ),
          ),
          pw.Text(
            'Work Hours: ${project.workHours}',
            style: const pw.TextStyle(
              fontSize: 18.0,
              color: PdfColors.black,
            ),
          ),
          pw.Divider(
            thickness: 0.5,
            color: PdfColors.grey,
            height: 20.0,
          ),
          pw.SizedBox(height: 10),
          for (var task in project.tasks)
            pw.Container(
              margin: const pw.EdgeInsets.symmetric(vertical: 5.0),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Task: ${task.taskName}',
                    style: const pw.TextStyle(
                      fontSize: 16.0,
                      color: PdfColors.black,
                    ),
                  ),
                  pw.Text(
                    'Description: ${task.description}',
                    style: const pw.TextStyle(
                      fontSize: 16.0,
                      color: PdfColors.black,
                    ),
                  ),
                  pw.Text(
                    'Due Date: ${_formatDate(task.dueDate)}',
                    style: const pw.TextStyle(
                      fontSize: 16.0,
                      color: PdfColors.black,
                    ),
                  ),
                  pw.Text(
                    'Hours: ${task.hours}',
                    style: const pw.TextStyle(
                      fontSize: 16.0,
                      color: PdfColors.black,
                    ),
                  ),
                  pw.Text(
                    'Assigned Members: ${task.teamMembers?.join(', ') ?? 'None'}',
                    style: const pw.TextStyle(
                      fontSize: 16.0,
                      color: PdfColors.black,
                    ),
                  ),
                  pw.Divider(
                    thickness: 1.5,
                    color: PdfColors.grey,
                    height: 20.0,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${_addLeadingZeroIfNeeded(date.day)}-${_addLeadingZeroIfNeeded(date.month)}-${date.year}';
  }

  String _addLeadingZeroIfNeeded(int value) {
    if (value < 10) {
      return '0$value';
    }
    return value.toString();
  }
}
