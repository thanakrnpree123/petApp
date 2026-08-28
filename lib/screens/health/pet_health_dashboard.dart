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
import '../../widgets/health/add_health_record_dialog.dart';
import '../../widgets/health/add_vaccine_dialog.dart';
import '../../widgets/health/add_weight_dialog.dart';
import '../../widgets/health/weight_chart.dart';
import '../../widgets/responsive/breakpoints.dart';
import '../../widgets/subscription/upgrade_prompt_dialog.dart';
import 'pdf_preview_screen.dart';

class PetHealthDashboard extends StatefulWidget {
  final Pet pet;

  const PetHealthDashboard({super.key, required this.pet});

  @override
  State<PetHealthDashboard> createState() => _PetHealthDashboardState();
}

class _PetHealthDashboardState extends State<PetHealthDashboard> {
  final _service = HealthLogService();
  late final String _userId;

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser!.uid;
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
    final reminderId = vaccination.id!.hashCode;
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

    await NotificationService().scheduleVaccineReminder(
      id: vaccinationId.hashCode,
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
                          decoration: const BoxDecoration(
                            color: Colors.amber,
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
                  const SizedBox(height: 12),
                  _FilterChipsRow(showHeatCycle: widget.pet.tracksHeatCycle),
                  const SizedBox(height: 8),
                  Expanded(
                    child: isDesktop
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _UnifiedTimeline(
                                  service: _service,
                                  userId: _userId,
                                  pet: widget.pet,
                                  onEditRecord: _editRecord,
                                  onEditVaccination: _editVaccination,
                                ),
                              ),
                              const SizedBox(width: 24),
                              SizedBox(
                                width: 320,
                                child: SingleChildScrollView(
                                  child: _WeightSection(
                                    service: _service,
                                    userId: _userId,
                                    pet: widget.pet,
                                    onAddWeight: _addWeight,
                                  ),
                                ),
                              ),
                            ],
                          )
                        // Below desktop width: today's stacked layout,
                        // unchanged — timeline scrolls independently while
                        // the weight section stays pinned at the bottom.
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _UnifiedTimeline(
                                  service: _service,
                                  userId: _userId,
                                  pet: widget.pet,
                                  onEditRecord: _editRecord,
                                  onEditVaccination: _editVaccination,
                                ),
                              ),
                              const Divider(height: 24),
                              _WeightSection(
                                service: _service,
                                userId: _userId,
                                pet: widget.pet,
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
    final colorScheme = Theme.of(context).colorScheme;

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
                  selectedColor: colorScheme.primary,
                  labelStyle: TextStyle(
                    color: provider.filter == filter
                        ? colorScheme.onPrimary
                        : null,
                  ),
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
  final HealthLogService service;
  final String userId;
  final Pet pet;
  final ValueChanged<CareLog> onEditRecord;
  final ValueChanged<Vaccination> onEditVaccination;

  const _UnifiedTimeline({
    required this.service,
    required this.userId,
    required this.pet,
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
    final dateFormat = DateFormat.yMMMd();
    final provider = context.watch<HealthTimelineProvider>();

    return StreamBuilder<List<CareLog>>(
      stream: service.watchCareLogs(userId, pet.id!),
      builder: (context, careSnapshot) {
        return StreamBuilder<List<Vaccination>>(
          stream: service.watchVaccinations(userId, pet.id!),
          builder: (context, vaccinationSnapshot) {
            final entries = _buildEntries(
              l10n,
              dateFormat,
              careSnapshot.data ?? [],
              vaccinationSnapshot.data ?? [],
            ).where((entry) => provider.matches(entry.kind)).toList();

            if (entries.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    l10n.timelineEmpty,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.secondaryContainer,
                    child: Icon(
                      entry.icon,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
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
          },
        );
      },
    );
  }
}

class _WeightSection extends StatelessWidget {
  final HealthLogService service;
  final String userId;
  final Pet pet;
  final VoidCallback onAddWeight;

  const _WeightSection({
    required this.service,
    required this.userId,
    required this.pet,
    required this.onAddWeight,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.weight, style: Theme.of(context).textTheme.titleLarge),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              tooltip: l10n.logWeight,
              onPressed: onAddWeight,
            ),
          ],
        ),
        StreamBuilder<List<HealthLog>>(
          stream: service.watchLogs(userId, pet.id!),
          builder: (context, snapshot) {
            final logs = snapshot.data ?? [];
            final weightLogs = logs
                .where((l) => l.type == HealthLogType.weight)
                .toList();
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: WeightChart(weightLogs: weightLogs),
            );
          },
        ),
      ],
    );
  }
}
