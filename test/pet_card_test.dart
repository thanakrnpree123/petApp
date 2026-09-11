import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/l10n/app_localizations.dart';
import 'package:pawhealth/models/pet.dart';
import 'package:pawhealth/screens/pets/pet_list_screen.dart';

void main() {
  // The default test font draws every glyph as a 1em square, which makes
  // Thai text several times wider than real. Measure with a real font.
  setUpAll(() async {
    final loader = FontLoader('NotoSansThai')
      ..addFont(rootBundle.load('assets/fonts/NotoSansThai-Regular.ttf'));
    await loader.load();
  });

  testWidgets('breed and age both fit a desktop grid card in Thai', (
    tester,
  ) async {
    final now = DateTime.now();
    final pet = Pet(
      id: 'p1',
      name: 'tao',
      species: PetSpecies.dog,
      breed: 'Labrador Retriever',
      breedDisorders: const [],
      birthdate: DateTime(now.year - 1, now.month, now.day),
      weightKg: 30,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(fontFamily: 'NotoSansThai'),
        locale: const Locale('th'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            // The desktop grid cell: up to 380 wide, ~110 tall.
            child: SizedBox(
              width: 360,
              height: 110,
              child: PetCard(
                pet: pet,
                onCheckSymptoms: (_) async {},
                onDelete: (_) async {},
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull, reason: 'no overflow');
    final age = find.text('1 ปี 0 เดือน');
    expect(age, findsOneWidget, reason: 'age is its own line, in full');
    expect(
      tester.renderObject<RenderParagraph>(age).didExceedMaxLines,
      isFalse,
      reason: 'regression: the age was cut off ("1 ปี 0 เ…")',
    );
    expect(find.text('Labrador Retriever'), findsOneWidget);
  });
}
