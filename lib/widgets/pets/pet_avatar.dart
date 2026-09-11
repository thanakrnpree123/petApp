import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A pet's round photo, or [placeholder] when there is none — or when the
/// photo can't be loaded.
///
/// Uses an [Image] widget rather than CircleAvatar.backgroundImage: on the
/// web, Flutter fetches image bytes, which needs CORS headers from the host
/// (Firebase Storage sends none until the bucket's CORS is configured —
/// see cors.json). [WebHtmlElementStrategy.fallback] then shows the photo
/// through a plain <img> element, which doesn't need CORS; that fallback
/// only works inside an Image widget.
class PetAvatar extends StatelessWidget {
  final double radius;
  final String? photoUrl;

  /// A just-picked photo; takes precedence over [photoUrl].
  final Uint8List? photoBytes;
  final Widget placeholder;

  const PetAvatar({
    super.key,
    required this.radius,
    required this.placeholder,
    this.photoUrl,
    this.photoBytes,
  });

  @override
  Widget build(BuildContext context) {
    final ImageProvider? image = photoBytes != null
        ? MemoryImage(photoBytes!)
        : photoUrl != null
        ? NetworkImage(
            photoUrl!,
            webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
          )
        : null;

    return SizedBox.square(
      dimension: radius * 2,
      child: ClipOval(
        child: ColoredBox(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: image == null
              ? Center(child: placeholder)
              : Image(
                  image: image,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                  errorBuilder: (_, _, _) => Center(child: placeholder),
                ),
        ),
      ),
    );
  }
}
