import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  bool isLoading = false;

  /// Raw error code (FirebaseAuth code, 'permission-denied', or 'unknown').
  /// The UI localizes it via L10nHelpers.authError — providers have no
  /// BuildContext, so they must never hold display strings.
  String? errorCode;

  AuthProvider({AuthService? authService})
    : _authService = authService ?? AuthService();

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  Future<bool> signIn({required String email, required String password}) {
    return _runAuthAction(
      () => _authService.signIn(email: email, password: password),
    );
  }

  Future<bool> signUp({required String email, required String password}) {
    return _runAuthAction(
      () => _authService.signUp(email: email, password: password),
    );
  }

  Future<void> signOut() => _authService.signOut();

  Future<bool> _runAuthAction(Future<void> Function() action) async {
    isLoading = true;
    errorCode = null;
    notifyListeners();

    try {
      await action();
      return true;
    } on FirebaseAuthException catch (e) {
      errorCode = e.code;
      return false;
    } on FirebaseException catch (e) {
      // Non-auth Firebase failures (e.g. Firestore permission-denied when
      // writing the user profile doc) must also reset the loading state.
      errorCode = e.code == 'permission-denied'
          ? 'permission-denied'
          : 'unknown';
      return false;
    } catch (_) {
      errorCode = 'unknown';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
