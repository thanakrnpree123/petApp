import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/l10n/app_localizations.dart';
import 'package:pawhealth/models/article.dart';
import 'package:pawhealth/screens/articles/article_list_screen.dart';
import 'package:pawhealth/services/article_service.dart';

class _FakeArticleService implements ArticleService {
  int watchCalls = 0;

  @override
  Stream<List<Article>> watchArticles() {
    watchCalls++;
    return Stream.value([
      Article(
        id: 'a1',
        title: 'Heatstroke first aid',
        category: 'first_aid',
        content: 'Move your pet somewhere cool.',
        publishedAt: DateTime(2026, 8, 1),
      ),
      Article(
        id: 'a2',
        title: 'Feeding a senior cat',
        category: 'nutrition',
        content: 'Smaller, more frequent meals.',
        publishedAt: DateTime(2026, 7, 1),
      ),
    ]);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> _pump(
  WidgetTester tester,
  ArticleService service, {
  Locale locale = const Locale('en'),
}) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: ArticleListScreen(articleService: service)),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('the "All" filter chip is localized', (tester) async {
    await _pump(tester, _FakeArticleService(), locale: const Locale('th'));

    expect(find.widgetWithText(ChoiceChip, 'ทั้งหมด'), findsOneWidget);
    expect(find.text('All'), findsNothing);
  });

  testWidgets('tapping a category keeps the list instead of reloading', (
    tester,
  ) async {
    final service = _FakeArticleService();
    await _pump(tester, service);
    expect(find.text('Heatstroke first aid'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Nutrition'));
    await tester.pump();

    expect(find.text('Feeding a senior cat'), findsOneWidget);
    expect(find.text('Heatstroke first aid'), findsNothing);
    expect(service.watchCalls, 1);
  });
}
