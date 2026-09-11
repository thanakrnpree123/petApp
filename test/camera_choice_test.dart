import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/widgets/pets/webcam_device.dart';

CameraDescription _cam(String name, CameraLensDirection direction) =>
    CameraDescription(
      name: name,
      lensDirection: direction,
      sensorOrientation: 0,
    );

const _back = CameraLensDirection.back;
const _front = CameraLensDirection.front;
const _external = CameraLensDirection.external;

void main() {
  group('an iPhone Pro in Safari (many rear lenses listed first)', () {
    final cameras = [
      _cam('Back Dual Wide Camera', _back),
      _cam('Back Ultra Wide Camera', _back),
      _cam('Back Camera', _back),
      _cam('Back Telephoto Camera', _back),
      _cam('Back Triple Camera', _back),
      _cam('Front Camera', _front),
    ];

    test('opens the main rear camera', () {
      expect(cameras[CameraChoice.initial(cameras)].name, 'Back Camera');
    });

    test('one tap reaches the front camera, and one tap comes back', () {
      final start = CameraChoice.initial(cameras);
      final front = CameraChoice.next(cameras, start);
      expect(cameras[front].name, 'Front Camera');
      expect(cameras[CameraChoice.next(cameras, front)].name, 'Back Camera');
    });
  });

  test('Android Chrome: toggles between the main back and front lenses', () {
    final cameras = [
      _cam('camera2 0, facing back', _back),
      _cam('camera2 2, facing back', _back),
      _cam('camera2 3, facing back', _back),
      _cam('camera2 1, facing front', _front),
    ];
    final start = CameraChoice.initial(cameras);
    expect(start, 0);
    expect(CameraChoice.next(cameras, start), 3);
    expect(CameraChoice.next(cameras, 3), 0);
  });

  test('facing is read from the label when the browser gives none', () {
    final cameras = [
      _cam('camera2 1, facing front', _external),
      _cam('camera2 0, facing back', _external),
    ];
    expect(CameraChoice.initial(cameras), 1);
    expect(CameraChoice.next(cameras, 1), 0);
  });

  test('a laptop with two webcams cycles through them', () {
    final cameras = [
      _cam('FaceTime HD Camera', _external),
      _cam('Logitech BRIO', _external),
    ];
    expect(CameraChoice.initial(cameras), 0);
    expect(CameraChoice.next(cameras, 0), 1);
    expect(CameraChoice.next(cameras, 1), 0);
  });

  test('a device with only rear lenses still steps through them', () {
    final cameras = [
      _cam('Back Camera', _back),
      _cam('Back Ultra Wide Camera', _back),
    ];
    expect(CameraChoice.next(cameras, 0), 1);
  });
}
