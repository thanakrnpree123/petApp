import '../l10n/app_localizations.dart';
import '../models/care_log.dart';
import '../models/vaccination.dart';
import '../utils/app_dates.dart';
import '../utils/l10n_helpers.dart';

/// The contents of one vet-report table: header row, data rows, and the
/// relative width of each column.
class ReportTable {
  final List<String> headers;
  final List<List<String>> rows;
  final Map<int, double> flexWidths;

  const ReportTable({
    required this.headers,
    required this.rows,
    required this.flexWidths,
  });
}

class _Column<T> {
  final String header;
  final double flex;
  final String Function(T) cell;

  const _Column(this.header, this.flex, this.cell);
}

/// Builds the report's tables. Columns that no record fills in are left
/// out entirely, so a report from someone who never records a lot number
/// stays as narrow as it was before those fields existed — and one from a
/// clinic that records everything carries it all.
///
/// Separated from PDF rendering so the column logic can be tested without
/// rasterizing a document.
abstract final class ReportTables {
  /// The vet as one cell: "Name (licence)", or whichever half exists.
  static String vetLabel(String? name, String? licenseNo) {
    if (name != null && licenseNo != null) return '$name ($licenseNo)';
    return name ?? licenseNo ?? '';
  }

  static ReportTable _build<T>(List<_Column<T>> columns, List<T> items) {
    return ReportTable(
      headers: [for (final column in columns) column.header],
      rows: [
        for (final item in items) [for (final c in columns) c.cell(item)],
      ],
      flexWidths: {
        for (final (index, column) in columns.indexed) index: column.flex,
      },
    );
  }

  static ReportTable vaccinations(
    AppLocalizations l10n,
    AppDateFormat date,
    List<Vaccination> vaccinations,
  ) {
    final hasLot = vaccinations.any((v) => v.lotNo != null);
    final hasVet = vaccinations.any(
      (v) => v.veterinarianName != null || v.vetLicenseNo != null,
    );

    return _build<Vaccination>(<_Column<Vaccination>>[
      _Column(l10n.pdfVaccine, 2, (v) => v.name),
      _Column(
        l10n.pdfAdministered,
        1.2,
        (v) => date.format(v.dateAdministered),
      ),
      _Column(l10n.pdfNextDue, 1.2, (v) => date.format(v.nextDueDate)),
      if (hasLot) _Column(l10n.pdfLotNo, 1.2, (v) => v.lotNo ?? ''),
      if (hasVet)
        _Column(
          l10n.pdfVeterinarian,
          1.8,
          (v) => vetLabel(v.veterinarianName, v.vetLicenseNo),
        ),
    ], vaccinations);
  }

  static ReportTable careLogs(
    AppLocalizations l10n,
    AppDateFormat date,
    List<CareLog> careLogs,
  ) {
    final hasMedicine = careLogs.any((log) => log.medicine != null);
    final hasNextDue = careLogs.any((log) => log.nextDueDate != null);
    final hasVet = careLogs.any(
      (log) => log.veterinarianName != null || log.vetLicenseNo != null,
    );

    return _build<CareLog>(<_Column<CareLog>>[
      _Column(l10n.pdfDate, 1.1, (log) => date.format(log.loggedAt)),
      _Column(
        l10n.pdfCategory,
        1.2,
        (log) => L10nHelpers.careCategory(l10n, log.category),
      ),
      _Column(l10n.pdfEntry, 1.6, (log) => log.title),
      if (hasMedicine)
        _Column(l10n.pdfMedicine, 1.6, (log) => log.medicine ?? ''),
      if (hasNextDue)
        _Column(
          l10n.pdfNextDue,
          1.2,
          (log) => log.nextDueDate == null ? '' : date.format(log.nextDueDate!),
        ),
      if (hasVet)
        _Column(
          l10n.pdfVeterinarian,
          1.8,
          (log) => vetLabel(log.veterinarianName, log.vetLicenseNo),
        ),
      // Details last: it's the widest and the least structured.
      _Column(
        l10n.pdfDetails,
        2.4,
        (log) => log.note == log.title ? '' : log.note,
      ),
    ], careLogs);
  }
}
