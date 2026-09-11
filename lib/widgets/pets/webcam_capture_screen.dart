import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import 'webcam_device.dart';

enum _Stage { starting, live, capturing, review, failed }

/// Full-screen webcam capture for the web, where `image_picker`'s camera
/// source is only a file input that desktop browsers answer with a file
/// chooser. Live preview → Take Photo → Retake / Use Photo.
///
/// Resolves to the JPEG bytes, or null if the user closes it.
class WebcamCaptureScreen extends StatefulWidget {
  /// Override for tests.
  final WebcamDevice Function()? deviceFactory;

  const WebcamCaptureScreen({super.key, this.deviceFactory});

  static Future<Uint8List?> open(
    BuildContext context, {
    WebcamDevice Function()? deviceFactory,
  }) {
    return Navigator.of(context).push<Uint8List>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => WebcamCaptureScreen(deviceFactory: deviceFactory),
      ),
    );
  }

  @override
  State<WebcamCaptureScreen> createState() => _WebcamCaptureScreenState();
}

class _WebcamCaptureScreenState extends State<WebcamCaptureScreen> {
  late WebcamDevice _device;
  _Stage _stage = _Stage.starting;
  WebcamFailure? _failure;
  Uint8List? _photo;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    _device = (widget.deviceFactory ?? PluginWebcamDevice.new)();
    // Already "starting" on first run (from initState, where setState isn't
    // allowed); only a retry after a failure needs to switch back.
    if (_stage != _Stage.starting) {
      setState(() {
        _stage = _Stage.starting;
        _failure = null;
      });
    }
    try {
      await _device.start();
      if (mounted) setState(() => _stage = _Stage.live);
    } catch (e) {
      // Anything unexpected still ends in a message, never an endless
      // spinner.
      await _device.dispose();
      if (mounted) {
        setState(() {
          _stage = _Stage.failed;
          _failure = e is WebcamException ? e.failure : WebcamFailure.unknown;
        });
      }
    }
  }

  Future<void> _capture() async {
    if (_stage != _Stage.live) return;
    setState(() => _stage = _Stage.capturing);
    try {
      final photo = await _device.capture();
      if (mounted) {
        setState(() {
          _photo = photo;
          _stage = _Stage.review;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _stage = _Stage.failed;
          _failure = WebcamFailure.unknown;
        });
      }
    }
  }

  Future<void> _switchCamera() async {
    setState(() => _stage = _Stage.starting);
    try {
      await _device.switchCamera();
      if (mounted) setState(() => _stage = _Stage.live);
    } catch (e) {
      if (mounted) {
        setState(() {
          _stage = _Stage.failed;
          _failure = e is WebcamException ? e.failure : WebcamFailure.unknown;
        });
      }
    }
  }

  @override
  void dispose() {
    _device.dispose();
    super.dispose();
  }

  String _failureMessage(AppLocalizations l10n) => switch (_failure) {
    WebcamFailure.permissionDenied => l10n.cameraPermissionDenied,
    WebcamFailure.notFound => l10n.cameraNotFound,
    WebcamFailure.inUse => l10n.cameraInUse,
    _ => l10n.cameraStartFailed,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.takePhoto)),
      body: SafeArea(
        child: CallbackShortcuts(
          // Laptop convenience: Space takes the photo.
          bindings: {const SingleActivator(LogicalKeyboardKey.space): _capture},
          child: Focus(
            autofocus: true,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: switch (_stage) {
                    _Stage.starting => const CircularProgressIndicator(),
                    _Stage.live || _Stage.capturing => _buildLive(l10n),
                    _Stage.review => _buildReview(l10n),
                    _Stage.failed => _buildFailure(l10n),
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _frame(Widget child) => Flexible(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: child,
    ),
  );

  Widget _buildLive(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _frame(_device.buildPreview()),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_device.canSwitchCamera) ...[
              IconButton.outlined(
                onPressed: _stage == _Stage.live ? _switchCamera : null,
                icon: const Icon(Icons.cameraswitch_outlined),
                tooltip: l10n.switchCamera,
              ),
              const SizedBox(width: AppSpacing.md),
            ],
            FilledButton.icon(
              onPressed: _stage == _Stage.live ? _capture : null,
              icon: const Icon(Icons.photo_camera),
              label: Text(l10n.takePhoto),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReview(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _frame(Image.memory(_photo!, fit: BoxFit.contain)),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          children: [
            OutlinedButton.icon(
              onPressed: () => setState(() {
                _photo = null;
                _stage = _Stage.live;
              }),
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retake),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(_photo),
              icon: const Icon(Icons.check),
              label: Text(l10n.usePhoto),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFailure(AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          _failure == WebcamFailure.permissionDenied
              ? Icons.no_photography_outlined
              : Icons.videocam_off_outlined,
          size: 48,
          color: colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          _failureMessage(l10n),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton.icon(
          onPressed: _start,
          icon: const Icon(Icons.refresh),
          label: Text(l10n.tryAgain),
        ),
      ],
    );
  }
}
