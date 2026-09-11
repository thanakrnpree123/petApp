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

  /// Cycles to the next camera (e.g. an external webcam).
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
    // Prefer the rear camera (phones in a browser), else the first one —
    // a laptop's built-in webcam.
    final back = _cameras.indexWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
    );
    _index = back >= 0 ? back : 0;
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
    _index = (_index + 1) % _cameras.length;
    await _open(_cameras[_index]);
  }

  @override
  Future<void> dispose() => _close();
}
