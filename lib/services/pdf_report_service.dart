import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../data/decision_trees/decision_tree.dart';
import '../models/care_log.dart';
import '../models/health_log.dart';
import '../models/pet.dart';
import '../models/symptom_check.dart';
import '../models/vaccination.dart';
import 'health_log_service.dart';
import 'symptom_check_service.dart';

/// Builds the A4 vet report.
///
/// Section labels are canonical English (the report is a medical document
/// handed to vets; the service layer has no BuildContext). User-entered
/// content (names, notes, breeds) renders in any script covered by the
/// bundled Noto Sans Thai fallback fonts — without them the default
/// Helvetica would draw Thai text as empty boxes.
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

  static final _dateFormat = DateFormat.yMMMd();
  static const _recentWeightLogLimit = 10;
  static const _accent = PdfColors.teal800;

  Future<Uint8List> generateReport({
    required String userId,
    required Pet pet,
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
    List<HealthLog> recentWeightLogs = const [],
    List<Vaccination> vaccinations = const [],
    List<CareLog> careLogs = const [],
    SymptomCheck? latestCheck,
  }) async {
    final thaiRegular = pw.Font.ttf(
      await rootBundle.load('assets/fonts/NotoSansThai-Regular.ttf'),
    );
    final thaiBold = pw.Font.ttf(
      await rootBundle.load('assets/fonts/NotoSansThai-Bold.ttf'),
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

    final doc = pw.Document(
      title: 'PawHealth Report — ${pet.name}',
      theme: pw.ThemeData.withFont(
        // Helvetica stays the Latin base; Thai glyphs fall back to the
        // bundled Noto Sans Thai so user-entered Thai renders correctly.
        fontFallback: [thaiRegular, thaiBold],
      ),
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        header: (context) => _buildHeader(logo),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          pw.SizedBox(height: 14),
          _buildPetSummary(pet),
          pw.SizedBox(height: 22),
          _buildSectionTitle('Weight Trend'),
          pw.SizedBox(height: 8),
          _buildWeightChart(recentWeightLogs),
          pw.SizedBox(height: 22),
          _buildSectionTitle('Vaccination History'),
          pw.SizedBox(height: 8),
          _buildVaccinationTable(vaccinationHistory),
          pw.SizedBox(height: 22),
          _buildSectionTitle('Health Care Log'),
          pw.SizedBox(height: 8),
          _buildCareLogTable(careTimeline),
          pw.SizedBox(height: 22),
          _buildSectionTitle('Latest Symptom Check'),
          pw.SizedBox(height: 8),
          _buildSymptomCheckSection(latestCheck),
          pw.SizedBox(height: 26),
          _buildVetNotesSection(),
        ],
      ),
    );

    return doc.save();
  }

  pw.Widget _buildHeader(pw.MemoryImage logo) {
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
                'Pet Medical Report',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
          pw.Text(
            'Generated ${_dateFormat.format(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      padding: const pw.EdgeInsets.only(top: 6),
      child: pw.Text(
        'Page ${context.pageNumber} of ${context.pagesCount}',
        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
      ),
    );
  }

  pw.Widget _buildSectionTitle(String title) {
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

  pw.Widget _buildPetSummary(Pet pet) {
    final age = _formatAge(pet.birthdate);

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
            pet.breed.isEmpty
                ? _speciesLabel(pet.species)
                : '${_speciesLabel(pet.species)} · ${pet.breed}',
            style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            children: [
              _buildSummaryStat('Age', age),
              _buildSummaryStat(
                'Weight',
                '${pet.weightKg.toStringAsFixed(1)} kg',
              ),
              _buildSummaryStat(
                'Sex',
                '${pet.gender == PetGender.female ? 'Female' : 'Male'}'
                    '${pet.isNeutered ? ' (neutered)' : ''}',
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              _buildSummaryStat(
                'Microchip ID',
                pet.microchipId ?? 'None on file',
              ),
              _buildSummaryStat(
                'Known Allergies',
                pet.allergies ?? 'None on file',
              ),
              _buildSummaryStat(
                'Breed Risks',
                pet.breedDisorders.isEmpty
                    ? 'None on file'
                    : pet.breedDisorders.map(_humanize).join(', '),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSummaryStat(String label, String value) {
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

  pw.Widget _buildVaccinationTable(List<Vaccination> vaccinations) {
    if (vaccinations.isEmpty) {
      return _emptyNote('No vaccinations on file.');
    }

    return pw.TableHelper.fromTextArray(
      headers: ['Vaccine', 'Administered', 'Next Due'],
      data: [
        for (final v in vaccinations)
          [
            v.name,
            _dateFormat.format(v.dateAdministered),
            _dateFormat.format(v.nextDueDate),
          ],
      ],
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
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(1.2),
        2: const pw.FlexColumnWidth(1.2),
      },
    );
  }

  pw.Widget _buildCareLogTable(List<CareLog> careLogs) {
    if (careLogs.isEmpty) {
      return _emptyNote('No health care records on file.');
    }

    return pw.TableHelper.fromTextArray(
      headers: ['Date', 'Category', 'Title', 'Details'],
      data: [
        for (final log in careLogs)
          [
            _dateFormat.format(log.loggedAt),
            _capitalize(_humanize(log.category.value)),
            log.title,
            log.note == log.title ? '' : log.note,
          ],
      ],
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
        0: const pw.FlexColumnWidth(1.1),
        1: const pw.FlexColumnWidth(1.2),
        2: const pw.FlexColumnWidth(1.6),
        3: const pw.FlexColumnWidth(2.4),
      },
    );
  }

  String _speciesLabel(PetSpecies species) => switch (species) {
    PetSpecies.dog => 'Dog',
    PetSpecies.cat => 'Cat',
    PetSpecies.rabbit => 'Rabbit',
    PetSpecies.bird => 'Bird',
    PetSpecies.exotic => 'Exotic / Other',
  };

  pw.Widget _buildWeightChart(List<HealthLog> sortedWeightLogs) {
    if (sortedWeightLogs.length < 2) {
      return _emptyNote('Not enough weight entries yet for a trend chart.');
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
          // A plain hyphen-minus is used instead of an en-dash: the en-dash
          // glyph is missing from the bundled font fallback chain and was
          // rendering as zero-width, concatenating the two numbers with no
          // visible separator (e.g. "17.060.0 kg").
          'Range: ${minValue.toStringAsFixed(1)} - ${maxValue.toStringAsFixed(1)} kg '
          'over ${sortedWeightLogs.length} entries',
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

  pw.Widget _buildSymptomCheckSection(SymptomCheck? check) {
    if (check == null) {
      return _emptyNote('No symptom checks have been run for this pet yet.');
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
                _humanize(check.symptomId),
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Spacer(),
              pw.Text(
                check.triageLevel.name.toUpperCase(),
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
            'Checked ${_dateFormat.format(check.checkedAt)}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
          pw.SizedBox(height: 6),
          pw.Text(check.advice, style: const pw.TextStyle(fontSize: 10)),
          if (check.answers.isNotEmpty) ...[
            pw.SizedBox(height: 8),
            pw.Text(
              'Answers',
              style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
            ),
            for (final answer in check.answers)
              pw.Text(
                '• ${answer.questionText} ${answer.answer}',
                style: const pw.TextStyle(fontSize: 9),
              ),
          ],
        ],
      ),
    );
  }

  pw.Widget _buildVetNotesSection() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Vet Notes'),
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

  String _formatAge(DateTime birthdate) {
    final now = DateTime.now();
    var years = now.year - birthdate.year;
    var months = now.month - birthdate.month;
    if (now.day < birthdate.day) months -= 1;
    if (months < 0) {
      years -= 1;
      months += 12;
    }
    if (years <= 0) return '$months mo';
    return '$years yr $months mo';
  }

  String _humanize(String raw) => raw.replaceAll('_', ' ');

  String _capitalize(String text) =>
      text.isEmpty ? text : '${text[0].toUpperCase()}${text.substring(1)}';
}
