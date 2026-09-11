import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawhealth/l10n/app_localizations.dart';
import 'package:pawhealth/l10n/app_localizations_en.dart';
import 'package:pawhealth/theme/app_theme.dart';
import 'package:pawhealth/widgets/pets/photo_picker_field.dart';
import 'package:pawhealth/widgets/pets/webcam_capture_screen.dart';
import 'package:pawhealth/widgets/pets/webcam_device.dart';

final _l10n = AppLocalizationsEn();

// A valid 1×1 PNG, so Image.memory can actually decode the "capture".
final _photo = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=',
);

class _FakeWebcam implements WebcamDevice {
  _FakeWebcam({this.failure, this.cameras = 1, this.unexpected = false});
  final WebcamFailure? failure;
  final bool unexpected;
  final int cameras;
  int switches = 0;
  bool disposed = false;

  @override
  Future<void> start() async {
    if (unexpected) throw StateError('plugin blew up');
    if (failure != null) throw WebcamException(failure!);
  }

  @override
  Widget buildPreview() =>
      const SizedBox(key: Key('preview'), width: 320, height: 240);

  @override
  Future<Uint8List> capture() async => _photo;

  @override
  bool get canSwitchCamera => cameras > 1;

  @override
  Future<void> switchCamera() async => switches++;

  @override
  Future<void> dispose() async => disposed = true;
}

/// Opens the capture screen and returns a getter for what it resolved to.
Future<Future<Uint8List?> Function()> _openCapture(
  WidgetTester tester,
  List<_FakeWebcam> devices,
) async {
  Uint8List? result;
  var done = false;
  var next = 0;
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(extensions: const [StatusColors.light]),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () async {
            result = await WebcamCaptureScreen.open(
              context,
              deviceFactory: () => devices[next++],
            );
            done = true;
          },
          child: const Text('open'),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return () async {
    expect(done, isTrue, reason: 'capture screen still open');
    return result;
  };
}

void main() {
  testWidgets('take, review and use a photo', (tester) async {
    final device = _FakeWebcam();
    final result = await _openCapture(tester, [device]);

    expect(find.byKey(const Key('preview')), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, _l10n.takePhoto));
    await tester.pumpAndSettle();

    expect(find.byType(Image), findsOneWidget);
    await tester.tap(find.text(_l10n.usePhoto));
    await tester.pumpAndSettle();

    expect(await result(), _photo);
    expect(device.disposed, isTrue, reason: 'webcam must be released');
  });

  testWidgets('retake returns to the live preview', (tester) async {
    await _openCapture(tester, [_FakeWebcam()]);

    await tester.tap(find.widgetWithText(FilledButton, _l10n.takePhoto));
    await tester.pumpAndSettle();
    await tester.tap(find.text(_l10n.retake));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('preview')), findsOneWidget);
  });

  testWidgets('Space takes the photo on a laptop', (tester) async {
    await _openCapture(tester, [_FakeWebcam()]);

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();

    expect(find.text(_l10n.usePhoto), findsOneWidget);
  });

  testWidgets('switch camera only appears with more than one camera', (
    tester,
  ) async {
    final device = _FakeWebcam(cameras: 2);
    await _openCapture(tester, [device]);

    await tester.tap(find.byTooltip(_l10n.switchCamera));
    await tester.pumpAndSettle();
    expect(device.switches, 1);
    expect(find.byKey(const Key('preview')), findsOneWidget);
  });

  for (final (failure, message) in [
    (WebcamFailure.permissionDenied, _l10n.cameraPermissionDenied),
    (WebcamFailure.notFound, _l10n.cameraNotFound),
    (WebcamFailure.inUse, _l10n.cameraInUse),
    (WebcamFailure.unknown, _l10n.cameraStartFailed),
  ]) {
    testWidgets('explains ${failure.name} and can try again', (tester) async {
      await _openCapture(tester, [
        _FakeWebcam(failure: failure),
        _FakeWebcam(),
      ]);

      expect(find.text(message), findsOneWidget);
      expect(find.byKey(const Key('preview')), findsNothing);

      await tester.tap(find.text(_l10n.tryAgain));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('preview')), findsOneWidget);
    });
  }

  group('PhotoPickerField on the web', () {
    Future<void> pumpField(
      WidgetTester tester, {
      required List<Uint8List> picked,
      required List<String> calls,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: PhotoPickerField(
              onPicked: picked.add,
              isWeb: true,
              webcamCapture: (_) async {
                calls.add('webcam');
                return _photo;
              },
              pickImage: (source) async {
                calls.add('picker:${source.name}');
                return null;
              },
            ),
          ),
        ),
      );
      await tester.tap(find.byType(PhotoPickerField));
      await tester.pumpAndSettle();
    }

    testWidgets('Take Photo opens the webcam, not a file chooser', (
      tester,
    ) async {
      final picked = <Uint8List>[];
      final calls = <String>[];
      await pumpField(tester, picked: picked, calls: calls);

      await tester.tap(find.text(_l10n.takePhoto));
      await tester.pumpAndSettle();

      expect(calls, ['webcam']);
      expect(picked, [_photo]);
    });

    testWidgets('Choose from Library still uses the file picker', (
      tester,
    ) async {
      final calls = <String>[];
      await pumpField(tester, picked: [], calls: calls);

      await tester.tap(find.text(_l10n.chooseFromLibrary));
      await tester.pumpAndSettle();

      expect(calls, ['picker:${ImageSource.gallery.name}']);
    });
  });

  testWidgets('an unexpected error still ends in a message, not a spinner', (
    tester,
  ) async {
    final device = _FakeWebcam(unexpected: true);
    await _openCapture(tester, [device]);

    expect(find.text(_l10n.cameraStartFailed), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(device.disposed, isTrue);
  });

  test('browser and plugin error codes map to the right message', () {
    const cases = {
      'CameraAccessDenied': WebcamFailure.permissionDenied,
      'NotAllowedError': WebcamFailure.permissionDenied,
      'cameraNotFound': WebcamFailure.notFound,
      'NotFoundError': WebcamFailure.notFound,
      'cameraNotReadable': WebcamFailure.inUse,
      'NotReadableError': WebcamFailure.inUse,
      'somethingElse': WebcamFailure.unknown,
    };
    for (final MapEntry(key: code, value: failure) in cases.entries) {
      expect(PluginWebcamDevice.failureFor(code), failure, reason: code);
    }
  });
}
