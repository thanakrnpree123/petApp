import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/models/health_log.dart';
import 'package:pawhealth/models/pet.dart';
import 'package:pawhealth/providers/pet_provider.dart';
import 'package:pawhealth/services/health_log_service.dart';
import 'package:pawhealth/services/notification_service.dart';
import 'package:pawhealth/services/pet_service.dart';
import 'package:pawhealth/services/storage_service.dart';

class _FakePetService implements PetService {
  Pet? updated;

  @override
  Future<void> updatePet(String userId, Pet pet) async => updated = pet;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHealthLogs implements HealthLogService {
  final logged = <HealthLog>[];

  @override
  Future<void> addLog(String userId, String petId, HealthLog log) async =>
      logged.add(log);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Unused implements StorageService, NotificationService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Pet _pet(double kg) => Pet(
  id: 'p1',
  name: 'Mochi',
  species: PetSpecies.dog,
  breed: 'Shiba Inu',
  breedDisorders: const [],
  birthdate: DateTime(2022),
  weightKg: kg,
);

void main() {
  late _FakeHealthLogs logs;
  late PetProvider provider;

  setUp(() {
    logs = _FakeHealthLogs();
    provider = PetProvider(
      petService: _FakePetService(),
      storageService: _Unused(),
      notificationService: _Unused(),
      healthLogService: logs,
    )..pets = [_pet(9.5)];
  });

  test('a weight changed in the edit form is recorded for the chart', () async {
    expect(await provider.savePet(userId: 'u1', pet: _pet(10.2)), isTrue);

    expect(logs.logged, hasLength(1));
    expect(logs.logged.single.type, HealthLogType.weight);
    expect(logs.logged.single.value, 10.2);
  });

  test('saving without a weight change records nothing', () async {
    await provider.savePet(userId: 'u1', pet: _pet(9.5));
    expect(logs.logged, isEmpty);
  });

  test('a caller that already logged the weigh-in can opt out', () async {
    // The dashboard's "Log weight" writes the entry itself.
    await provider.savePet(
      userId: 'u1',
      pet: _pet(10.2),
      logWeightChange: false,
    );
    expect(logs.logged, isEmpty);
  });

  test('petById returns the latest known version', () {
    expect(provider.petById('p1')?.weightKg, 9.5);
    expect(provider.petById('missing'), isNull);
  });
}
