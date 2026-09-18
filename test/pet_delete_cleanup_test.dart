import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/providers/pet_provider.dart';
import 'package:pawhealth/services/notification_service.dart';
import 'package:pawhealth/services/pet_service.dart';
import 'package:pawhealth/services/storage_service.dart';

class _FakePetService implements PetService {
  bool failDelete = false;
  final deleted = <String>[];

  @override
  Future<List<String>> vaccinationIds(String userId, String petId) async => [
    'vaxA',
    'vaxB',
  ];

  @override
  Future<List<String>> careLogIds(String userId, String petId) async => [
    'careA',
  ];

  @override
  Future<void> deletePet(String userId, String petId) async {
    if (failDelete) {
      throw FirebaseException(plugin: 'cloud_firestore', code: 'unavailable');
    }
    deleted.add(petId);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeStorageService implements StorageService {
  bool failDelete = false;
  final deletedFolders = <String>[];

  @override
  Future<void> deleteFolder(String path) async {
    if (failDelete) {
      throw FirebaseException(plugin: 'firebase_storage', code: 'unknown');
    }
    deletedFolders.add(path);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeNotificationService implements NotificationService {
  final cancelled = <int>[];

  @override
  Future<void> cancelReminder(int id) async => cancelled.add(id);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _FakePetService pets;
  late _FakeStorageService storage;
  late _FakeNotificationService notifications;
  late PetProvider provider;

  setUp(() {
    pets = _FakePetService();
    storage = _FakeStorageService();
    notifications = _FakeNotificationService();
    provider = PetProvider(
      petService: pets,
      storageService: storage,
      notificationService: notifications,
    );
  });

  group('PetProvider.deletePet', () {
    test('cancels every reminder and deletes the photo', () async {
      expect(await provider.deletePet('u1', 'p1'), isTrue);

      expect(pets.deleted, ['p1']);
      expect(notifications.cancelled, [
        NotificationService.vaccineReminderId('vaxA'),
        NotificationService.vaccineReminderId('vaxB'),
        // A care record's next appointment must stop alerting too.
        NotificationService.careReminderId('careA'),
      ]);
      expect(storage.deletedFolders, ['users/u1/pets/p1']);
    });

    test('a failed delete leaves reminders and photo untouched', () async {
      pets.failDelete = true;

      expect(await provider.deletePet('u1', 'p1'), isFalse);
      expect(notifications.cancelled, isEmpty);
      expect(storage.deletedFolders, isEmpty);
    });

    test('a failed photo cleanup still reports the delete as done', () async {
      storage.failDelete = true;

      expect(await provider.deletePet('u1', 'p1'), isTrue);
      expect(notifications.cancelled, hasLength(3));
      expect(provider.errorCode, isNull);
    });
  });

  group('NotificationService.vaccineReminderId', () {
    test('is stable — pinned values must never change', () {
      // If these change, reminders scheduled by an older build can no
      // longer be cancelled.
      expect(NotificationService.vaccineReminderId('abc'), 96354);
      expect(
        NotificationService.vaccineReminderId('x3Kf9LmQpR2sT7vW8yZ0'),
        778057098,
      );
    });

    test('fits a 32-bit signed notification id', () {
      final id = NotificationService.vaccineReminderId('z' * 500);
      expect(id, inInclusiveRange(0, 2147483646));
    });
  });
}
