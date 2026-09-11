import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// The small in-app brand: a paw badge, optionally with the "PawHealth"
/// wordmark under it.
///
/// Interim stand-in for the splash artwork, which turns into an unreadable
/// smudge at app-bar and nav-rail sizes. Swap in a proper small-size logo
/// asset here once one is designed — every in-app use goes through this.
class BrandMark extends StatelessWidget {
  final double size;
  final bool showWordmark;

  const BrandMark({super.key, this.size = 32, this.showWordmark = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final name = AppLocalizations.of(context)!.appTitle;

    final badge = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(Icons.pets, size: size * 0.6, color: colorScheme.onPrimary),
    );

    if (!showWordmark) return Semantics(label: name, child: badge);

    return Semantics(
      label: name,
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          badge,
          const SizedBox(height: 6),
          // Scales down rather than widening the nav rail at large text
          // sizes.
          SizedBox(
            width: 72,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                name,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
