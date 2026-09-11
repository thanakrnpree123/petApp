import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/l10n/app_localizations.dart';
import 'package:pawhealth/l10n/app_localizations_en.dart';
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

Finder _fieldWithError(String error) => find.byWidgetPredicate(
  (w) => w is InputDecorator && w.decoration.errorText == error,
);

Future<void> _openFormAndSave(WidgetTester tester) async {
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

  await tester.enterText(
    find.widgetWithText(TextFormField, _l10n.petName),
    'Mochi',
  );
  // Below the fold at the test's 800x600 size; ListView builds lazily.
  final weight = find.widgetWithText(TextFormField, _l10n.weightKg);
  await tester.scrollUntilVisible(
    weight,
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.enterText(weight, '9.5');
  // Dismiss the keyboard, as a user would: a focused field keeps pulling
  // itself back into view, which would fight the scroll to Save.
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();
  final save = find.widgetWithText(FilledButton, _l10n.addPet);
  await tester.ensureVisible(save);
  await tester.tap(save);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('missing breed and birthdate are flagged on their own fields', (
    tester,
  ) async {
    await _openFormAndSave(tester);

    // Regression: these used to appear once, at the bottom by the Save
    // button, far from the fields they were about.
    expect(_fieldWithError(_l10n.selectBreedError), findsOneWidget);
    expect(_fieldWithError(_l10n.selectBirthdateError), findsOneWidget);
    expect(find.text(_l10n.selectBirthdateError), findsOneWidget);
  });

  testWidgets('picking a birthdate clears its error right away', (
    tester,
  ) async {
    await _openFormAndSave(tester);

    final birthdate = _fieldWithError(_l10n.selectBirthdateError);
    await tester.ensureVisible(birthdate);
    await tester.tap(birthdate);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Regression: the stale error stayed until the next Save.
    expect(find.text(_l10n.selectBirthdateError), findsNothing);
  });

  testWidgets('the first field error is scrolled into view', (tester) async {
    // A short phone screen: after scrolling down to Save, the breed field
    // sits above the fold, so its error is only seen if the form scrolls.
    tester.view.physicalSize = const Size(400, 340);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await _openFormAndSave(tester);

    final breedError = find.text(_l10n.selectBreedError);
    expect(breedError, findsOneWidget);
    final rect = tester.getRect(breedError);
    final screen = tester.getRect(find.byType(Scaffold));
    expect(screen.contains(rect.center), isTrue);
  });
}
