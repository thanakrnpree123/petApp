import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/care_log.dart';
import '../../models/health_log.dart';
import '../../models/pet.dart';
import '../../models/vaccination.dart';
import '../../providers/health_timeline_provider.dart';
import '../../providers/pet_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../services/health_log_service.dart';
import '../../utils/l10n_helpers.dart';
import '../../services/notification_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/health/add_health_record_dialog.dart';
import '../../widgets/health/add_vaccine_dialog.dart';
import '../../widgets/health/add_weight_dialog.dart';
import '../../widgets/health/reminder_permission_prompt.dart';
import '../../widgets/health/weight_chart.dart';
import '../../widgets/responsive/breakpoints.dart';
import '../../widgets/subscription/upgrade_prompt_dialog.dart';
import 'pdf_preview_screen.dart';
import '../../utils/app_dates.dart';

class PetHealthDashboard extends StatefulWidget {
  final Pet pet;

  /// Overrides for tests; production uses the real service and the
  /// signed-in user.
  final HealthLogService? healthLogService;
  final String? userId;

  const PetHealthDashboard({
    super.key,
    required this.pet,
    this.healthLogService,
    this.userId,
  });

  @override
  State<PetHealthDashboard> createState() => _PetHealthDashboardState();
}

class _PetHealthDashboardState extends State<PetHealthDashboard> {
  late final HealthLogService _service =
      widget.healthLogService ?? HealthLogService();
  late final String _userId =
      widget.userId ?? FirebaseAuth.instance.currentUser!.uid;

  // Subscribed once for the screen's lifetime. Creating the streams inside
  // build() re-subscribed on every rebuild (e.g. each filter tap), and a
  // StreamBuilder handed a new stream resets to "no data" — so the
  // timeline flashed its empty state and re-read from Firestore each time.
  // Null means "still loading", which is distinct from "no records".
  final _subscriptions = <StreamSubscription<Object?>>[];
  List<CareLog>? _careLogs;
  List<Vaccination>? _vaccinations;
  List<HealthLog>? _healthLogs;

  @override
  void initState() {
    super.initState();
    final petId = widget.pet.id!;
    _subscriptions.addAll([
      _service
          .watchCareLogs(_userId, petId)
          .listen(
            (logs) => setState(() => _careLogs = logs),
            onError: (Object e) => _onStreamError(e, () => _careLogs = []),
          ),
      _service
          .watchVaccinations(_userId, petId)
          .listen(
            (vaccinations) => setState(() => _vaccinations = vaccinations),
            onError: (Object e) => _onStreamError(e, () => _vaccinations = []),
          ),
      _service
          .watchLogs(_userId, petId)
          .listen(
            (logs) => setState(() => _healthLogs = logs),
            onError: (Object e) => _onStreamError(e, () => _healthLogs = []),
          ),
    ]);
  }

