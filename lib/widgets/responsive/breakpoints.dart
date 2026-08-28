import 'package:flutter/widgets.dart';

/// Coarse width bands shared by every screen that adapts to desktop/web.
///
/// - `mobile`  (< 700px):  today's phone layout, unchanged.
/// - `tablet`  (700–900px): compact desktop chrome (icon-only rails, no
///   brand panels) — enough width for a two-column body, not for a full
///   sidebar.
/// - `desktop` (>= 900px): full sidebar/split-pane layout.
enum ScreenSize { mobile, tablet, desktop }

ScreenSize screenSizeOf(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width >= 900) return ScreenSize.desktop;
  if (width >= 700) return ScreenSize.tablet;
  return ScreenSize.mobile;
}

extension ScreenSizeX on ScreenSize {
  bool get isDesktop => this == ScreenSize.desktop;
  bool get isMobile => this == ScreenSize.mobile;
}
