import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pawhealth/l10n/app_localizations_en.dart';
import 'package:pawhealth/utils/validators.dart';
import 'package:pawhealth/widgets/auth/auth_text_field.dart';

void main() {
  final l10n = AppLocalizationsEn();

  testWidgets('AuthTextField shows validation error for invalid email', (
    WidgetTester tester,
  ) async {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController(text: 'not-an-email');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: AuthTextField(
              controller: controller,
              label: 'Email',
              validator: (value) => Validators.email(value, l10n),
            ),
          ),
        ),
      ),
    );

    formKey.currentState!.validate();
    await tester.pump();

    expect(find.text('Enter a valid email address'), findsOneWidget);
  });

  test('validators localize messages through AppLocalizations', () {
    expect(Validators.email(null, l10n), l10n.emailRequired);
    expect(Validators.email('nope', l10n), l10n.emailInvalid);
    expect(Validators.password('123', l10n), l10n.passwordTooShort);
    expect(
      Validators.confirmPassword('a', 'b', l10n),
      l10n.passwordsDoNotMatch,
    );
    expect(Validators.confirmPassword('same', 'same', l10n), isNull);
  });
}
