import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../utils/l10n_helpers.dart';
import '../../utils/validators.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/common/paw_loader.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final auth = context.read<AuthProvider>();
    final success = await PawLoaderOverlay.during(
      context,
      auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
      message: l10n.creatingAccount,
    );

    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.register)),
      // Same responsive form pattern as the login screen: centered and
      // non-scrollable while content fits, scrolls only as far as the
      // keyboard requires.
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AuthTextField(
                        controller: _emailController,
                        label: l10n.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => Validators.email(value, l10n),
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        controller: _passwordController,
                        label: l10n.password,
                        obscureText: true,
                        validator: (value) => Validators.password(value, l10n),
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        controller: _confirmPasswordController,
                        label: l10n.confirmPassword,
                        obscureText: true,
                        validator: (value) => Validators.confirmPassword(
                          value,
                          _passwordController.text,
                          l10n,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (auth.errorCode != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            L10nHelpers.authError(l10n, auth.errorCode!),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      FilledButton(
                        onPressed: auth.isLoading ? null : _submit,
                        child: Text(l10n.createAccount),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
