import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _firestore.collection('users').doc(credential.user!.uid).set({
      'email': email,
      'display_name': null,
      'subscription_tier': 'free',
      'symptom_checks_used_this_month': 0,
      'symptom_checks_reset_at': Timestamp.now(),
      'locale': 'en',
      'created_at': FieldValue.serverTimestamp(),
    });

    return credential;
  }

  Future<void> signOut() {
    return _auth.signOut();
  }

  /// Firebase only allows sensitive operations (like deleting the user)
  /// shortly after a sign-in, so account deletion re-confirms the password
  /// first. Throws FirebaseAuthException ('wrong-password' /
  /// 'invalid-credential') on a bad password.
  Future<void> reauthenticate(String password) async {
    final user = _auth.currentUser!;
    await user.reauthenticateWithCredential(
      EmailAuthProvider.credential(email: user.email!, password: password),
    );
  }

  Future<void> deleteProfile(String userId) {
    return _firestore.collection('users').doc(userId).delete();
  }

  /// Deletes the Firebase Auth user — this also signs them out.
  Future<void> deleteCurrentUser() => _auth.currentUser!.delete();
}
