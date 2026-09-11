import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/l10n/app_localizations_en.dart';
import 'package:pawhealth/utils/validators.dart';
import 'package:pawhealth/widgets/auth/auth_text_field.dart';

void main() {
  final l10n = AppLocalizationsEn();
  final invalid = l10n.emailInvalid;

  Future<void> pumpFields(WidgetTester tester) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Form(
          child: Column(
            children: [
              AuthTextField(
                controller: TextEditingController(),
                label: 'Email',
                validator: (value) => Validators.email(value, l10n),
              ),
              AuthTextField(
                controller: TextEditingController(),
                label: 'Password',
                obscureText: true,
                validator: (value) => Validators.password(value, l10n),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  final email = find.widgetWithText(TextFormField, 'Email');
  final password = find.widgetWithText(TextFormField, 'Password');

  testWidgets('no error while the email is still being typed', (tester) async {
    await pumpFields(tester);

    await tester.enterText(email, 'thana@g');
    await tester.pump();

    expect(find.text(invalid), findsNothing);
  });

  testWidgets('leaving the field shows the error', (tester) async {
    await pumpFields(tester);

    await tester.enterText(email, 'thana@g');
    await tester.tap(password);
    await tester.pump();

    expect(find.text(invalid), findsOneWidget);
  });

  testWidgets('a shown error clears as soon as the input is fixed', (
    tester,
  ) async {
    await pumpFields(tester);
    await tester.enterText(email, 'thana@g');
    await tester.tap(password);
    await tester.pump();
    expect(find.text(invalid), findsOneWidget);

    await tester.enterText(email, 'thana@gmail.com');
    await tester.pump();

    expect(find.text(invalid), findsNothing);
  });
}
