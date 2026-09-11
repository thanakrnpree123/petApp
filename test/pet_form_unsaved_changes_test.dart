import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/l10n/app_localizations.dart';
import 'package:pawhealth/l10n/app_localizations_en.dart';
import 'package:pawhealth/models/pet.dart';
import 'package:pawhealth/providers/pet_provider.dart';
import 'package:pawhealth/screens/pets/pet_form_screen.dart';
import 'package:pawhealth/services/notification_service.dart';
import 'package:pawhealth/services/pet_service.dart';
import 'package:pawhealth/services/storage_service.dart';
import 'package:provider/provider.dart';

class _Unused implements PetService, StorageService, NotificationService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final _l10n = AppLocalizationsEn();

Future<void> _openForm(WidgetTester tester, {Pet? existingPet}) async {
  final unused = _Unused();
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => PetProvider(
        petService: unused,
        storageService: unused,
        notificationService: unused,
      ),
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PetFormScreen(existingPet: existingPet),
                ),
              ),
              child: const Text('home'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('home'));
  await tester.pumpAndSettle();
  expect(find.byType(PetFormScreen), findsOneWidget);
}

/// Simulates the system/AppBar back action (Navigator.maybePop).
Future<void> _goBack(WidgetTester tester) async {
  await tester.binding.handlePopRoute();
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('an untouched form closes without asking', (tester) async {
    await _openForm(tester);
    await _goBack(tester);

    expect(find.byType(PetFormScreen), findsNothing);
    expect(find.text(_l10n.discardChangesTitle), findsNothing);
  });

  testWidgets('edits ask before being discarded', (tester) async {
    await _openForm(tester);
    await tester.enterText(
      find.widgetWithText(TextFormField, _l10n.petName),
      'Mochi',
    );
    await tester.pump();

    await _goBack(tester);
    expect(find.text(_l10n.discardChangesTitle), findsOneWidget);

    await tester.tap(find.text(_l10n.keepEditing));
    await tester.pumpAndSettle();
    expect(find.byType(PetFormScreen), findsOneWidget);
    expect(find.text('Mochi'), findsOneWidget);

    await _goBack(tester);
    await tester.tap(find.text(_l10n.discard));
    await tester.pumpAndSettle();
    expect(find.byType(PetFormScreen), findsNothing);
  });

  testWidgets('undoing an edit makes the form clean again', (tester) async {
    await _openForm(tester);
    final name = find.widgetWithText(TextFormField, _l10n.petName);
    await tester.enterText(name, 'Mochi');
    await tester.pump();
    await tester.enterText(name, '');
    await tester.pump();

    await _goBack(tester);
    expect(find.byType(PetFormScreen), findsNothing);
  });

  testWidgets('opening an existing pet with a custom breed is not an edit', (
    tester,
  ) async {
    // Not in the curated list: the form switches the dropdown to "Other"
    // and fills the text field itself, after an async breed lookup.
    await _openForm(
      tester,
      existingPet: Pet(
        id: 'p1',
        name: 'Biscuit',
        species: PetSpecies.dog,
        breed: 'Village dog',
        breedDisorders: const [],
        birthdate: DateTime(2021, 5, 1),
        weightKg: 12,
      ),
    );
    expect(find.text('Village dog'), findsOneWidget);

    await _goBack(tester);
    expect(find.text(_l10n.discardChangesTitle), findsNothing);
    expect(find.byType(PetFormScreen), findsNothing);
  });
}
