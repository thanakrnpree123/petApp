import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../models/pet.dart';
import '../../services/pdf_report_service.dart';

class PdfPreviewScreen extends StatelessWidget {
  final Pet pet;

  const PdfPreviewScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final reportService = PdfReportService();

    return Scaffold(
      appBar: AppBar(title: Text('${pet.name} · Vet Report')),
      body: PdfPreview(
        pdfFileName: 'pawhealth_${pet.name}_report.pdf',
        build: (format) =>
            reportService.generateReport(userId: userId, pet: pet),
      ),
    );
  }
}
