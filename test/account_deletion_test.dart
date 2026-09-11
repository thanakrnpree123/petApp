import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/providers/auth_provider.dart';
import 'package:pawhealth/services/account_deletion_service.dart';
import 'package:pawhealth/services/auth_service.dart';
import 'package:pawhealth/services/notification_service.dart';
import 'package:pawhealth/services/pet_service.dart';
import 'package:pawhealth/services/storage_service.dart';

/// Every fake appends to one shared log so tests can assert global order.
class _Log {
  final calls = <String>[];
  String? failOn;

  void record(String call) {
    calls.add(call);
    if (call == failOn) {
      throw FirebaseException(plugin: 'test', code: 'unavailable');
    }
  }
}

class _FakeUser implements User {
  @override
  String get uid => 'u1';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeAuthService implements AuthService {
  _FakeAuthService(this.log, {this.wrongPassword = false});
  final _Log log;
  final bool wrongPassword;

  @override
  User? get currentUser => _FakeUser();

  @override
  Future<void> reauthenticate(String password) async {
    log.record('reauthenticate');
    if (wrongPassword) {
      throw FirebaseAuthException(code: 'wrong-password');
    }
  }

  @override
  Future<void> deleteProfile(String userId) async =>
      log.record('deleteProfile:$userId');

  @override
  Future<void> deleteCurrentUser() async => log.record('deleteCurrentUser');

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakePetService implements PetService {
  _FakePetService(this.log);
  final _Log log;

  @override
  Future<List<String>> petIds(String userId) async => ['p1', 'p2'];

  @override
  Future<void> deletePet(String userId, String petId) async =>
      log.record('deletePet:$petId');

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeStorageService implements StorageService {
  _FakeStorageService(this.log);
  final _Log log;

  @override
  Future<void> deleteFolder(String path) async =>
      log.record('deleteFolder:$path');

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeNotificationService implements NotificationService {
  _FakeNotificationService(this.log);
  final _Log log;

  @override
  Future<void> cancelAll() async => log.record('cancelAllReminders');

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

AccountDeletionService _service(_Log log, {bool wrongPassword = false}) =>
    AccountDeletionService(
      authService: _FakeAuthService(log, wrongPassword: wrongPassword),
      petService: _FakePetService(log),
      storageService: _FakeStorageService(log),
      notificationService: _FakeNotificationService(log),
    );

void main() {
  group('AccountDeletionService', () {
    test('deletes everything, with the login last', () async {
      final log = _Log();
      await _service(log).deleteAccount(password: 'secret');

      expect(log.calls, [
        'reauthenticate',
        'deletePet:p1',
        'deletePet:p2',
        'deleteFolder:users/u1',
        'cancelAllReminders',
        'deleteProfile:u1',
        'deleteCurrentUser',
      ]);
    });

    test('a wrong password deletes nothing', () async {
      final log = _Log();
      await expectLater(
        _service(log, wrongPassword: true).deleteAccount(password: 'typo'),
        throwsA(isA<FirebaseAuthException>()),
      );
      expect(log.calls, ['reauthenticate']);
    });

    for (final step in [
      'deletePet:p2',
      'deleteFolder:users/u1',
      'cancelAllReminders',
      'deleteProfile:u1',
    ]) {
      test(
        'a failure at $step keeps the login so the user can retry',
        () async {
          final log = _Log()..failOn = step;
          await expectLater(
            _service(log).deleteAccount(password: 'secret'),
            throwsA(isA<FirebaseException>()),
          );
          expect(log.calls.last, step);
          expect(log.calls, isNot(contains('deleteCurrentUser')));
        },
      );
    }
  });

  group('AuthProvider.deleteAccount', () {
    test('reports a wrong password as a localizable error code', () async {
      final log = _Log();
      final provider = AuthProvider(
        authService: _FakeAuthService(log),
        accountDeletionService: _service(log, wrongPassword: true),
      );

      expect(await provider.deleteAccount(password: 'typo'), isFalse);
      expect(provider.errorCode, 'wrong-password');
      expect(provider.isLoading, isFalse);
    });

    test('returns true once the account is deleted', () async {
      final log = _Log();
      final provider = AuthProvider(
        authService: _FakeAuthService(log),
        accountDeletionService: _service(log),
      );

      expect(await provider.deleteAccount(password: 'secret'), isTrue);
      expect(provider.errorCode, isNull);
    });
  });
}
