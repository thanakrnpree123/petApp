import 'package:flutter/material.dart';

/// Email/password field for the auth forms.
///
/// Validates when the user leaves the field (and on submit), not on every
/// keystroke — "enter a valid email" appearing after "thana@g" scolds the
/// user for an address they haven't finished typing. Once an error is
/// showing, though, it re-checks as they type so it clears the moment the
/// input is fixed.
class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?) validator;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  final _fieldKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: _fieldKey,
      controller: widget.controller,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUnfocus,
      onChanged: (_) {
        final field = _fieldKey.currentState;
        if (field != null && field.hasError) field.validate();
      },
      decoration: InputDecoration(labelText: widget.label),
    );
  }
}