  /// Stops the loading spinner rather than spinning forever.
  void _onStreamError(Object error, VoidCallback clear) {
    debugPrint('Health dashboard stream error: $error');
    if (mounted) setState(clear);
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  Future<void> _addRecord() async {
    final result = await AddHealthRecordDialog.show(context);
    if (result is! HealthRecordSaved) return;
    await _service.addCareLog(_userId, widget.pet.id!, result.log);
  }

  Future<void> _editRecord(CareLog log) async {
    final result = await AddHealthRecordDialog.show(context, existing: log);
    switch (result) {
      case HealthRecordSaved(:final log):
        await _service.updateCareLog(_userId, widget.pet.id!, log);
      case HealthRecordDeleted():
        await _service.deleteCareLog(_userId, widget.pet.id!, log.id!);
      case null:
        break;
    }
  }

  Future<void> _editVaccination(Vaccination vaccination) async {
    final result = await AddVaccineDialog.show(context, existing: vaccination);
    final reminderId = NotificationService.vaccineReminderId(vaccination.id!);
    switch (result) {
      case VaccineSaved(:final vaccination):
        await _service.updateVaccination(_userId, widget.pet.id!, vaccination);
        // Reschedule so the reminder follows the (possibly changed) due
        // date; cancel first in case the new date is already within a day.
        await NotificationService().cancelReminder(reminderId);
        await NotificationService().scheduleVaccineReminder(
          id: reminderId,
          petName: widget.pet.name,
          vaccineName: vaccination.name,
          nextDueDate: vaccination.nextDueDate,
        );
      case VaccineDeleted():
        await _service.deleteVaccination(
          _userId,
          widget.pet.id!,
          vaccination.id!,
        );
        await NotificationService().cancelReminder(reminderId);
      case null:
        break;
    }
  }

  Future<void> _addVaccine() async {
    final result = await AddVaccineDialog.show(context);
    if (result is! VaccineSaved) return;

    final vaccinationId = await _service.addVaccination(
      _userId,
      widget.pet.id!,
      result.vaccination,
    );

    // The moment a reminder becomes useful is the moment to ask for it.
    if (result.vaccination.nextDueDate.isAfter(DateTime.now()) && mounted) {
      await ReminderPermissionPrompt.maybeAsk(
        context,
        petName: widget.pet.name,
      );
    }

    await NotificationService().scheduleVaccineReminder(
      id: NotificationService.vaccineReminderId(vaccinationId),
      petName: widget.pet.name,
      vaccineName: result.vaccination.name,
      nextDueDate: result.vaccination.nextDueDate,
    );
  }

  Future<void> _addWeight() async {
    final weight = await AddWeightDialog.show(context);
    if (weight == null) return;

    await _service.addLog(
      _userId,
      widget.pet.id!,
      HealthLog(
        type: HealthLogType.weight,
        value: weight,
        loggedAt: DateTime.now(),
      ),
    );

    if (!mounted) return;
    await context.read<PetProvider>().savePet(
      userId: _userId,
      pet: widget.pet.copyWith(weightKg: weight),
    );
  }

  void _generateReport() {
    final isPlusMember = context.read<SubscriptionProvider>().isPlusMember;
    if (!isPlusMember) {
      UpgradePromptDialog.show(
        context,
        message: AppLocalizations.of(context)!.pdfPlusFeatureMessage,
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PdfPreviewScreen(pet: widget.pet)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isPlusMember = context.watch<SubscriptionProvider>().isPlusMember;
    final isDesktop = screenSizeOf(context).isDesktop;

    return ChangeNotifierProvider(
      create: (_) => HealthTimelineProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.healthDashboardTitle(widget.pet.name)),
              Text(
                '${L10nHelpers.species(l10n, widget.pet.species)} · '
                '${L10nHelpers.petAge(l10n, widget.pet)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    tooltip: isPlusMember
                        ? l10n.generateReport
                        : '${l10n.generateReport} (${l10n.pawHealthPlus})',
                    onPressed: _generateReport,
                  ),
                  if (!isPlusMember)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: IgnorePointer(
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: context.statusColors.premium,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lock,
                            size: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            // Unbounded on mobile/tablet so the phone layout is untouched;
            // capped on desktop so the two-column body doesn't stretch
            // across a full-width browser window.
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 1120 : double.infinity,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _addRecord,
                          icon: const Icon(Icons.add),
                          label: Text(l10n.healthRecordButton),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: _addVaccine,
                        icon: const Icon(Icons.vaccines_outlined),
                        label: Text(l10n.addVaccine),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _FilterChipsRow(showHeatCycle: widget.pet.tracksHeatCycle),
                  const SizedBox(height: AppSpacing.md - 4),
                  Expanded(
                    child: isDesktop
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Card(
                                  child: _UnifiedTimeline(
                                    careLogs: _careLogs,
                                    vaccinations: _vaccinations,
                                    onEditRecord: _editRecord,
                                    onEditVaccination: _editVaccination,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),
                              SizedBox(
                                width: 340,
                                child: SingleChildScrollView(
                                  child: _WeightSection(
                                    healthLogs: _healthLogs,
                                    onAddWeight: _addWeight,
                                  ),
                                ),
                              ),
                            ],
                          )
                        // Below desktop width: stacked — the timeline
                        // scrolls independently while the weight section
                        // stays pinned at the bottom.
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Card(
                                  child: _UnifiedTimeline(
                                    careLogs: _careLogs,
                                    vaccinations: _vaccinations,
                                    onEditRecord: _editRecord,
                                    onEditVaccination: _editVaccination,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md - 4),
                              _WeightSection(
                                healthLogs: _healthLogs,
                                onAddWeight: _addWeight,
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterChipsRow extends StatelessWidget {
  final bool showHeatCycle;

  const _FilterChipsRow({required this.showHeatCycle});

  String _label(AppLocalizations l10n, TimelineFilter filter) {
    return switch (filter) {
      TimelineFilter.all => l10n.filterAll,
      TimelineFilter.vaccination => l10n.filterVaccination,
      TimelineFilter.medical => l10n.filterMedical,
      TimelineFilter.grooming => l10n.filterGrooming,
      TimelineFilter.heatCycle => l10n.careHeatCycle,
      TimelineFilter.other => l10n.filterOther,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<HealthTimelineProvider>();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in TimelineFilter.values)
            if (filter != TimelineFilter.heatCycle || showHeatCycle)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(_label(l10n, filter)),
                  selected: provider.filter == filter,
                  onSelected: (_) =>
                      context.read<HealthTimelineProvider>().setFilter(filter),
                ),
              ),
        ],
      ),
    );
  }
}

/// One row in the unified timeline, built from either a care log or a
/// vaccination record.
class _TimelineEntry {
  final String title;
  final String subtitle;
  final DateTime date;
  final TimelineFilter kind;
  final IconData icon;
  final CareLog? careLog;
  final Vaccination? vaccination;

  const _TimelineEntry({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.kind,
    required this.icon,
    this.careLog,
    this.vaccination,
  });
}

class _UnifiedTimeline extends StatelessWidget {
  /// Null while still loading.
  final List<CareLog>? careLogs;
  final List<Vaccination>? vaccinations;
  final ValueChanged<CareLog> onEditRecord;
  final ValueChanged<Vaccination> onEditVaccination;

  const _UnifiedTimeline({
    required this.careLogs,
    required this.vaccinations,
    required this.onEditRecord,
    required this.onEditVaccination,
  });

  IconData _careIcon(CareCategory category) => switch (category) {
    CareCategory.parasiteControl => Icons.bug_report_outlined,
    CareCategory.heatCycle => Icons.favorite_outline,
    CareCategory.medicalSurgery => Icons.medical_information_outlined,
    CareCategory.grooming => Icons.content_cut,
    CareCategory.other => Icons.event_note_outlined,
  };

  List<_TimelineEntry> _buildEntries(
    AppLocalizations l10n,
    DateFormat dateFormat,
    List<CareLog> careLogs,
    List<Vaccination> vaccinations,
  ) {
    final entries = <_TimelineEntry>[
      for (final log in careLogs)
        _TimelineEntry(
          title: log.title,
          subtitle: log.note.isNotEmpty && log.note != log.title
              ? '${log.note} · ${dateFormat.format(log.loggedAt)}'
              : dateFormat.format(log.loggedAt),
          date: log.loggedAt,
          kind: filterForCareCategory(log.category),
          icon: _careIcon(log.category),
          careLog: log,
        ),
      for (final vaccination in vaccinations)
        _TimelineEntry(
          title: vaccination.name,
          subtitle: l10n.vaccinationDates(
            dateFormat.format(vaccination.dateAdministered),
            dateFormat.format(vaccination.nextDueDate),
          ),
          date: vaccination.dateAdministered,
          kind: TimelineFilter.vaccination,
          icon: Icons.vaccines_outlined,
          vaccination: vaccination,
        ),
    ]..sort((a, b) => b.date.compareTo(a.date));
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = AppDates.medium(context);
    final provider = context.watch<HealthTimelineProvider>();
    final careLogs = this.careLogs;
    final vaccinations = this.vaccinations;

    if (careLogs == null || vaccinations == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final entries = _buildEntries(
      l10n,
      dateFormat,
      careLogs,
      vaccinations,
    ).where((entry) => provider.matches(entry.kind)).toList();

    final colorScheme = Theme.of(context).colorScheme;

    if (entries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.event_note_outlined,
                size: 40,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.timelineEmpty,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      itemCount: entries.length,
      separatorBuilder: (_, _) => const Divider(indent: 72, endIndent: 16),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: CircleAvatar(
            radius: 22,
            backgroundColor: colorScheme.primaryContainer,
            child: Icon(
              entry.icon,
              size: 22,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          title: Text(
            entry.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            entry.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.chevron_right, size: 20),
          onTap: () {
            final careLog = entry.careLog;
            final vaccination = entry.vaccination;
            if (careLog != null) {
              onEditRecord(careLog);
            } else if (vaccination != null) {
              onEditVaccination(vaccination);
            }
          },
        );
      },
    );
  }
}

class _WeightSection extends StatelessWidget {
  /// Null while still loading.
  final List<HealthLog>? healthLogs;
  final VoidCallback onAddWeight;

  const _WeightSection({required this.healthLogs, required this.onAddWeight});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.weight,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton.filledTonal(
                  icon: const Icon(Icons.add),
                  tooltip: l10n.logWeight,
                  onPressed: onAddWeight,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 8),
              child: healthLogs == null
                  ? const SizedBox(
                      height: 160,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : WeightChart(
                      weightLogs: [
                        for (final log in healthLogs!)
                          if (log.type == HealthLogType.weight) log,
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
