import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawhealth/theme/app_theme.dart';

void main() {
  // The theme is built here but never rendered, so no fonts are needed.
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  final theme = AppTheme.forLocale(const Locale('en'));

  test('dropdown lists are painted differently from the page', () {
    // Regression: menus used the page/field colors and looked like
    // nothing opened.
    final menuBackground = theme.dropdownMenuTheme.menuStyle?.backgroundColor
        ?.resolve({});

    expect(menuBackground, AppColors.surface);
    expect(menuBackground, isNot(theme.scaffoldBackgroundColor));
    expect(menuBackground, isNot(theme.inputDecorationTheme.fillColor));
    expect(theme.canvasColor, isNot(theme.scaffoldBackgroundColor));
  });

  test('menus have an edge and a shadow to separate them', () {
    final style = theme.dropdownMenuTheme.menuStyle!;
    final shape = style.shape?.resolve({}) as RoundedRectangleBorder?;

    expect(shape?.side.color, AppColors.hairline);
    expect(style.elevation?.resolve({}), greaterThan(0));
    expect(theme.menuTheme.style, same(style));
  });

  test('the dropdown field is filled like every other field', () {
    // Regression: DropdownMenu ignores the global inputDecorationTheme, so
    // the breed field rendered unfilled — plain text on the page.
    final field = theme.dropdownMenuTheme.inputDecorationTheme;

    expect(field, isNotNull);
    expect(field!.filled, isTrue);
    expect(field.fillColor, AppColors.fieldFill);
    expect(field.fillColor, theme.inputDecorationTheme.fillColor);
    expect(field.focusedBorder, theme.inputDecorationTheme.focusedBorder);
  });
}
