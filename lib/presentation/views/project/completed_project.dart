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
                                NotificationManager.showReportNotification(
                                    fileName:
                                        'Report for ${project.projectName} Was Generated Successfully!');
                              },
                              child: const Text('Get Report'),
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

  // Future<File> generatePDF(Project project) async {
  //   final pdf = pw.Document();
  //   pdf.addPage(
  //     pw.MultiPage(
  //       margin: const pw.EdgeInsets.all(20.0),
  //       build: (context) => [
  //         pw.Header(
  //           level: 0,
  //           child: pw.Container(
  //             margin: const pw.EdgeInsets.only(bottom: 20.0),
  //             child: pw.Text(
  //               'Project Report for ${project.projectName}',
  //               style: pw.TextStyle(
  //                 fontWeight: pw.FontWeight.bold,
  //                 fontSize: 30,
  //                 color: PdfColors.blue,
  //               ),
  //             ),
  //           ),
  //         ),
  //         buildProjectSection(project),
  //       ],
  //     ),
  //   );

  //   final output = await getTemporaryDirectory();
  //   final pdfFile = File('${output.path}/${project.projectName}.pdf');
  //   await pdfFile.writeAsBytes(await pdf.save());
  //   return pdfFile;
  // }

  // pw.Widget buildProjectSection(Project project) {
  //   return pw.Container(
  //     margin: const pw.EdgeInsets.symmetric(vertical: 10.0),
  //     child: pw.Column(
  //       crossAxisAlignment: pw.CrossAxisAlignment.start,
  //       children: [
  //         pw.Text(
  //           'Name: ${project.projectName}',
  //           style: pw.TextStyle(
  //             fontWeight: pw.FontWeight.bold,
  //             fontSize: 24,
  //           ),
  //         ),
  //         pw.SizedBox(height: 10),
  //         pw.Text(
  //           'Description: ${project.description}',
  //           style: const pw.TextStyle(
  //             fontSize: 18.0,
  //             color: PdfColors.black,
  //           ),
  //         ),
  //         pw.Text(
  //           'Manager: ${project.owner}',
  //           style: const pw.TextStyle(
  //             fontSize: 18.0,
  //             color: PdfColors.black,
  //           ),
  //         ),
  //         pw.Text(
  //           'Start Date: ${_formatDate(project.startDate)}',
  //           style: const pw.TextStyle(
  //             fontSize: 18.0,
  //             color: PdfColors.black,
  //           ),
  //         ),
  //         pw.Text(
  //           'End Date: ${_formatDate(project.endDate)}',
  //           style: const pw.TextStyle(
  //             fontSize: 18.0,
  //             color: PdfColors.black,
  //           ),
  //         ),
  //         pw.Text(
  //           'Work Hours: ${project.workHours}',
  //           style: const pw.TextStyle(
  //             fontSize: 18.0,
  //             color: PdfColors.black,
  //           ),
  //         ),
  //         pw.Divider(
  //           thickness: 0.5,
  //           color: PdfColors.grey,
  //           height: 20.0,
  //         ),
  //         pw.SizedBox(height: 10),
  //         for (var task in project.tasks)
  //           pw.Container(
  //             margin: const pw.EdgeInsets.symmetric(vertical: 5.0),
  //             child: pw.Column(
  //               crossAxisAlignment: pw.CrossAxisAlignment.start,
  //               children: [
  //                 pw.Text(
  //                   'Task: ${task.taskName}',
  //                   style: const pw.TextStyle(
  //                     fontSize: 16.0,
  //                     color: PdfColors.black,
  //                   ),
  //                 ),
  //                 pw.Text(
  //                   'Description: ${task.description}',
  //                   style: const pw.TextStyle(
  //                     fontSize: 16.0,
  //                     color: PdfColors.black,
  //                   ),
  //                 ),
  //                 pw.Text(
  //                   'Due Date: ${_formatDate(task.dueDate)}',
  //                   style: const pw.TextStyle(
  //                     fontSize: 16.0,
  //                     color: PdfColors.black,
  //                   ),
  //                 ),
  //                 pw.Text(
  //                   'Hours: ${task.hours}',
  //                   style: const pw.TextStyle(
  //                     fontSize: 16.0,
  //                     color: PdfColors.black,
  //                   ),
  //                 ),
  //                 pw.Text(
  //                   'Assigned Members: ${task.teamMembers?.join(', ') ?? 'None'}',
  //                   style: const pw.TextStyle(
  //                     fontSize: 16.0,
  //                     color: PdfColors.black,
  //                   ),
  //                 ),
  //                 pw.Text(
  //                     'Priority: ${task.taskPriority.toString().split('.').last}',
  //                     style: const pw.TextStyle(
  //                       fontSize: 16.0,
  //                       color: PdfColors.black,
  //                     )),
  //                 pw.Divider(
  //                   thickness: 1.5,
  //                   color: PdfColors.grey,
  //                   height: 20.0,
  //                 ),
  //               ],
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  // String _formatDate(DateTime date) {
  //   return '${_addLeadingZeroIfNeeded(date.day)}-${_addLeadingZeroIfNeeded(date.month)}-${date.year}';
  // }

  // String _addLeadingZeroIfNeeded(int value) {
  //   if (value < 10) {
  //     return '0$value';
  //   }
  //   return value.toString();
  // }

  Future<File> generatePDF(Project project) async {
    final pdf = pw.Document();

    const PdfColor primaryColor = PdfColors.blue;
    final pw.TextStyle titleStyle = pw.TextStyle(
      fontWeight: pw.FontWeight.bold,
      fontSize: 30,
      color: primaryColor,
    );
    pw.TextStyle subtitleStyle = const pw.TextStyle(
      fontSize: 18.0,
      color: PdfColors.black,
    );
    // final pw.TextStyle sectionTitleStyle = pw.TextStyle(
    //   fontSize: 24,
    //   fontWeight: pw.FontWeight.bold,
    //   color: primaryColor,
    // );
    // pw.TextStyle taskTitleStyle = const pw.TextStyle(
    //   fontSize: 18.0,
    //   color: primaryColor,
    // );

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
              color: PdfColors.blue,
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
