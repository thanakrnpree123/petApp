import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/care_log.dart';
import '../../utils/l10n_helpers.dart';
import '../common/confirm_delete_dialog.dart';
import '../../utils/app_dates.dart';

sealed class HealthRecordDialogResult {
  const HealthRecordDialogResult();
}

class HealthRecordSaved extends HealthRecordDialogResult {
  final CareLog log;
  const HealthRecordSaved(this.log);
}

class HealthRecordDeleted extends HealthRecordDialogResult {
  const HealthRecordDeleted();
}

/// Add or edit a health record: category, title, details, date, and an
/// optional next due date with a reminder — the "next appointment" line
/// every paper vet notebook keeps for deworming and tick/flea treatment.
///
/// In edit mode ([existing] != null) the fields are pre-filled and a red
/// Delete action (with confirmation) is shown.
class AddHealthRecordDialog extends StatefulWidget {
  final CareLog? existing;

  const AddHealthRecordDialog({super.key, this.existing});

  static Future<HealthRecordDialogResult?> show(
    BuildContext context, {
    CareLog? existing,
  }) {
    return showDialog<HealthRecordDialogResult>(
      context: context,
      builder: (_) => AddHealthRecordDialog(existing: existing),
    );
  }

  @override
  State<AddHealthRecordDialog> createState() => _AddHealthRecordDialogState();
}

class _AddHealthRecordDialogState extends State<AddHealthRecordDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _detailsController;
  late CareCategory _category;
  late DateTime _date;
  DateTime? _nextDueDate;
  late bool _reminderEnabled;

  bool get _isEditing => widget.existing != null;

  /// The legacy "Parasite Control" category is offered only to a record
  /// that already has it, so its own value can be displayed — picking
  /// anything else drops it from the list for good.
  List<CareCategory> get _categoryOptions => [
    ...CareCategory.selectable,
    if (_category.isLegacy) _category,
  ];

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _titleController = TextEditingController(text: existing?.title ?? '');
    _detailsController = TextEditingController(text: existing?.note ?? '');
    _category = existing?.category ?? CareCategory.other;
    _date = existing?.loggedAt ?? DateTime.now();
    _nextDueDate = existing?.nextDueDate;
    _reminderEnabled = existing?.reminderEnabled ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 30),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _pickNextDueDate() async {
    final now = DateTime.now();
    // The next appointment is always ahead of the record's own date, and
    // showDatePicker asserts that initialDate lies within [first, last].
    final firstDate = _date.isAfter(now) ? _date : now;
    final initialDate =
        (_nextDueDate != null && _nextDueDate!.isAfter(firstDate))
        ? _nextDueDate!
        : firstDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) {
      setState(() => _nextDueDate = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      HealthRecordSaved(
        CareLog(
          id: widget.existing?.id,
          category: _category,
          title: _titleController.text.trim(),
          note: _detailsController.text.trim(),
          loggedAt: _date,
          nextDueDate: _nextDueDate,
          reminderEnabled: _reminderEnabled,
        ),
      ),
    );
  }

  Future<void> _delete() async {
    final confirmed = await ConfirmDeleteDialog.show(context);
    if (confirmed && mounted) {
      Navigator.of(context).pop(const HealthRecordDeleted());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final nextDueDate = _nextDueDate;

    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: Text(
              _isEditing ? l10n.editHealthRecord : l10n.addHealthRecord,
            ),
          ),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Theme.of(context).colorScheme.error,
              tooltip: l10n.delete,
              onPressed: _delete,
            ),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<CareCategory>(
                initialValue: _category,
                decoration: InputDecoration(labelText: l10n.careCategoryLabel),
                items: [
                  for (final category in _categoryOptions)
                    DropdownMenuItem(
                      value: category,
                      child: Text(L10nHelpers.careCategory(l10n, category)),
                    ),
                ],
                onChanged: (category) {
                  if (category != null) setState(() => _category = category);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                autofocus: !_isEditing,
                decoration: InputDecoration(labelText: l10n.careTitle),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? l10n.titleRequired
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _detailsController,
                maxLines: 3,
                minLines: 1,
                decoration: InputDecoration(labelText: l10n.careDetails),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.event),
                label: Text(AppDates.medium(context).format(_date)),
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickNextDueDate,
                      icon: const Icon(Icons.event_repeat_outlined),
                      label: Text(
                        nextDueDate == null
                            ? l10n.careSelectNextDue
                            : l10n.nextDueOn(
                                AppDates.medium(context).format(nextDueDate),
                              ),
                        maxLines: 2,
                      ),
                    ),
                  ),
                  if (nextDueDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      tooltip: l10n.careClearNextDue,
                      onPressed: () => setState(() => _nextDueDate = null),
                    ),
                ],
              ),
              // Nothing to remind about until a next due date is set.
              if (nextDueDate != null)
                SwitchListTile(
                  value: _reminderEnabled,
                  onChanged: (value) =>
                      setState(() => _reminderEnabled = value),
                  title: Text(l10n.careRemindMe),
                  contentPadding: EdgeInsets.zero,
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(onPressed: _submit, child: Text(l10n.save)),
      ],
    );
  }
}
