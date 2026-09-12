import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// The app-wide loading indicator.
///
/// The animation ships with the app (it used to stream from LottieFiles'
/// CDN), so it shows offline and no third party is contacted.
class PawLoader extends StatelessWidget {
  static const String animationAsset = 'assets/animations/paw_loader.json';

  final double size;
  final String? message;

  const PawLoader({super.key, this.size = 160, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            animationAsset,
            width: size,
            height: size,
            fit: BoxFit.contain,
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
