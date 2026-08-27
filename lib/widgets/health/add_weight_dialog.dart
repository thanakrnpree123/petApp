import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class AddWeightDialog extends StatefulWidget {
  const AddWeightDialog({super.key});

  static Future<double?> show(BuildContext context) {
    return showDialog<double>(
      context: context,
      builder: (_) => const AddWeightDialog(),
    );
  }

  @override
  State<AddWeightDialog> createState() => _AddWeightDialogState();
}

class _AddWeightDialogState extends State<AddWeightDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(double.parse(_controller.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.logWeight),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: l10n.weightKg),
          validator: (value) {
            final parsed = double.tryParse(value?.trim() ?? '');
            if (parsed == null || parsed <= 0) return l10n.enterValidWeight;
            return null;
          },
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
