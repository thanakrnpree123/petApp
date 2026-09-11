import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/l10n/app_localizations.dart';
import 'package:pawhealth/providers/pet_provider.dart';
import 'package:pawhealth/screens/pets/pet_form_screen.dart';
import 'package:pawhealth/services/notification_service.dart';
import 'package:pawhealth/services/pet_service.dart';
import 'package:pawhealth/services/storage_service.dart';
import 'package:pawhealth/widgets/pets/breed_dropdown.dart';
import 'package:provider/provider.dart';

class _Unused implements PetService, StorageService, NotificationService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('the breed list opens below the field, not over its label', (
    tester,
  ) async {
    // Phone-sized: the breed field starts in the lower part of the screen,
    // where the list used to flip upward and cover the field's label.
    tester.view.physicalSize = const Size(400, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

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
          home: const PetFormScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final field = find.byType(BreedDropdown);
    expect(tester.getRect(field).bottom, greaterThan(640 - 336));

    await tester.tap(
      find.descendant(of: field, matching: find.byType(TextField)),
    );
    await tester.pumpAndSettle();

    final firstBreed = find.text('Labrador Retriever').last;
    expect(firstBreed, findsOneWidget);
    expect(
      tester.getRect(firstBreed).top,
      greaterThanOrEqualTo(tester.getRect(field).bottom - 1),
      reason: 'list must open below the field',
    );
  });
}
