import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/l10n/app_localizations.dart';
import 'package:pawhealth/models/care_log.dart';
import 'package:pawhealth/models/health_log.dart';
import 'package:pawhealth/models/pet.dart';
import 'package:pawhealth/models/vaccination.dart';
import 'package:pawhealth/providers/subscription_provider.dart';
import 'package:pawhealth/screens/health/pet_health_dashboard.dart';
import 'package:pawhealth/services/health_log_service.dart';
import 'package:pawhealth/services/revenuecat_service.dart';
import 'package:pawhealth/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class _FakeHealthLogService implements HealthLogService {
  final careLogs = StreamController<List<CareLog>>();
  final vaccinations = StreamController<List<Vaccination>>();
  final healthLogs = StreamController<List<HealthLog>>();
  final watchCalls = <String, int>{};

  void _count(String name) => watchCalls[name] = (watchCalls[name] ?? 0) + 1;

  @override
  Stream<List<CareLog>> watchCareLogs(String userId, String petId) {
    _count('careLogs');
    return careLogs.stream;
  }

  @override
  Stream<List<Vaccination>> watchVaccinations(String userId, String petId) {
    _count('vaccinations');
    return vaccinations.stream;
  }

  @override
  Stream<List<HealthLog>> watchLogs(String userId, String petId) {
    _count('healthLogs');
    return healthLogs.stream;
  }

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

final _pet = Pet(
  id: 'p1',
  name: 'Mochi',
  species: PetSpecies.dog,
  breed: 'Shiba Inu',
  breedDisorders: const [],
  birthdate: DateTime(2022, 1, 1),
  weightKg: 9,
);

Future<void> _pumpDashboard(
  WidgetTester tester,
  _FakeHealthLogService service,
) async {
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => SubscriptionProvider(
        service: _FakeRevenueCat(),
        firestore: _FakeFirestore(),
      ),
      child: MaterialApp(
        theme: ThemeData(extensions: const [StatusColors.light]),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: PetHealthDashboard(
          pet: _pet,
          healthLogService: service,
          userId: 'u1',
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('shows a spinner, not the empty state, while loading', (
    tester,
  ) async {
    final service = _FakeHealthLogService();
    await _pumpDashboard(tester, service);

    expect(find.byType(CircularProgressIndicator), findsWidgets);
    expect(find.text('No health records yet.'), findsNothing);
  });

  testWidgets('filter taps never flash the empty state or re-subscribe', (
    tester,
  ) async {
    final service = _FakeHealthLogService();
    await _pumpDashboard(tester, service);

    service.careLogs.add([
      CareLog(
        id: 'c1',
        category: CareCategory.medicalSurgery,
        title: 'Spay surgery',
        loggedAt: DateTime(2026, 8, 1),
      ),
    ]);
    service.vaccinations.add([
      Vaccination(
        id: 'v1',
        name: 'Rabies',
        dateAdministered: DateTime(2026, 7, 1),
        nextDueDate: DateTime(2027, 7, 1),
      ),
    ]);
    service.healthLogs.add([]);
    await tester.pump();

    expect(find.text('Spay surgery'), findsOneWidget);
    expect(find.text('Rabies'), findsOneWidget);

    // A single frame after each tap — the old StreamBuilder reset showed
    // "No health records yet." in exactly this frame.
    await tester.tap(find.text('Vaccination'));
    await tester.pump();
    expect(find.text('Rabies'), findsOneWidget);
    expect(find.text('Spay surgery'), findsNothing);
    expect(find.text('No health records yet.'), findsNothing);

    await tester.tap(find.text('All'));
    await tester.pump();
    expect(find.text('Spay surgery'), findsOneWidget);
    expect(find.text('Rabies'), findsOneWidget);

    expect(service.watchCalls, {
      'careLogs': 1,
      'vaccinations': 1,
      'healthLogs': 1,
    });
  });

  testWidgets('a stream error ends the spinner instead of spinning forever', (
    tester,
  ) async {
    final service = _FakeHealthLogService();
    await _pumpDashboard(tester, service);

    service.careLogs.addError(Exception('permission-denied'));
    service.vaccinations.add([]);
    service.healthLogs.add([]);
    await tester.pump();

    expect(find.text('No health records yet.'), findsOneWidget);
  });
}
