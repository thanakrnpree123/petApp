import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'webcam_registration.dart';

/// Why the webcam couldn't start — each gets its own message.
enum WebcamFailure { permissionDenied, notFound, inUse, unknown }

class WebcamException implements Exception {
  final WebcamFailure failure;
  const WebcamException(this.failure);

  @override
  String toString() => 'WebcamException($failure)';
}

/// The live camera behind [WebcamCaptureScreen], kept behind an interface
/// so the screen's states can be tested without real hardware.
abstract class WebcamDevice {
  /// Opens the camera. Throws [WebcamException].
  Future<void> start();

  Widget buildPreview();

  /// Captures a still frame as JPEG bytes.
  Future<Uint8List> capture();

  bool get canSwitchCamera;

  /// Front ⇄ back on a phone; the next webcam otherwise ([CameraChoice]).
  Future<void> switchCamera();

  Future<void> dispose();
}

/// [WebcamDevice] backed by `camera_web` (getUserMedia), used through the
/// camera platform interface directly.
///
/// Deliberately not the full `camera` plugin: that would also merge its
/// Android implementation into the phone build — adding CAMERA and
/// RECORD_AUDIO permissions (and a CAMERA permission that's declared but
/// not granted makes Android block image_picker's system camera intent).
/// Phones use image_picker's native camera; only the web needs this.
class PluginWebcamDevice implements WebcamDevice {
  CameraPlatform get _platform => CameraPlatform.instance;

  List<CameraDescription> _cameras = const [];
  int _index = 0;
  int? _cameraId;
  double _aspectRatio = 4 / 3;

  @override
  Future<void> start() async {
    ensureWebcamPluginRegistered();
    try {
      // On web this is also the permission prompt: it opens a stream to
      // request access before listing devices.
      _cameras = await _platform.availableCameras();
    } on CameraException catch (e) {
      throw WebcamException(failureFor(e.code));
    } on PlatformException catch (e) {
      throw WebcamException(failureFor(e.code));
    }
    if (_cameras.isEmpty) {
      throw const WebcamException(WebcamFailure.notFound);
    }
    _index = CameraChoice.initial(_cameras);
    await _open(_cameras[_index]);
  }

  Future<void> _open(CameraDescription camera) async {
    await _close();
    int? cameraId;
    try {
      cameraId = await _platform.createCameraWithSettings(
        camera,
        const MediaSettings(
          resolutionPreset: ResolutionPreset.high,
          enableAudio: false,
        ),
      );
      // Subscribe before initializing so the event can't be missed.
      final initialized = _platform.onCameraInitialized(cameraId).first;
      await _platform.initializeCamera(cameraId);
      final event = await initialized;
      if (event.previewWidth > 0 && event.previewHeight > 0) {
        _aspectRatio = event.previewWidth / event.previewHeight;
      }
      _cameraId = cameraId;
    } on CameraException catch (e) {
      if (cameraId != null) await _platform.dispose(cameraId);
      throw WebcamException(failureFor(e.code));
    } on PlatformException catch (e) {
      // camera_web reports create/initialize failures this way.
      if (cameraId != null) await _platform.dispose(cameraId);
      throw WebcamException(failureFor(e.code));
    }
  }

  Future<void> _close() async {
    final cameraId = _cameraId;
    _cameraId = null;
    // Releases the stream, which turns off the webcam light.
    if (cameraId != null) await _platform.dispose(cameraId);
  }

  /// camera_web reports failures either with its own codes or with the
  /// browser's DOMException names, depending on the call.
  @visibleForTesting
  static WebcamFailure failureFor(String code) => switch (code) {
    'CameraAccessDenied' ||
    'CameraAccessDeniedWithoutPrompt' ||
    'CameraAccessRestricted' ||
    'cameraSecurity' ||
    'NotAllowedError' ||
    'SecurityError' => WebcamFailure.permissionDenied,
    'cameraNotFound' ||
    'cameraNotSupported' ||
    'cameraOverconstrained' ||
    'NotFoundError' ||
    'OverconstrainedError' => WebcamFailure.notFound,
    // NotReadableError: usually another app (a video call) holds the camera.
    'cameraNotReadable' || 'NotReadableError' => WebcamFailure.inUse,
    _ => WebcamFailure.unknown,
  };

  @override
  Widget buildPreview() => AspectRatio(
    aspectRatio: _aspectRatio,
    child: _platform.buildPreview(_cameraId!),
  );

  @override
  Future<Uint8List> capture() async {
    final file = await _platform.takePicture(_cameraId!);
    return file.readAsBytes();
  }

  @override
  bool get canSwitchCamera => _cameras.length > 1;

  @override
  Future<void> switchCamera() async {
    if (!canSwitchCamera) return;
    _index = CameraChoice.next(_cameras, _index);
    await _open(_cameras[_index]);
  }

  @override
  Future<void> dispose() => _close();
}

/// Which camera to open first, and which one "switch camera" goes to.
///
/// A phone browser lists every lens as its own camera — an iPhone Pro
/// reports Back, Back Ultra Wide, Back Telephoto, Back Dual, Back Triple
/// and Front — so stepping through the list meant several taps through
/// near-identical rear lenses before reaching the selfie camera. On a
/// phone the switch is a front ⇄ back toggle between the main lenses;
/// cameras with no known facing (a laptop's webcams) are cycled in order.
@visibleForTesting
abstract final class CameraChoice {
  static final _specialLens = RegExp(
    r'ultra|tele|wide|dual|triple|macro|depth|infrared',
    caseSensitive: false,
  );

  /// Facing direction, falling back to the label when the browser didn't
  /// report one ("camera2 1, facing front", "Back Camera").
  static CameraLensDirection directionOf(CameraDescription camera) {
    if (camera.lensDirection != CameraLensDirection.external) {
      return camera.lensDirection;
    }
    final name = camera.name.toLowerCase();
    if (name.contains('front')) return CameraLensDirection.front;
    if (name.contains('back') || name.contains('rear')) {
      return CameraLensDirection.back;
    }
    return CameraLensDirection.external;
  }

  /// Index of the main camera facing [direction], or -1 if there is none.
  static int primary(
    List<CameraDescription> cameras,
    CameraLensDirection direction,
  ) {
    final facing = [
      for (var i = 0; i < cameras.length; i++)
        if (directionOf(cameras[i]) == direction) i,
    ];
    if (facing.isEmpty) return -1;
    return facing.firstWhere(
      (i) => !_specialLens.hasMatch(cameras[i].name),
      orElse: () => facing.first,
    );
  }

  /// The main rear camera (a phone), else the first camera (a laptop).
  static int initial(List<CameraDescription> cameras) {
    final back = primary(cameras, CameraLensDirection.back);
    return back >= 0 ? back : 0;
  }

  static int next(List<CameraDescription> cameras, int current) {
    final direction = directionOf(cameras[current]);
    if (direction == CameraLensDirection.back ||
        direction == CameraLensDirection.front) {
      final other = primary(
        cameras,
        direction == CameraLensDirection.back
            ? CameraLensDirection.front
            : CameraLensDirection.back,
      );
      if (other >= 0) return other;
    }
    return (current + 1) % cameras.length;
  }
}
