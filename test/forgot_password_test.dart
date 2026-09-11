import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/l10n/app_localizations.dart';
import 'package:pawhealth/providers/auth_provider.dart';
import 'package:pawhealth/services/auth_service.dart';
import 'package:pawhealth/widgets/auth/forgot_password_dialog.dart';
import 'package:provider/provider.dart';

class _FakeAuthService implements AuthService {
  _FakeAuthService({this.errorCode});
  final String? errorCode;
  final sent = <(String, String)>[];

  @override
  Future<void> sendPasswordResetEmail({
    required String email,
    required String languageCode,
  }) async {
    sent.add((email, languageCode));
    if (errorCode != null) throw FirebaseAuthException(code: errorCode!);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> _pumpDialog(
  WidgetTester tester,
  _FakeAuthService auth, {
  String initialEmail = '',
  Locale locale = const Locale('en'),
}) async {
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(authService: auth),
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => ForgotPasswordDialog.show(
                context,
                initialEmail: initialEmail,
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('pre-fills the email and sends the reset in the app language', (
    tester,
  ) async {
    final auth = _FakeAuthService();
    await _pumpDialog(
      tester,
      auth,
      initialEmail: ' owner@example.com ',
      locale: const Locale('th'),
    );

    expect(find.text('owner@example.com'), findsOneWidget);
    await tester.tap(find.text('ส่งลิงก์ตั้งรหัสผ่าน'));
    await tester.pumpAndSettle();

    expect(auth.sent, [('owner@example.com', 'th')]);
    expect(find.textContaining('owner@example.com'), findsOneWidget);
    expect(find.byIcon(Icons.mark_email_read_outlined), findsOneWidget);
  });

  testWidgets('an unknown email gets the same confirmation', (tester) async {
    final auth = _FakeAuthService(errorCode: 'user-not-found');
    await _pumpDialog(tester, auth, initialEmail: 'nobody@example.com');

    await tester.tap(find.text('Send Reset Link'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.mark_email_read_outlined), findsOneWidget);
  });

  testWidgets('shows an error and stays open on a real failure', (
    tester,
  ) async {
    final auth = _FakeAuthService(errorCode: 'invalid-email');
    await _pumpDialog(tester, auth, initialEmail: 'owner@example.com');

    await tester.tap(find.text('Send Reset Link'));
    await tester.pumpAndSettle();

    expect(find.text('That email address looks invalid.'), findsOneWidget);
    expect(find.text('Send Reset Link'), findsOneWidget);
  });

  testWidgets('validates the email before sending anything', (tester) async {
    final auth = _FakeAuthService();
    await _pumpDialog(tester, auth);

    await tester.enterText(find.byType(TextFormField), 'not-an-email');
    await tester.tap(find.text('Send Reset Link'));
    await tester.pumpAndSettle();

    expect(auth.sent, isEmpty);
    expect(find.text('Enter a valid email address'), findsOneWidget);
  });

  test('reset errors never leak into the login form state', () async {
    final provider = AuthProvider(
      authService: _FakeAuthService(errorCode: 'invalid-email'),
    );

    final error = await provider.sendPasswordReset(
      email: 'x@example.com',
      languageCode: 'en',
    );

    expect(error, 'invalid-email');
    expect(provider.errorCode, isNull);
    expect(provider.isLoading, isFalse);
  });
}
