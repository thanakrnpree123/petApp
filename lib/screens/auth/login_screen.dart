import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../utils/l10n_helpers.dart';
import '../../utils/validators.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/forgot_password_dialog.dart';
import '../../widgets/common/paw_loader.dart';
import '../../widgets/responsive/breakpoints.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final auth = context.read<AuthProvider>();
    await PawLoaderOverlay.during(
      context,
      auth.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
      message: l10n.loggingIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();
    final isDesktop = screenSizeOf(context).isDesktop;

    // Standard responsive form pattern: content is centered and
    // non-scrollable while it fits; when the keyboard shrinks the
    // viewport, the ConstrainedBox/IntrinsicHeight pair lets it scroll
    // exactly as far as needed to avoid overflow — no further.
    final form = LayoutBuilder(
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
                    Center(
                      child: Image.asset(
                        'assets/images/splash_logo.png',
                        height: 96,
                        width: 96,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.appTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    // Desktop shows the tagline in the brand panel instead.
                    if (!isDesktop) ...[
                      const SizedBox(height: 8),
                      Text(
                        l10n.loginBrandTagline,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 40),
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
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        onPressed: () => ForgotPasswordDialog.show(
                          context,
                          initialEmail: _emailController.text,
                        ),
                        child: Text(l10n.forgotPassword),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (auth.errorCode != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          L10nHelpers.authError(l10n, auth.errorCode!),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    FilledButton(
                      onPressed: auth.isLoading ? null : _submit,
                      child: Text(l10n.logIn),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () async {
                        // Don't carry a failed login onto the register
                        // form — or a failed sign-up back to this one.
                        auth.clearError();
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                        if (context.mounted) {
                          context.read<AuthProvider>().clearError();
                        }
                      },
                      child: Text(l10n.noAccountRegister),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Below desktop width the form fills the screen exactly as before.
    // At desktop width it's capped to a fixed column and, when there's a
    // brand panel beside it, centered within the remaining space instead
    // of stretching edge to edge.
    final formColumn = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: form,
    );

    return Scaffold(
      body: isDesktop
          ? Row(
              children: [
                const Expanded(flex: 5, child: _LoginBrandPanel()),
                Expanded(flex: 4, child: Center(child: formColumn)),
              ],
            )
          : SafeArea(child: form),
    );
  }
}

/// Marketing panel shown beside the login form on wide screens. Purely
/// decorative — no state, no navigation — so it costs nothing on mobile
/// where it's never built.
class _LoginBrandPanel extends StatelessWidget {
  const _LoginBrandPanel();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.primary,
      padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/splash_logo.png',
                height: 36,
                width: 36,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              Text(
                l10n.appTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
              ),
            ],
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Text(
              l10n.loginBrandTagline,
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(color: colorScheme.onPrimary),
            ),
          ),
          const SizedBox.shrink(),
        ],
      ),
    );
  }
}
