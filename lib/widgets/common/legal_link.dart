import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';

/// Opens [url] in the browser; overridable in tests.
typedef UrlOpener = Future<bool> Function(Uri url);

Future<bool> _launchExternal(Uri url) async {
  try {
    return await launchUrl(url, mode: LaunchMode.externalApplication);
  } catch (_) {
    return false;
  }
}

/// Opens a legal document, telling the user if it couldn't be opened
/// instead of failing silently.
Future<void> openLegalLink(
  BuildContext context,
  Uri url, {
  UrlOpener? opener,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  final failed = AppLocalizations.of(context)!.linkOpenFailed;
  final opened = await (opener ?? _launchExternal)(url);
  if (!opened) {
    messenger.showSnackBar(SnackBar(content: Text(failed)));
  }
}
