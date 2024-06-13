import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_projects/domain/model/project.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:share_plus/share_plus.dart';

class PDFGenerator extends StatefulWidget {
  final Project project;

  const PDFGenerator({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  State<PDFGenerator> createState() => _PDFGeneratorState();
}

class _PDFGeneratorState extends State<PDFGenerator> {
  late pw.Document pdf;
  late File pdfFile;

  @override
  void initState() {
    super.initState();
    generatePDF();
  }

  Future<void> generatePDF() async {
    pdf = pw.Document();
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
          buildProjectSection(widget.project),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    pdfFile = File('${output.path}/Completed_Project.pdf');
    await pdfFile.writeAsBytes(await pdf.save());
    setState(() {});
  }

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
  //             color: PdfColors.grey,
  //           ),
  //         ),
  //         pw.Text(
  //           'Owner: ${project.owner}',
  //           style: const pw.TextStyle(
  //             fontSize: 18.0,
  //             color: PdfColors.grey,
  //           ),
  //         ),
  //         pw.Text(
  //           'Start Date: ${project.startDate}',
  //           style: const pw.TextStyle(
  //             fontSize: 18.0,
  //             color: PdfColors.grey,
  //           ),
  //         ),
  //         pw.Text(
  //           'End Date: ${project.endDate}',
  //           style: const pw.TextStyle(
  //             fontSize: 18.0,
  //             color: PdfColors.grey,
  //           ),
  //         ),
  //         pw.Text(
  //           'Work Hours: ${project.workHours}',
  //           style: const pw.TextStyle(
  //             fontSize: 18.0,
  //             color: PdfColors.grey,
  //           ),
  //         ),
  //         pw.Text(
  //           'Team Members: ${project.teamMembers}',
  //           style: const pw.TextStyle(
  //             fontSize: 18.0,
  //             color: PdfColors.grey,
  //           ),
  //         ),
  //         pw.Text(
  //           'Completed: YES',
  //           style: const pw.TextStyle(
  //             fontSize: 18.0,
  //             color: PdfColors.grey,
  //           ),
  //         ),
  //         pw.SizedBox(height: 10),
  //         for (var task in project.tasks)
  //           pw.Text(
  //             'Task: ${task.taskName}',
  //             style: const pw.TextStyle(
  //               fontSize: 16.0,
  //               color: PdfColors.black,
  //             ),
  //           ),
  //         for (var task in project.tasks)
  //           pw.Text(
  //             'Description: ${task.description}',
  //             style: const pw.TextStyle(
  //               fontSize: 16.0,
  //               color: PdfColors.black,
  //             ),
  //           ),
  //         for (var task in project.tasks)
  //           pw.Text(
  //             'dueDate: ${task.dueDate}',
  //             style: const pw.TextStyle(
  //               fontSize: 16.0,
  //               color: PdfColors.black,
  //             ),
  //           ),
  //         for (var task in project.tasks)
  //           pw.Text(
  //             'hours: ${task.hours}',
  //             style: const pw.TextStyle(
  //               fontSize: 16.0,
  //               color: PdfColors.black,
  //             ),
  //           ),
  //         for (var task in project.tasks)
  //           pw.Text(
  //             'assignedMembers: ${task.assignedMembers?.join(', ')}',
  //             style: const pw.TextStyle(
  //               fontSize: 16.0,
  //               color: PdfColors.black,
  //             ),
  //           ),
  //         pw.Divider(
  //           thickness: 1.0,
  //           color: PdfColors.grey,
  //           height: 20.0,
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
            'Start Date: ${project.startDate}',
            style: const pw.TextStyle(
              fontSize: 18.0,
              color: PdfColors.black,
            ),
          ),
          pw.Text(
            'End Date: ${project.endDate}',
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
          // pw.Text(
          //   'Total Team Members: ${project.teamMembers}',
          //   style: const pw.TextStyle(
          //     fontSize: 18.0,
          //     color: PdfColors.grey,
          //   ),
          // ),
          // pw.Text(
          //   'Assigned Team Members: ${project.assignedTeamMembers?.join(', ') ?? 'None'}',
          //   style: const pw.TextStyle(
          //     fontSize: 18.0,
          //     color: PdfColors.grey,
          //   ),
          // ),
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
                    'Due Date: ${task.dueDate}',
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
                    thickness: 1.0,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Generate PDF',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PDFDisplayPage(pdfFile: pdfFile),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )),
          child: const Text(
            'View PDF',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class PDFDisplayPage extends StatelessWidget {
  final File pdfFile;
  const PDFDisplayPage({Key? key, required this.pdfFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'sharePDF',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              final bytes = await pdfFile.readAsBytes();
              final tempDir = await getTemporaryDirectory();
              final tempFilePath = '${tempDir.path}/Completed_Project.pdf';
              final tempPdfFile = File(tempFilePath);
              await tempPdfFile.writeAsBytes(bytes);
              // await Share.shareXFiles(
              //   [XFile(tempFilePath)],
              //   text: 'Share PDF',
              // );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PDFView(filePath: pdfFile.path),
            ),
          ),
        ],
      ),
    );
  }
}
