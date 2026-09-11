import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/l10n/app_localizations.dart';
import 'package:pawhealth/providers/auth_provider.dart';
import 'package:pawhealth/screens/auth/login_screen.dart';
import 'package:pawhealth/services/auth_service.dart';
import 'package:provider/provider.dart';

class _FailingAuthService implements AuthService {
  @override
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async => throw FirebaseAuthException(code: 'wrong-password');

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  const loginError = 'Incorrect email or password.';

  testWidgets('a failed login is not shown on the register screen', (
    tester,
  ) async {
    final auth = AuthProvider(authService: _FailingAuthService());
    await auth.signIn(email: 'owner@example.com', password: 'wrong1');
    expect(auth.errorCode, 'wrong-password');

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: auth,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const LoginScreen(),
        ),
      ),
    );
    expect(find.text(loginError), findsOneWidget);

    await tester.tap(find.text("Don't have an account? Register"));
    await tester.pumpAndSettle();

    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text(loginError), findsNothing);
  });

  test('clearError only notifies when there was an error', () {
    final auth = AuthProvider(authService: _FailingAuthService());
    var notifications = 0;
    auth.addListener(() => notifications++);

    auth.clearError();
    expect(notifications, 0);

    auth.errorCode = 'wrong-password';
    auth.clearError();
    expect(auth.errorCode, isNull);
    expect(notifications, 1);
  });
}
