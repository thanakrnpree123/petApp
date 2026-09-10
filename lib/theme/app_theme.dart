import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// PawHealth design system: calm, minimal, and readable for every age.
///
/// - One quiet brand color (sage) on a warm off-white ground; everything
///   else is neutral, so the few colored elements carry meaning.
/// - Flat surfaces separated by hairline borders instead of shadows.
/// - Generous type (16px body minimum) and 52px-tall primary controls —
///   comfortable for older eyes and less precise fingers.
/// - Every text/background pair used here meets WCAG AA (4.5:1).
abstract final class AppColors {
  static const brand = Color(0xFF3F7A6B);
  static const background = Color(0xFFF7F5F1);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF1F2623);
  static const inkMuted = Color(0xFF5C6661);
  static const hairline = Color(0xFFE6E2DB);
  static const fieldFill = Color(0xFFF1EEE9);
}

abstract final class AppRadius {
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 28.0;
}

abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

/// Meaning-carrying colors that Material's ColorScheme has no slot for.
/// Read with `Theme.of(context).extension<StatusColors>()!`.
@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  final Color success;
  final Color warning;
  final Color danger;
  final Color premium;

  const StatusColors({
    required this.success,
    required this.warning,
    required this.danger,
    required this.premium,
  });

  static const light = StatusColors(
    success: Color(0xFF2E7D4F),
    warning: Color(0xFFB45309),
    danger: Color(0xFFC62828),
    premium: Color(0xFFB7791F),
  );

  @override
  StatusColors copyWith({
    Color? success,
    Color? warning,
    Color? danger,
    Color? premium,
  }) => StatusColors(
    success: success ?? this.success,
    warning: warning ?? this.warning,
    danger: danger ?? this.danger,
    premium: premium ?? this.premium,
  );

  @override
  StatusColors lerp(StatusColors? other, double t) {
    if (other == null) return this;
    return StatusColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      premium: Color.lerp(premium, other.premium, t)!,
    );
  }
}

extension AppThemeContext on BuildContext {
  StatusColors get statusColors => Theme.of(this).extension<StatusColors>()!;
}

abstract final class AppTheme {
  /// Font per script. Nunito (rounded, open counters) has no Thai or CJK
  /// glyphs, so Thai gets IBM Plex Sans Thai Looped — the looped letterforms
  /// Thai readers of all ages learn first — and Simplified Chinese gets
  /// Noto Sans SC for full character coverage.
  static TextStyle fontFor(Locale locale, [TextStyle? style]) =>
      switch (locale.languageCode) {
        'th' => GoogleFonts.ibmPlexSansThaiLooped(textStyle: style),
        'zh' => GoogleFonts.notoSansSc(textStyle: style),
        _ => GoogleFonts.nunito(textStyle: style),
      };

  static TextTheme _textThemeFor(Locale locale, TextTheme base) =>
      switch (locale.languageCode) {
        'th' => GoogleFonts.ibmPlexSansThaiLoopedTextTheme(base),
        'zh' => GoogleFonts.notoSansScTextTheme(base),
        _ => GoogleFonts.nunitoTextTheme(base),
      };

