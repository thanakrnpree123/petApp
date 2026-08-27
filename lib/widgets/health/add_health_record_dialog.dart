import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../models/care_log.dart';
import '../common/confirm_delete_dialog.dart';

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

/// Add or edit a health record: title, details, date. No category
/// selection — new records default to [CareCategory.other]; edited records
/// keep their stored category.
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
  late DateTime _date;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.existing?.title ?? '',
    );
    _detailsController = TextEditingController(
      text: widget.existing?.note ?? '',
    );
    _date = widget.existing?.loggedAt ?? DateTime.now();
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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      HealthRecordSaved(
        CareLog(
          id: widget.existing?.id,
          category: widget.existing?.category ?? CareCategory.other,
          title: _titleController.text.trim(),
          note: _detailsController.text.trim(),
          loggedAt: _date,
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
                label: Text(DateFormat.yMMMd().format(_date)),
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
