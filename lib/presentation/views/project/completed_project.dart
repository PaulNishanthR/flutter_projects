// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_projects/domain/model/project/project.dart';
// import 'package:flutter_projects/presentation/providers/project/project_provider.dart';
// import 'package:flutter_projects/presentation/widgets/sidebar/generate_pdf.dart';
// import 'package:flutter_projects/utils/app_notifications/app_notification.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lottie/lottie.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;

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
//     final projects = ref
//         .watch(projectsProvider)
//         .where((project) => project.completed)
//         .toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.reports),
//       ),
//       body: projects.isNotEmpty
//           ? Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ListView.builder(
//                 itemCount: projects.length,
//                 itemBuilder: (context, index) {
//                   final project = projects.reversed.toList()[index];
//                   // final isChecked = selectedProjectIds.contains(project.id);

//                   return Container(
//                     // color: isChecked ? Colors.green : Colors.blue[200],
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.0),
//                       color: Colors.purple.shade50,
//                       border: Border.all(color: Colors.purple, width: 1),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.3),
//                           spreadRadius: 2,
//                           blurRadius: 5,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
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
//                           Align(
//                             alignment: Alignment.centerRight,
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 _showProjectDetails(context, project);
//                                 NotificationManager.showReportNotification(
//                                     fileName:
//                                         'Report for ${project.projectName} Was Generated Successfully!');
//                               },
//                               child: const Text('Get Report'),
//                             ),
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
//                   Padding(
//                     padding: const EdgeInsets.only(left: 15, top: 15),
//                     child: Lottie.asset(
//                       "assets/empty_projects.json",
//                       width: 300,
//                       height: 200,
//                     ),
//                   ),
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

//   void _showProjectDetails(BuildContext context, Project project) async {
//     final pdfFile = await generatePDF(project);
//     if (context.mounted) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => PDFDisplayPage(pdfFile: pdfFile),
//         ),
//       );
//     }
//   }

//   Future<File> generatePDF(Project project) async {
//     final pdf = pw.Document();

//     const PdfColor primaryColor = PdfColors.blue;
//     final pw.TextStyle titleStyle = pw.TextStyle(
//       fontWeight: pw.FontWeight.bold,
//       fontSize: 30,
//       color: primaryColor,
//     );
//     pw.TextStyle subtitleStyle = const pw.TextStyle(
//       fontSize: 18.0,
//       color: PdfColors.black,
//     );

//     pdf.addPage(
//       pw.MultiPage(
//         margin: const pw.EdgeInsets.all(20.0),
//         build: (context) => [
//           pw.Header(
//             level: 0,
//             child: pw.Container(
//               margin: const pw.EdgeInsets.only(bottom: 20.0),
//               child: pw.Text(
//                 'Project Report for ${project.projectName}',
//                 style: titleStyle,
//               ),
//             ),
//           ),
//           _buildSection('Project Details', [
//             _buildDetail('Name', project.projectName),
//             _buildDetail('Description', project.description),
//             _buildDetail('Manager', project.owner),
//             _buildDetail('Start Date', _formatDate(project.startDate)),
//             _buildDetail('End Date', _formatDate(project.endDate)),
//             _buildDetail('Work Hours', project.workHours.toString()),
//           ]),
//           _buildSection('Tasks', [
//             for (var task in project.tasks)
//               pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   pw.SizedBox(height: 10),
//                   pw.Text(
//                     'Task: ${task.taskName}',
//                     style: subtitleStyle,
//                   ),
//                   pw.Text(
//                     'Description: ${task.description}',
//                     style: subtitleStyle,
//                   ),
//                   pw.Text(
//                     'Due Date: ${_formatDate(task.dueDate)}',
//                     style: subtitleStyle,
//                   ),
//                   pw.Text(
//                     'Hours: ${task.hours}',
//                     style: subtitleStyle,
//                   ),
//                   pw.Text(
//                     'Assigned Members: ${task.teamMembers?.join(', ') ?? 'None'}',
//                     style: subtitleStyle,
//                   ),
//                   pw.Text(
//                     'Priority: ${task.taskPriority.toString().split('.').last}',
//                     style: subtitleStyle,
//                   ),
//                   pw.Divider(
//                     thickness: 1.5,
//                     color: primaryColor,
//                     height: 20.0,
//                   ),
//                 ],
//               ),
//           ]),
//         ],
//       ),
//     );

//     final output = await getTemporaryDirectory();
//     final pdfFile = File('${output.path}/${project.projectName}.pdf');
//     await pdfFile.writeAsBytes(await pdf.save());
//     return pdfFile;
//   }

