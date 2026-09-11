/// Makes sure the web camera implementation is registered before use.
///
/// camera_web implements the federated `camera` plugin, but the app depends
/// on camera_web directly (not on `camera`, whose Android/iOS parts would
/// add unwanted permissions) — and the web build then left camera_web out of
/// the generated plugin registrant. CameraPlatform.instance stayed the
/// method-channel default, so every webcam call failed instantly without
/// even showing the browser's permission prompt. Registering it here
/// explicitly removes the dependence on registrant generation.
library;

export 'webcam_registration_stub.dart'
    if (dart.library.js_interop) 'webcam_registration_web.dart';
