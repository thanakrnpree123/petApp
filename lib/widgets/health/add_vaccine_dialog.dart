import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../models/vaccination.dart';
import '../common/confirm_delete_dialog.dart';

sealed class VaccineDialogResult {
  const VaccineDialogResult();
}

class VaccineSaved extends VaccineDialogResult {
  final Vaccination vaccination;
  const VaccineSaved(this.vaccination);
}

class VaccineDeleted extends VaccineDialogResult {
  const VaccineDeleted();
}

/// Add or edit a vaccination. In edit mode ([existing] != null) the fields
/// are pre-filled and a trash icon (with confirmation) is shown in the
/// title row.
class AddVaccineDialog extends StatefulWidget {
  final Vaccination? existing;

  const AddVaccineDialog({super.key, this.existing});

  static Future<VaccineDialogResult?> show(
    BuildContext context, {
    Vaccination? existing,
  }) {
    return showDialog<VaccineDialogResult>(
      context: context,
      builder: (_) => AddVaccineDialog(existing: existing),
    );
  }

  @override
  State<AddVaccineDialog> createState() => _AddVaccineDialogState();
}

class _AddVaccineDialogState extends State<AddVaccineDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late DateTime _administeredAt;
  DateTime? _nextDueAt;
  String? _dueDateError;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    _administeredAt = widget.existing?.dateAdministered ?? DateTime.now();
    _nextDueAt = widget.existing?.nextDueDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isAdministeredDate}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isAdministeredDate ? _administeredAt : (_nextDueAt ?? now),
      firstDate: DateTime(now.year - 20),
      lastDate: DateTime(now.year + 20),
    );
    if (picked == null) return;
    setState(() {
      if (isAdministeredDate) {
        _administeredAt = picked;
      } else {
        _nextDueAt = picked;
        _dueDateError = null;
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_nextDueAt == null) {
      setState(
        () => _dueDateError = AppLocalizations.of(
          context,
        )!.selectNextDueDateError,
      );
      return;
    }
    Navigator.of(context).pop(
      VaccineSaved(
        Vaccination(
          id: widget.existing?.id,
          name: _nameController.text.trim(),
          dateAdministered: _administeredAt,
          nextDueDate: _nextDueAt!,
        ),
      ),
    );
  }

  Future<void> _delete() async {
    final confirmed = await ConfirmDeleteDialog.show(context);
    if (confirmed && mounted) {
      Navigator.of(context).pop(const VaccineDeleted());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat.yMMMd();

    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: Text(_isEditing ? l10n.editVaccination : l10n.addVaccine),
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
                controller: _nameController,
                autofocus: !_isEditing,
                decoration: InputDecoration(labelText: l10n.vaccineName),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? l10n.nameRequired
                    : null,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => _pickDate(isAdministeredDate: true),
                icon: const Icon(Icons.event_available),
                label: Text(
                  l10n.administeredOn(dateFormat.format(_administeredAt)),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _pickDate(isAdministeredDate: false),
                icon: const Icon(Icons.event_repeat),
                label: Text(
                  _nextDueAt == null
                      ? l10n.selectNextDueDate
                      : l10n.nextDueOn(dateFormat.format(_nextDueAt!)),
                ),
              ),
              if (_dueDateError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _dueDateError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
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
