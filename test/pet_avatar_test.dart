import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/widgets/pets/pet_avatar.dart';

// A valid 1×1 PNG.
final _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=',
);

Future<void> _pump(WidgetTester tester, PetAvatar avatar) => tester.pumpWidget(
  MaterialApp(
    home: Scaffold(body: Center(child: avatar)),
  ),
);

const _paw = Icon(Icons.pets, key: Key('placeholder'));

void main() {
  testWidgets('shows the placeholder when there is no photo', (tester) async {
    await _pump(tester, const PetAvatar(radius: 30, placeholder: _paw));

    expect(find.byKey(const Key('placeholder')), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    expect(tester.getSize(find.byType(PetAvatar)), const Size(60, 60));
  });

  testWidgets('a just-picked photo wins over the stored URL', (tester) async {
    await _pump(
      tester,
      PetAvatar(
        radius: 30,
        placeholder: _paw,
        photoBytes: _png,
        photoUrl: 'https://example.com/old.jpg',
      ),
    );

    final image = tester.widget<Image>(find.byType(Image));
    expect(image.image, isA<MemoryImage>());
  });

  testWidgets('a stored photo loads with the <img> fallback for CORS', (
    tester,
  ) async {
    await _pump(
      tester,
      const PetAvatar(
        radius: 30,
        placeholder: _paw,
        photoUrl: 'https://example.com/pet.jpg',
      ),
    );

    final image = tester.widget<Image>(find.byType(Image));
    expect(
      (image.image as NetworkImage).webHtmlElementStrategy,
      WebHtmlElementStrategy.fallback,
    );
  });

  testWidgets('a photo that fails to load falls back to the placeholder', (
    tester,
  ) async {
    // Network requests fail in widget tests — like a blocked CORS fetch.
    await _pump(
      tester,
      const PetAvatar(
        radius: 30,
        placeholder: _paw,
        photoUrl: 'https://example.com/pet.jpg',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('placeholder')), findsOneWidget);
  });
}