//   pw.Widget _buildSection(String title, List<pw.Widget> widgets) {
//     return pw.Container(
//       margin: const pw.EdgeInsets.symmetric(vertical: 10.0),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Text(
//             title,
//             style: pw.TextStyle(
//               fontWeight: pw.FontWeight.bold,
//               fontSize: 24,
//               color: PdfColors.blue,
//             ),
//           ),
//           pw.SizedBox(height: 10),
//           for (var widget in widgets) widget,
//         ],
//       ),
//     );
//   }

//   pw.Widget _buildDetail(String label, String value) {
//     return pw.Container(
//       margin: const pw.EdgeInsets.symmetric(vertical: 5.0),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Text(
//             '$label: $value',
//             style: const pw.TextStyle(
//               fontSize: 18.0,
//               color: PdfColors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     return '${_addLeadingZeroIfNeeded(date.day)}-${_addLeadingZeroIfNeeded(date.month)}-${date.year}';
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
import 'package:flutter_projects/domain/model/project/project.dart';
import 'package:flutter_projects/presentation/providers/project/project_provider.dart';
import 'package:flutter_projects/presentation/widgets/sidebar/generate_pdf.dart';
import 'package:flutter_projects/utils/app_notifications/app_notification.dart';
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
      ),
      body: projects.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects.reversed.toList()[index];

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      // color: Colors.purple.shade50,
                      color: const Color.fromARGB(255, 240, 234, 238),
                      border: Border.all(color: Colors.purple, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${AppLocalizations.of(context)!.projectName}: ${project.projectName}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${AppLocalizations.of(context)!.manager}: ${project.owner}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
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
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _showProjectDetails(context, project);
                                NotificationManager.showReportNotification(
                                    fileName:
                                        'Report for ${project.projectName} Was Generated Successfully!');
                              },
                              icon: const Icon(
                                Icons.picture_as_pdf,
                                color: Colors.black,
                              ),
                              label: const Text(
                                'Get Report',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.purple.shade100,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
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
            ),
    );
  }

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

    const PdfColor primaryColor = PdfColors.purple300;
    final pw.TextStyle titleStyle = pw.TextStyle(
      fontWeight: pw.FontWeight.bold,
      fontSize: 30,
      color: primaryColor,
    );
    pw.TextStyle subtitleStyle = const pw.TextStyle(
      fontSize: 18.0,
      color: PdfColors.black,
    );

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(20.0),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 20.0),
              child: pw.Text(
                'Project Report for ${project.projectName}',
                style: titleStyle,
              ),
            ),
          ),
          _buildSection('Project Details', [
            _buildDetail('Name', project.projectName),
            _buildDetail('Description', project.description),
            _buildDetail('Manager', project.owner),
            _buildDetail('Start Date', _formatDate(project.startDate)),
            _buildDetail('End Date', _formatDate(project.endDate)),
            _buildDetail('Work Hours', project.workHours.toString()),
          ]),
          _buildSection('Tasks', [
            for (var task in project.tasks)
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Task: ${task.taskName}',
                    style: subtitleStyle,
                  ),
                  pw.Text(
                    'Description: ${task.description}',
                    style: subtitleStyle,
                  ),
                  pw.Text(
                    'Due Date: ${_formatDate(task.dueDate)}',
                    style: subtitleStyle,
                  ),
                  pw.Text(
                    'Hours: ${task.hours}',
                    style: subtitleStyle,
                  ),
                  pw.Text(
                    'Assigned Members: ${task.teamMembers?.join(', ') ?? 'None'}',
                    style: subtitleStyle,
                  ),
                  pw.Text(
                    'Priority: ${task.taskPriority.toString().split('.').last}',
                    style: subtitleStyle,
                  ),
                  pw.Divider(
                    thickness: 1.5,
                    color: primaryColor,
                    height: 20.0,
                  ),
                ],
              ),
          ]),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final pdfFile = File('${output.path}/${project.projectName}.pdf');
    await pdfFile.writeAsBytes(await pdf.save());
    return pdfFile;
  }

  pw.Widget _buildSection(String title, List<pw.Widget> widgets) {
    List<pw.Widget> contentWidgets = [];

    contentWidgets.add(
      pw.Text(
        title,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 24,
          color: PdfColors.purple300,
        ),
      ),
    );

    for (var widget in widgets) {
      contentWidgets.add(widget);
      contentWidgets.add(pw.SizedBox(height: 10));
    }

    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 10.0),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 24,
              color: PdfColors.purple300,
            ),
          ),
          pw.SizedBox(height: 10),
          for (var widget in widgets) widget,
        ],
      ),
    );
  }

  pw.Widget _buildDetail(String label, String value) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 5.0),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '$label: $value',
            style: const pw.TextStyle(
              fontSize: 18.0,
              color: PdfColors.black,
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
