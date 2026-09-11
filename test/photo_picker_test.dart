import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawhealth/l10n/app_localizations.dart';
import 'package:pawhealth/l10n/app_localizations_en.dart';
import 'package:pawhealth/widgets/pets/photo_picker_field.dart';

final _l10n = AppLocalizationsEn();
final _bytes = Uint8List.fromList([1, 2, 3]);

Future<List<Uint8List>> _pump(
  WidgetTester tester, {
  required bool cameraAvailable,
  required ImageBytesPicker pickImage,
}) async {
  final picked = <Uint8List>[];
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: PhotoPickerField(
          onPicked: picked.add,
          cameraAvailable: cameraAvailable,
          pickImage: pickImage,
        ),
      ),
    ),
  );
  return picked;
}

void main() {
  testWidgets('offers camera or library when a camera exists', (tester) async {
    ImageSource? requested;
    final picked = await _pump(
      tester,
      cameraAvailable: true,
      pickImage: (source) async {
        requested = source;
        return _bytes;
      },
    );

    await tester.tap(find.byType(PhotoPickerField));
    await tester.pumpAndSettle();
    expect(find.text(_l10n.takePhoto), findsOneWidget);
    expect(find.text(_l10n.chooseFromLibrary), findsOneWidget);

    await tester.tap(find.text(_l10n.takePhoto));
    await tester.pumpAndSettle();

    expect(requested, ImageSource.camera);
    expect(picked, [_bytes]);
  });

  testWidgets('goes straight to the library without a camera', (tester) async {
    ImageSource? requested;
    await _pump(
      tester,
      cameraAvailable: false,
      pickImage: (source) async {
        requested = source;
        return null; // user cancelled
      },
    );

    await tester.tap(find.byType(PhotoPickerField));
    await tester.pumpAndSettle();

    expect(find.text(_l10n.takePhoto), findsNothing);
    expect(requested, ImageSource.gallery);
  });

  testWidgets('explains a denied permission instead of doing nothing', (
    tester,
  ) async {
    final picked = await _pump(
      tester,
      cameraAvailable: false,
      pickImage: (_) async =>
          throw PlatformException(code: 'photo_access_denied'),
    );

    await tester.tap(find.byType(PhotoPickerField));
    await tester.pumpAndSettle();

    expect(find.text(_l10n.photoAccessDenied), findsOneWidget);
    expect(picked, isEmpty);
  });

  testWidgets('reports other pick failures', (tester) async {
    await _pump(
      tester,
      cameraAvailable: false,
      pickImage: (_) async => throw PlatformException(code: 'invalid_image'),
    );

    await tester.tap(find.byType(PhotoPickerField));
    await tester.pumpAndSettle();

    expect(find.text(_l10n.photoPickFailed), findsOneWidget);
  });

  testWidgets('is labelled for screen readers', (tester) async {
    final handle = tester.ensureSemantics();
    await _pump(tester, cameraAvailable: false, pickImage: (_) async => null);

    expect(find.bySemanticsLabel(_l10n.addPetPhoto), findsOneWidget);
    handle.dispose();
  });
}
