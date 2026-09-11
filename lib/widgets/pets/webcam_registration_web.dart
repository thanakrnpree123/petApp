import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:camera_web/camera_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// Registers camera_web as the CameraPlatform, once.
void ensureWebcamPluginRegistered() {
  if (CameraPlatform.instance is CameraPlugin) return;
  CameraPlugin.registerWith(webPluginRegistrar);
}
