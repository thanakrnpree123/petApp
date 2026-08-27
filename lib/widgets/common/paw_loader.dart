import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// The app-wide loading indicator.
///
/// Streams the animation from LottieFiles' CDN; if the device is offline or
/// the CDN is unreachable, falls back to the bundled
/// assets/animations/paw_loader.json so the loader itself can never fail to
/// appear.
class PawLoader extends StatelessWidget {
  static const String animationUrl =
      'https://lottie.host/e6b4bfbf-cd48-4814-abed-c1947c3dcd73/OViUj87HO9.json';

  final double size;
  final String? message;

  const PawLoader({super.key, this.size = 160, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.network(
            animationUrl,
            width: size,
            height: size,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Lottie.asset(
              'assets/animations/paw_loader.json',
              width: size,
              height: size / 2,
              fit: BoxFit.contain,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Full-screen modal loading overlay for CRUD operations.
///
/// Usage:
/// ```dart
/// final success = await PawLoaderOverlay.during(
///   context,
///   provider.savePet(...),
///   message: 'Saving…',
/// );
/// ```
/// Shows a barrier-blocking Lottie overlay while the future runs, then
/// dismisses it — including when the future throws.
class PawLoaderOverlay {
  const PawLoaderOverlay._();

  static Future<T> during<T>(
    BuildContext context,
    Future<T> future, {
    String? message,
  }) async {
    final navigator = Navigator.of(context, rootNavigator: true);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: PawLoader(message: message),
        ),
      ),
    );

    try {
      return await future;
    } finally {
      if (navigator.mounted && navigator.canPop()) {
        navigator.pop();
      }
    }
  }
}
