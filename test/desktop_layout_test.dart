import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/l10n/app_localizations.dart';
import 'package:pawhealth/l10n/app_localizations_en.dart';
import 'package:pawhealth/models/article.dart';
import 'package:pawhealth/providers/pet_provider.dart';
import 'package:pawhealth/screens/articles/article_list_screen.dart';
import 'package:pawhealth/screens/pets/pet_form_screen.dart';
import 'package:pawhealth/services/article_service.dart';
import 'package:pawhealth/services/notification_service.dart';
import 'package:pawhealth/services/pet_service.dart';
import 'package:pawhealth/services/storage_service.dart';
import 'package:pawhealth/widgets/articles/article_card.dart';
import 'package:pawhealth/widgets/responsive/content_width.dart';
import 'package:provider/provider.dart';

class _OneArticle implements ArticleService {
  @override
  Stream<List<Article>> watchArticles() => Stream.value([
    Article(
      id: 'a1',
      title: const LocalizedText({'en': 'Heatstroke first aid'}),
      category: 'first_aid',
      content: const LocalizedText({'en': 'Move your pet somewhere cool.'}),
      publishedAt: DateTime(2026, 8, 1),
    ),
  ]);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Unused implements PetService, StorageService, NotificationService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void _desktopWindow(WidgetTester tester) {
  tester.view.physicalSize = const Size(1440, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('the desktop page title lines up with the content below it', (
    tester,
  ) async {
    _desktopWindow(tester);
    // The shell's desktop body: title over the tab's content.
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const DesktopPageTitle(
                title: 'Health articles',
                maxWidth: ContentWidth.reading,
              ),
              Expanded(child: ArticleListScreen(articleService: _OneArticle())),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    final title = tester.getRect(find.text('Health articles'));
    final card = tester.getRect(find.byType(ArticleCard));
    expect(title.left, card.left);
    expect(card.width, lessThanOrEqualTo(ContentWidth.reading));
  });

  testWidgets('the pet form is capped to a readable width on desktop', (
    tester,
  ) async {
    _desktopWindow(tester);
    final unused = _Unused();
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => PetProvider(
          petService: unused,
          storageService: unused,
          notificationService: unused,
        ),
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: PetFormScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final name = tester.getRect(
      find.widgetWithText(TextFormField, AppLocalizationsEn().petName),
    );
    expect(name.width, lessThanOrEqualTo(ContentWidth.reading));
    expect(name.center.dx, closeTo(720, 1), reason: 'centered in the window');
  });
}
