// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:flutter_projects/domain/model/completed_project.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// // import 'package:share_plus/share_plus.dart';
// // import 'package:task_management/tasks/domain/models/completed.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class PDFGenerator extends ConsumerStatefulWidget {
//   final List<CompletedProject> completedTasks;
//   const PDFGenerator({Key? key, required this.completedTasks})
//       : super(key: key);
//   @override
//   ConsumerState createState() => _PDFGeneratorState();
// }

// class _PDFGeneratorState extends ConsumerState<PDFGenerator> {
//   late pw.Document pdf;
//   late File pdfFile;
//   @override
//   void initState() {
//     super.initState();
//     generatePDF();
//   }

//   Future<void> generatePDF() async {
//     pdf = pw.Document();
//     pdf.addPage(
//       pw.MultiPage(
//         margin: const pw.EdgeInsets.all(20.0),
//         build: (context) => [
//           pw.Header(
//             level: 0,
//             child: pw.Container(
//               margin: const pw.EdgeInsets.only(bottom: 20.0),
//               child: pw.Text(
//                 'Project Report',
//                 style: pw.TextStyle(
//                   fontWeight: pw.FontWeight.bold,
//                   fontSize: 30,
//                   color: PdfColors.blue,
//                 ),
//               ),
//             ),
//           ),
//           pw.ListView.builder(
//             itemCount: widget.completedTasks.length,
//             itemBuilder: (context, index) {
//               final completedTask = widget.completedTasks[index];
//               // String displayTime =
//               //     '${(completedTask.seconds ~/ 3600).toString().padLeft(2, '0')}'
//               //     ':${((completedTask.seconds ~/ 60) % 60).toString().padLeft(2, '0')}'
//               //     ':${(completedTask.seconds % 60).toString().padLeft(2, '0')}';

//               return pw.Container(
//                 margin: const pw.EdgeInsets.symmetric(vertical: 10.0),
//                 child: pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Text(
//                       completedTask.task.taskName,
//                       style: pw.TextStyle(
//                         fontWeight: pw.FontWeight.bold,
//                         fontSize: 24,
//                       ),
//                     ),
//                     pw.SizedBox(height: 10),
//                     pw.Text(
//                       'Time Spent: $displayTime',
//                       style: const pw.TextStyle(
//                         fontSize: 18.0,
//                         color: PdfColors.grey,
//                       ),
//                     ),
//                     pw.Divider(
//                       thickness: 1.0,
//                       color: PdfColors.grey,
//                       height: 20.0,
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//     // Save the PDF to a file
//     final output = await getTemporaryDirectory();
//     pdfFile = File('${output.path}/Completed_Tasks.pdf');
//     await pdfFile.writeAsBytes(await pdf.save());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           AppLocalizations.of(context)!.generatePDF,
//           style: const TextStyle(
//               fontFamily: 'Poppins', fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => PDFDisplayPage(pdfFile: pdfFile),
//               ),
//             );
//           },
//           style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red.shade700,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               )),
//           child: Text(
//             AppLocalizations.of(context)!.generatePDF,
//             style: const TextStyle(
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class PDFDisplayPage extends StatelessWidget {
//   final File pdfFile;
//   const PDFDisplayPage({Key? key, required this.pdfFile}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'sharePDF',
//           style: TextStyle(
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.share),
//             onPressed: () async {
//               final bytes = await pdfFile.readAsBytes();
//               final tempDir = await getTemporaryDirectory();
//               final tempFilePath = '${tempDir.path}/Completed_Projects.pdf';
//               final tempPdfFile = File(tempFilePath);
//               await tempPdfFile.writeAsBytes(bytes);
//               await Share.shareXFiles(
//                 [XFile(tempFilePath)],
//                 text: 'Share PDF',
//               );
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: PDFView(filePath: pdfFile.path),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_projects/domain/model/completed_project.dart';
import 'package:flutter_projects/presentation/providers/completed_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PDFGenerator extends ConsumerStatefulWidget {
  const PDFGenerator({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _PDFGeneratorState();
}

class _PDFGeneratorState extends ConsumerState<PDFGenerator> {
  late pw.Document pdf;
  late File pdfFile;

  @override
  void initState() {
    super.initState();
    generatePDF();
  }

  Future<void> generatePDF() async {
    // Fetch completed tasks from the provider
    final completedTasks = ref.read(completedProvider);

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
          for (var completedProject in completedTasks)
            buildProjectSection(completedProject),
        ],
      ),
    );
    // Save the PDF to a file
    final output = await getTemporaryDirectory();
    pdfFile = File('${output.path}/Completed_Tasks.pdf');
    await pdfFile.writeAsBytes(await pdf.save());
  }

  pw.Widget buildProjectSection(CompletedProject project) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 10.0),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            project.projectName,
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
              color: PdfColors.grey,
            ),
          ),
          pw.Text(
            'Owner: ${project.owner}',
            style: const pw.TextStyle(
              fontSize: 18.0,
              color: PdfColors.grey,
            ),
          ),
          pw.Text(
            'Start Date: ${project.startDate}',
            style: const pw.TextStyle(
              fontSize: 18.0,
              color: PdfColors.grey,
            ),
          ),
          pw.Text(
            'End Date: ${project.endDate}',
            style: const pw.TextStyle(
              fontSize: 18.0,
              color: PdfColors.grey,
            ),
          ),
          pw.Text(
            'Work Hours: ${project.workHours}',
            style: const pw.TextStyle(
              fontSize: 18.0,
              color: PdfColors.grey,
            ),
          ),
          pw.Text(
            'Team Members: ${project.teamMembers}',
            style: const pw.TextStyle(
              fontSize: 18.0,
              color: PdfColors.grey,
            ),
          ),
          pw.SizedBox(height: 10),
          for (var task in project.tasks)
            pw.Text(
              'Task: ${task.taskName}',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          // AppLocalizations.of(context)?.generatePDF ??
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
            // AppLocalizations.of(context)?.generatePDF ??
            'Generate PDF',
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
              final tempFilePath = '${tempDir.path}/Completed_Projects.pdf';
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
