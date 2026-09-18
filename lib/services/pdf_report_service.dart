import 'dart:typed_data';

import 'dart:ui' show Locale;

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../data/decision_trees/decision_tree.dart';
import '../l10n/app_localizations.dart';
import '../models/care_log.dart';
import '../models/health_log.dart';
import '../models/pet.dart';
import '../models/symptom_check.dart';
import '../models/vaccination.dart';
import '../utils/app_dates.dart';
import '../utils/l10n_helpers.dart';
import 'report_tables.dart';
import 'health_log_service.dart';
import 'symptom_check_service.dart';

/// Builds the A4 vet report in the app language.
///
/// The PDF can't use system fonts: Helvetica draws Latin, and Thai and
/// Chinese (labels or user-entered names and notes) fall back to the
/// bundled Noto Sans Thai and a Noto Sans SC subset (tool/fonts). Without
/// them those scripts render as empty boxes.
class PdfReportService {
  // Lazily created so buildReport (pure layout, used in tests) never
  // touches Firebase; only generateReport's data fetch needs them.
  HealthLogService? _healthLogService;
  SymptomCheckService? _symptomCheckService;

  PdfReportService({
    HealthLogService? healthLogService,
    SymptomCheckService? symptomCheckService,
  }) {
    _healthLogService = healthLogService;
    _symptomCheckService = symptomCheckService;
  }

  static const _recentWeightLogLimit = 10;

  Future<Uint8List> generateReport({
    required String userId,
    required Pet pet,
    required AppLocalizations l10n,
  }) async {
    final healthLogService = _healthLogService ??= HealthLogService();
    final symptomCheckService = _symptomCheckService ??= SymptomCheckService();

    final allLogs = await healthLogService.watchLogs(userId, pet.id!).first;
    final weightLogs =
        allLogs.where((l) => l.type == HealthLogType.weight).toList()
          ..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
    final recentWeightLogs = weightLogs.length > _recentWeightLogLimit
        ? weightLogs.sublist(weightLogs.length - _recentWeightLogLimit)
        : weightLogs;

    final vaccinations = await healthLogService
        .watchVaccinations(userId, pet.id!)
        .first;
    final careLogs = await healthLogService
        .watchCareLogs(userId, pet.id!)
        .first;
    final latestCheck = await symptomCheckService.getLatestCheck(
      userId,
      pet.id!,
    );

    return buildReport(
      pet: pet,
      l10n: l10n,
      recentWeightLogs: recentWeightLogs,
      vaccinations: vaccinations,
      careLogs: careLogs,
      latestCheck: latestCheck,
    );
  }

  /// Pure layout step — no Firestore. Kept separate so it is unit-testable
  /// (including Thai text rendering) without a backend.
  Future<Uint8List> buildReport({
    required Pet pet,
    required AppLocalizations l10n,
    List<HealthLog> recentWeightLogs = const [],
    List<Vaccination> vaccinations = const [],
    List<CareLog> careLogs = const [],
    SymptomCheck? latestCheck,
    @visibleForTesting bool compress = true,
  }) async {
    final thaiRegular = pw.Font.ttf(
      await rootBundle.load('assets/fonts/NotoSansThai-Regular.ttf'),
    );
    final thaiBold = pw.Font.ttf(
      await rootBundle.load('assets/fonts/NotoSansThai-Bold.ttf'),
    );
    // Regular only: Chinese in bold headings renders at regular weight,
    // which beats a second multi-megabyte font.
    final chinese = pw.Font.ttf(
      await rootBundle.load('assets/fonts/NotoSansSC-Subset.ttf'),
    );
    final logo = pw.MemoryImage(
      (await rootBundle.load(
        'assets/images/splash_logo.png',
      )).buffer.asUint8List(),
    );

    final vaccinationHistory = [...vaccinations]
      ..sort((a, b) => b.dateAdministered.compareTo(a.dateAdministered));
    final careTimeline = [...careLogs]
      ..sort((a, b) => b.loggedAt.compareTo(a.loggedAt));

    final writer = _ReportWriter(l10n);
    final doc = pw.Document(
      compress: compress,
      title: l10n.pdfDocumentTitle(pet.name),
      theme: pw.ThemeData.withFont(
        // Helvetica stays the Latin base; other scripts fall back glyph by
        // glyph to the bundled fonts.
        fontFallback: [thaiRegular, thaiBold, chinese],
      ),
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        header: (context) => writer.header(logo),
        footer: writer.footer,
        build: (context) => [
          pw.SizedBox(height: 14),
          writer.petSummary(pet),
          pw.SizedBox(height: 22),
          writer.sectionTitle(l10n.pdfWeightTrend),
          pw.SizedBox(height: 8),
          writer.weightChart(recentWeightLogs),
          pw.SizedBox(height: 22),
          writer.sectionTitle(l10n.pdfVaccinationHistory),
          pw.SizedBox(height: 8),
          writer.vaccinationTable(vaccinationHistory),
          pw.SizedBox(height: 22),
          writer.sectionTitle(l10n.pdfCareLog),
          pw.SizedBox(height: 8),
          writer.careLogTable(careTimeline),
          pw.SizedBox(height: 22),
          // Kept whole: split across pages, the heading and the answers
          // ended up apart (taller Thai text made that common).
          pw.Inseparable(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                writer.sectionTitle(l10n.pdfLatestSymptomCheck),
                pw.SizedBox(height: 8),
                writer.symptomCheckSection(latestCheck),
              ],
            ),
          ),
          pw.SizedBox(height: 26),
          writer.vetNotesSection(),
        ],
      ),
    );

    return doc.save();
  }
}

