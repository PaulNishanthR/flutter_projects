import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:flutter_projects/utils/app_notifications/app_notification.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class PDFDisplayPage extends StatelessWidget {
  final File pdfFile;
  const PDFDisplayPage({Key? key, required this.pdfFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Share Report',
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
              final tempFilePath = '${tempDir.path}/Project Report.pdf';
              final tempPdfFile = File(tempFilePath);
              await tempPdfFile.writeAsBytes(bytes);
              await Share.shareXFiles(
                [XFile(tempFilePath)],
                text: 'Share Report',
              );
            },
          ),
        ],
      ),
      body: PDFView(
        filePath: pdfFile.path,
      ),
    );
  }
}
