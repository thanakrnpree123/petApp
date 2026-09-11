import 'package:flutter/material.dart';

import 'breakpoints.dart';

/// Column widths shared by the shell's desktop page title and the page
/// bodies under it, so the title's left edge lines up with the content's.
abstract final class ContentWidth {
  /// Grids (the pet list, the health dashboard).
  static const wide = 1120.0;

  /// Lists, forms and settings — a comfortable line length.
  static const reading = 640.0;
}

/// Side padding inside a [CenteredContent] column: roomier on desktop.
double pageGutter(BuildContext context) =>
    screenSizeOf(context).isDesktop ? 24 : 16;

/// Centers [child] horizontally and caps it at [maxWidth]; on narrow
/// screens it simply fills the width.
class CenteredContent extends StatelessWidget {
  final double maxWidth;
  final Widget child;

  const CenteredContent({
    super.key,
    required this.maxWidth,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

/// The large page title the desktop shell shows above each tab, placed in
/// the same centered column as that tab's content.
class DesktopPageTitle extends StatelessWidget {
  final String title;
  final double maxWidth;

  const DesktopPageTitle({
    super.key,
    required this.title,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return CenteredContent(
      maxWidth: maxWidth,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          pageGutter(context),
          28,
          pageGutter(context),
          4,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
        ),
      ),
    );
  }
}