  static ThemeData forLocale(Locale locale) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.brand,
      primary: AppColors.brand,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      onSurfaceVariant: AppColors.inkMuted,
      outlineVariant: AppColors.hairline,
      surfaceContainerLowest: AppColors.surface,
      surfaceContainerLow: AppColors.background,
      surfaceContainer: AppColors.fieldFill,
      surfaceContainerHighest: AppColors.fieldFill,
      surfaceTint: Colors.transparent,
    );

    // Minimal type scale: fewer weights, bigger body text. Sizes are set
    // explicitly so every locale's font lands on the same rhythm.
    const base = TextTheme(
      displaySmall: TextStyle(
        fontSize: 34,
        height: 1.2,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        height: 1.25,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        height: 1.3,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        height: 1.3,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        fontSize: 17,
        height: 1.35,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: TextStyle(
        fontSize: 15,
        height: 1.35,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(
        fontSize: 17,
        height: 1.5,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        height: 1.45,
        fontWeight: FontWeight.w500,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        height: 1.25,
        fontWeight: FontWeight.w700,
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        height: 1.25,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        height: 1.25,
        fontWeight: FontWeight.w600,
      ),
    );
    final textTheme = _textThemeFor(
      locale,
      base.apply(bodyColor: AppColors.ink, displayColor: AppColors.ink),
    );

    final controlShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.sm),
    );
    const controlSize = Size(64, 52);
    const controlPadding = EdgeInsets.symmetric(horizontal: 20);

    OutlineInputBorder fieldBorder([
      Color color = Colors.transparent,
      double width = 1,
    ]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      borderSide: BorderSide(color: color, width: width),
    );

    return ThemeData(
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      dividerColor: AppColors.hairline,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      extensions: const [StatusColors.light],

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: AppSpacing.md,
        titleTextStyle: textTheme.titleLarge,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: AppColors.hairline),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.hairline,
        thickness: 1,
        space: 1,
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: controlSize,
          padding: controlPadding,
          shape: controlShape,
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: controlSize,
          padding: controlPadding,
          shape: controlShape,
          foregroundColor: AppColors.ink,
          side: const BorderSide(color: AppColors.hairline, width: 1.5),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: controlShape,
          textStyle: textTheme.labelLarge,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: controlSize,
          padding: controlPadding,
          shape: controlShape,
          elevation: 0,
          textStyle: textTheme.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        extendedTextStyle: textTheme.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.fieldFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(color: AppColors.inkMuted),
        floatingLabelStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.inkMuted),
        errorStyle: textTheme.bodySmall?.copyWith(color: colorScheme.error),
        border: fieldBorder(),
        enabledBorder: fieldBorder(),
        disabledBorder: fieldBorder(),
        focusedBorder: fieldBorder(colorScheme.primary, 2),
        errorBorder: fieldBorder(colorScheme.error, 1.5),
        focusedErrorBorder: fieldBorder(colorScheme.error, 2),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: colorScheme.primary,
        secondarySelectedColor: colorScheme.primary,
        disabledColor: AppColors.fieldFill,
        // Chips resolve a WidgetStateColor label color per state, so the
        // selected (filled) chip gets white text without per-chip overrides.
        labelStyle: textTheme.labelMedium?.copyWith(
          color: WidgetStateColor.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? colorScheme.onPrimary
                : AppColors.ink,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        side: WidgetStateBorderSide.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? BorderSide(color: colorScheme.primary)
              : const BorderSide(color: AppColors.hairline),
        ),
        shape: const StadiumBorder(),
        showCheckmark: false,
        checkmarkColor: colorScheme.onPrimary,
      ),

      listTileTheme: ListTileThemeData(
        iconColor: AppColors.inkMuted,
        minVerticalPadding: 12,
        titleTextStyle: textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.inkMuted,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 72,
        indicatorColor: colorScheme.primaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelMedium?.copyWith(
            color: states.contains(WidgetState.selected)
                ? AppColors.ink
                : AppColors.inkMuted,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 26,
            color: states.contains(WidgetState.selected)
                ? colorScheme.onPrimaryContainer
                : AppColors.inkMuted,
          ),
        ),
      ),

      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.surface,
        elevation: 0,
        indicatorColor: colorScheme.primaryContainer,
        selectedIconTheme: IconThemeData(
          size: 26,
          color: colorScheme.onPrimaryContainer,
        ),
        unselectedIconTheme: const IconThemeData(
          size: 26,
          color: AppColors.inkMuted,
        ),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: AppColors.ink,
          fontWeight: FontWeight.w800,
        ),
        unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: AppColors.inkMuted,
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: const BorderSide(color: AppColors.hairline),
        ),
        textStyle: textTheme.bodyMedium,
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: AppColors.fieldFill,
      ),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.ink,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: textTheme.bodySmall?.copyWith(color: Colors.white),
      ),

      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
      ),
    );
  }
}