/// The report's widgets, written in one language.
class _ReportWriter {
  final AppLocalizations l10n;
  final AppDateFormat _date;

  _ReportWriter(this.l10n)
    : _date = AppDates.mediumFor(Locale(l10n.localeName));

  static const _accent = PdfColors.teal800;

  pw.Widget header(pw.MemoryImage logo) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Row(
            children: [
              pw.Image(logo, width: 26, height: 26),
              pw.SizedBox(width: 8),
              pw.Text(
                'PawHealth',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: _accent,
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Text(
                l10n.pdfReportSubtitle,
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
          pw.Text(
            l10n.pdfGeneratedOn(_date.format(DateTime.now())),
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  pw.Widget footer(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      padding: const pw.EdgeInsets.only(top: 6),
      child: pw.Text(
        l10n.pdfPageOf(context.pageNumber, context.pagesCount),
        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
      ),
    );
  }

  pw.Widget sectionTitle(String title) {
    return pw.Row(
      children: [
        pw.Container(width: 3, height: 12, color: _accent),
        pw.SizedBox(width: 6),
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 13,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey800,
          ),
        ),
      ],
    );
  }

  pw.Widget petSummary(Pet pet) {
    final age = L10nHelpers.petAge(l10n, pet);
    final species = L10nHelpers.species(l10n, pet.species);
    final sex = pet.gender == PetGender.female
        ? l10n.genderFemale
        : l10n.genderMale;
    final none = l10n.pdfNoneOnFile;

    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            pet.name,
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            pet.breed.isEmpty ? species : '$species · ${pet.breed}',
            style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            children: [
              _summaryStat(l10n.pdfAge, age),
              _summaryStat(
                l10n.weight,
                l10n.pdfWeightKg(pet.weightKg.toStringAsFixed(1)),
              ),
              _summaryStat(
                l10n.pdfSex,
                pet.isNeutered ? l10n.pdfNeutered(sex) : sex,
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              _summaryStat(l10n.microchipId, pet.microchipId ?? none),
              _summaryStat(l10n.pdfAllergies, pet.allergies ?? none),
              _summaryStat(
                l10n.pdfBreedRisks,
                pet.breedDisorders.isEmpty
                    ? none
                    : pet.breedDisorders.map(_humanize).join(', '),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _summaryStat(String label, String value) {
    return pw.Expanded(
      child: pw.Padding(
        padding: const pw.EdgeInsets.only(right: 12),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label.toUpperCase(),
              style: const pw.TextStyle(
                fontSize: 7.5,
                color: PdfColors.grey600,
              ),
            ),
            pw.SizedBox(height: 2),
            pw.Text(value, style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  pw.Widget _emptyNote(String text) {
    return pw.Text(
      text,
      style: const pw.TextStyle(
        fontSize: 10,
        fontStyle: pw.FontStyle.italic,
        color: PdfColors.grey600,
      ),
    );
  }

  pw.Widget vaccinationTable(List<Vaccination> vaccinations) {
    if (vaccinations.isEmpty) {
      return _emptyNote(l10n.pdfNoVaccinations);
    }
    return _table(ReportTables.vaccinations(l10n, _date, vaccinations));
  }

  /// Renders a [ReportTable] in the report's house style.
  pw.Widget _table(ReportTable table) {
    return pw.TableHelper.fromTextArray(
      headers: table.headers,
      data: table.rows,
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        fontSize: 9.5,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: _accent),
      cellStyle: const pw.TextStyle(fontSize: 9.5),
      cellPadding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
      border: null,
      columnWidths: {
        for (final entry in table.flexWidths.entries)
          entry.key: pw.FlexColumnWidth(entry.value),
      },
    );
  }

  pw.Widget careLogTable(List<CareLog> careLogs) {
    if (careLogs.isEmpty) {
      return _emptyNote(l10n.pdfNoCareLogs);
    }
    return _table(ReportTables.careLogs(l10n, _date, careLogs));
  }

  pw.Widget weightChart(List<HealthLog> sortedWeightLogs) {
    if (sortedWeightLogs.length < 2) {
      return _emptyNote(l10n.pdfNotEnoughWeights);
    }

    final values = sortedWeightLogs.map((l) => l.value ?? 0).toList();
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final range = (maxValue - minValue).abs() < 0.01
        ? 1.0
        : maxValue - minValue;

    const chartWidth = 500.0;
    const chartHeight = 120.0;
    const padding = 10.0;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          // The ARB strings keep a plain hyphen-minus, not an en dash: the en
          // dash glyph is missing from the PDF fonts and rendered as nothing
          // ("17.060.0 kg").
          l10n.pdfWeightRange(
            minValue.toStringAsFixed(1),
            maxValue.toStringAsFixed(1),
            sortedWeightLogs.length,
          ),
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 6),
        pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
          ),
          child: pw.CustomPaint(
            size: const PdfPoint(chartWidth, chartHeight),
            painter: (canvas, size) {
              final plotWidth = size.x - padding * 2;
              final plotHeight = size.y - padding * 2;
              final stepX = values.length > 1
                  ? plotWidth / (values.length - 1)
                  : 0.0;

              canvas
                ..setStrokeColor(PdfColors.grey200)
                ..setLineWidth(0.5);
              for (var i = 1; i <= 3; i++) {
                final y = padding + plotHeight * i / 4;
                canvas
                  ..moveTo(padding, y)
                  ..lineTo(size.x - padding, y)
                  ..strokePath();
              }

              canvas
                ..setStrokeColor(PdfColors.teal)
                ..setLineWidth(1.5);
              for (var i = 0; i < values.length; i++) {
                final x = padding + stepX * i;
                final normalized = (values[i] - minValue) / range;
                final y = size.y - padding - normalized * plotHeight;
                if (i == 0) {
                  canvas.moveTo(x, y);
                } else {
                  canvas.lineTo(x, y);
                }
              }
              canvas.strokePath();

              canvas.setColor(PdfColors.teal);
              for (var i = 0; i < values.length; i++) {
                final x = padding + stepX * i;
                final normalized = (values[i] - minValue) / range;
                final y = size.y - padding - normalized * plotHeight;
                canvas.drawEllipse(x, y, 2, 2);
                canvas.fillPath();
              }
            },
          ),
        ),
      ],
    );
  }

  pw.Widget symptomCheckSection(SymptomCheck? check) {
    if (check == null) {
      return _emptyNote(l10n.pdfNoSymptomChecks);
    }

    final triageColor = switch (check.triageLevel) {
      TriageLevel.monitor => PdfColors.green700,
      TriageLevel.vet => PdfColors.orange700,
      TriageLevel.emergency => PdfColors.red700,
    };

    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: triageColor, width: 1),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Text(
                L10nHelpers.symptomName(l10n, check.symptomId),
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Spacer(),
              pw.Text(
                L10nHelpers.triageLabel(l10n, check.triageLevel),
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: triageColor,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            l10n.pdfCheckedOn(_date.format(check.checkedAt)),
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            L10nHelpers.savedAdvice(l10n, check),
            style: const pw.TextStyle(fontSize: 10),
          ),
          if (check.answers.isNotEmpty) ...[
            pw.SizedBox(height: 8),
            pw.Text(
              l10n.pdfAnswers,
              style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
            ),
            for (final saved in check.answers)
              pw.Text(() {
                final a = L10nHelpers.savedAnswer(l10n, check, saved);
                return '• ${a.question} ${a.answer}';
              }(), style: const pw.TextStyle(fontSize: 9)),
          ],
        ],
      ),
    );
  }

  pw.Widget vetNotesSection() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        sectionTitle(l10n.pdfVetNotes),
        pw.SizedBox(height: 10),
        for (var i = 0; i < 5; i++)
          pw.Container(
            height: 20,
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.grey400, width: 0.5),
              ),
            ),
          ),
      ],
    );
  }

  // Breed conditions are canonical English ids from the breed data, e.g.
  // hip_dysplasia; they stay English (medical terms a vet reads).
  String _humanize(String raw) => raw.replaceAll('_', ' ');
}
