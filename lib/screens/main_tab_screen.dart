import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/subscription_provider.dart';
import '../widgets/responsive/breakpoints.dart';
import 'articles/article_list_screen.dart';
import 'pets/pet_list_screen.dart';
import 'settings/settings_screen.dart';
import 'subscription/paywall_screen.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _currentIndex = 0;

  static const _screens = [
    PetListScreen(),
    ArticleListScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionProvider>().init(userId);
    });
  }

  void _openPaywall() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PaywallScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isPlusMember = context.watch<SubscriptionProvider>().isPlusMember;
    final titles = [l10n.myPets, l10n.healthArticles, l10n.settings];
    final isDesktop = screenSizeOf(context).isDesktop;

    final logo = Image.asset(
      'assets/images/splash_logo.png',
      height: isDesktop ? 28 : 32,
      width: isDesktop ? 28 : 32,
      fit: BoxFit.contain,
    );

    final content = IndexedStack(index: _currentIndex, children: _screens);

    // Desktop: a persistent side rail replaces the bottom navigation bar —
    // no tab switch requires reaching down to the bottom of a wide window
    // — and the body is capped so lists/grids don't stretch full-bleed.
    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) =>
                  setState(() => _currentIndex = index),
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: logo,
              ),
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: isPlusMember
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.workspace_premium_outlined),
                            tooltip: l10n.upgradeToPlusTooltip,
                            onPressed: _openPaywall,
                          ),
                  ),
                ),
              ),
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.pets_outlined),
                  selectedIcon: const Icon(Icons.pets),
                  label: Text(l10n.myPets),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.menu_book_outlined),
                  selectedIcon: const Icon(Icons.menu_book),
                  label: Text(l10n.articlesTab),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.settings_outlined),
                  selectedIcon: const Icon(Icons.settings),
                  label: Text(l10n.settings),
                ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
                    child: Text(
                      titles[_currentIndex],
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(child: SafeArea(top: false, child: content)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: _currentIndex == 0
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [logo, const SizedBox(width: 8), Text(l10n.myPets)],
              )
            : Text(titles[_currentIndex]),
        actions: [
          if (!isPlusMember)
            IconButton(
              icon: const Icon(Icons.workspace_premium_outlined),
              tooltip: l10n.upgradeToPlusTooltip,
              onPressed: _openPaywall,
            ),
        ],
      ),
      body: SafeArea(child: content),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.pets_outlined),
            selectedIcon: const Icon(Icons.pets),
            label: l10n.myPets,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: l10n.articlesTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}
