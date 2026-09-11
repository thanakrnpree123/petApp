import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/l10n/app_localizations.dart';
import 'package:pawhealth/widgets/common/brand_mark.dart';

void main() {
  testWidgets('the nav rail brand reads "PawHealth" without widening it', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: 0,
                labelType: NavigationRailLabelType.all,
                leading: const BrandMark(size: 36, showWordmark: true),
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.pets),
                    label: Text('Pets'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings),
                    label: Text('Settings'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('PawHealth'), findsOneWidget);
    expect(find.byIcon(Icons.pets), findsWidgets);
    expect(find.bySemanticsLabel('PawHealth'), findsOneWidget);
    // The rail is at least 80 wide; the brand must fit inside that at any
    // font, rather than widening it.
    expect(tester.getSize(find.byType(BrandMark)).width, lessThanOrEqualTo(72));
  });
}
