import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../l10n/app_localizations.dart';
import 'pet_avatar.dart';
import 'webcam_capture_screen.dart';

/// Picks raw image bytes from [source]; null when the user cancels.
typedef ImageBytesPicker = Future<Uint8List?> Function(ImageSource source);

/// Pet photo picker.
///
/// Works on mobile and web: the picked image is carried as raw bytes rather
/// than a `dart:io` File (which does not exist on web), and previewed with
/// MemoryImage so the same code path renders everywhere.
class PhotoPickerField extends StatelessWidget {
  final Uint8List? selectedBytes;
  final String? existingPhotoUrl;
  final ValueChanged<Uint8List> onPicked;

  /// Overrides for tests.
  final ImageBytesPicker? pickImage;
  final bool? cameraAvailable;
  final bool? isWeb;
  final Future<Uint8List?> Function(BuildContext context)? webcamCapture;

  const PhotoPickerField({
    super.key,
    required this.onPicked,
    this.selectedBytes,
    this.existingPhotoUrl,
    this.pickImage,
    this.cameraAvailable,
    this.isWeb,
    this.webcamCapture,
  });

  static Future<Uint8List?> _pickWithImagePicker(ImageSource source) async {
    final image = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1024,
      imageQuality: 85,
    );
    return image?.readAsBytes();
  }

  Future<void> _choose(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final web = isWeb ?? kIsWeb;
    // On the web, checking for a camera would itself trigger the browser's
    // permission prompt, so "Take Photo" is always offered and the capture
    // screen explains if there's no camera.
    final hasCamera =
        cameraAvailable ??
        (web || ImagePicker().supportsImageSource(ImageSource.camera));

    // Only ask "camera or library?" when there's a camera to offer.
    final source = hasCamera
        ? await showModalBottomSheet<ImageSource>(
            context: context,
            builder: (sheetContext) => SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.photo_camera_outlined),
                    title: Text(l10n.takePhoto),
                    onTap: () =>
                        Navigator.of(sheetContext).pop(ImageSource.camera),
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library_outlined),
                    title: Text(l10n.chooseFromLibrary),
                    onTap: () =>
                        Navigator.of(sheetContext).pop(ImageSource.gallery),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          )
        : ImageSource.gallery;
    if (source == null || !context.mounted) return;

    // image_picker's web camera is a file input, which desktop browsers
    // answer with a file chooser — use a real webcam preview instead.
    if (web && source == ImageSource.camera) {
      final bytes = await (webcamCapture ?? WebcamCaptureScreen.open)(context);
      if (bytes != null) onPicked(bytes);
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    try {
      final bytes = await (pickImage ?? _pickWithImagePicker)(source);
      if (bytes != null) onPicked(bytes);
    } on PlatformException catch (e) {
      // Denied camera/photo access used to fail silently — the tap just
      // did nothing. Say why, and where to fix it.
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            e.code.contains('access_denied')
                ? l10n.photoAccessDenied
                : l10n.photoPickFailed,
          ),
        ),
      );
    } catch (_) {
      // e.g. an unreadable or unsupported image file.
      messenger.showSnackBar(SnackBar(content: Text(l10n.photoPickFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final hasPhoto = selectedBytes != null || existingPhotoUrl != null;

    return Center(
      child: Semantics(
        button: true,
        label: hasPhoto ? l10n.changePetPhoto : l10n.addPetPhoto,
        excludeSemantics: true,
        child: InkWell(
          onTap: () => _choose(context),
          customBorder: const CircleBorder(),
          child: Stack(
            children: [
              PetAvatar(
                radius: 56,
                photoBytes: selectedBytes,
                photoUrl: existingPhotoUrl,
                placeholder: Icon(
                  Icons.add_a_photo_outlined,
                  size: 32,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              // Makes "tap to change" discoverable once a photo is set.
              if (hasPhoto)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: colorScheme.primary,
                    child: Icon(
                      Icons.edit,
                      size: 18,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
