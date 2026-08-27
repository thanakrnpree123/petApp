import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Pet photo picker.
///
/// Works on mobile and web: the picked image is carried as raw bytes rather
/// than a `dart:io` File (which does not exist on web), and previewed with
/// MemoryImage so the same code path renders everywhere.
class PhotoPickerField extends StatelessWidget {
  final Uint8List? selectedBytes;
  final String? existingPhotoUrl;
  final ValueChanged<Uint8List> onPicked;

  const PhotoPickerField({
    super.key,
    required this.onPicked,
    this.selectedBytes,
    this.existingPhotoUrl,
  });

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (image == null) return;
    onPicked(await image.readAsBytes());
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? backgroundImage;
    if (selectedBytes != null) {
      backgroundImage = MemoryImage(selectedBytes!);
    } else if (existingPhotoUrl != null) {
      backgroundImage = NetworkImage(existingPhotoUrl!);
    }

    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: CircleAvatar(
          radius: 56,
          backgroundImage: backgroundImage,
          child: backgroundImage == null
              ? const Icon(Icons.add_a_photo, size: 32)
              : null,
        ),
      ),
    );
  }
}
