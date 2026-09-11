import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/models/pet.dart';
import 'package:pawhealth/models/vaccination.dart';
import 'package:pawhealth/providers/pet_provider.dart';
import 'package:pawhealth/providers/session.dart';
import 'package:pawhealth/providers/subscription_provider.dart';
import 'package:pawhealth/services/health_log_service.dart';
import 'package:pawhealth/services/notification_service.dart';
import 'package:pawhealth/services/pet_service.dart';
import 'package:pawhealth/services/reminder_sync_service.dart';
import 'package:pawhealth/services/revenuecat_service.dart';
import 'package:pawhealth/services/storage_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

Pet _pet(String id, String name) => Pet(
  id: id,
  name: name,
  species: PetSpecies.dog,
  breed: '',
  breedDisorders: const [],
  birthdate: DateTime(2022),
  weightKg: 10,
);

class _FakePetService implements PetService {
  final streams = <String, StreamController<List<Pet>>>{};
  bool failFetch = false;

  @override
  Stream<List<Pet>> watchPets(String userId) =>
      (streams[userId] = StreamController<List<Pet>>()).stream;

  @override
  Future<List<Pet>> fetchPets(String userId) async {
    if (failFetch) {
      throw FirebaseException(plugin: 'cloud_firestore', code: 'unavailable');
    }
    return [_pet('p1', 'Mochi'), _pet('p2', 'Taro')];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHealthLogService implements HealthLogService {
  @override
  Future<List<Vaccination>> fetchVaccinations(
    String userId,
    String petId,
  ) async => [
    Vaccination(
      id: 'vax-$petId',
      name: 'Rabies',
      dateAdministered: DateTime(2026, 1, 1),
      nextDueDate: DateTime(2027, 1, 1),
    ),
  ];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeNotifications implements NotificationService {
  final calls = <String>[];

  @override
  Future<void> cancelAll() async => calls.add('cancelAll');

  @override
  Future<void> scheduleVaccineReminder({
    required int id,
    required String petName,
    required String vaccineName,
    required DateTime nextDueDate,
  }) async => calls.add('schedule:$petName:$id');

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeRevenueCat implements RevenueCatService {
  @override
  void addCustomerInfoListener(CustomerInfoUpdateListener listener) {}

  @override
  void removeCustomerInfoListener(CustomerInfoUpdateListener listener) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeFirestore implements FirebaseFirestore {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _NoopStorage implements StorageService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _FakePetService petService;
  late PetProvider pets;

  setUp(() {
    petService = _FakePetService();
    pets = PetProvider(
      petService: petService,
      storageService: _NoopStorage(),
      notificationService: _FakeNotifications(),
    );
  });

  test('switching users never shows the previous user\'s pets', () async {
    pets.startWatching('alice');
    petService.streams['alice']!.add([_pet('p1', 'Mochi')]);
    await pumpEventQueue();
    expect(pets.pets, hasLength(1));

    pets.startWatching('bob');
    // Before bob's first snapshot arrives.
    expect(pets.pets, isEmpty);
    expect(petService.streams['alice']!.hasListener, isFalse);
  });

  test(
    'endUserSession stops listening, resets Plus and clears reminders',
    () async {
      final notifications = _FakeNotifications();
      final subscription = SubscriptionProvider(
        service: _FakeRevenueCat(),
        firestore: _FakeFirestore(),
      )..isPlusMember = true;
      pets.startWatching('alice');
      petService.streams['alice']!.add([_pet('p1', 'Mochi')]);
      await pumpEventQueue();

      await endUserSession(
        pets: pets,
        subscription: subscription,
        notifications: notifications,
      );

      expect(pets.pets, isEmpty);
      expect(petService.streams['alice']!.hasListener, isFalse);
      expect(subscription.isPlusMember, isFalse);
      expect(notifications.calls, ['cancelAll']);
    },
  );

  group('ReminderSyncService', () {
    test('rebuilds every pet\'s reminders from the account', () async {
      final notifications = _FakeNotifications();
      await ReminderSyncService(
        petService: petService,
        healthLogService: _FakeHealthLogService(),
        notificationService: notifications,
      ).resync('alice');

      expect(notifications.calls, [
        'cancelAll',
        'schedule:Mochi:${NotificationService.vaccineReminderId('vax-p1')}',
        'schedule:Taro:${NotificationService.vaccineReminderId('vax-p2')}',
      ]);
    });

    test('keeps existing reminders when the account can\'t be read', () async {
      final notifications = _FakeNotifications();
      petService.failFetch = true;

      await expectLater(
        ReminderSyncService(
          petService: petService,
          healthLogService: _FakeHealthLogService(),
          notificationService: notifications,
        ).resync('alice'),
        throwsA(isA<FirebaseException>()),
      );
      expect(notifications.calls, isEmpty);
    });
  });
}
