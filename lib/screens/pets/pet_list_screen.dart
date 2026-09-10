import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/pet.dart';
import '../../providers/pet_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../services/symptom_check_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/l10n_helpers.dart';
import '../../widgets/common/confirm_delete_dialog.dart';
import '../../widgets/responsive/breakpoints.dart';
import '../../widgets/subscription/upgrade_prompt_dialog.dart';
import '../health/pet_health_dashboard.dart';
import '../symptom_checker/symptom_checker_screen.dart';
import 'pet_form_screen.dart';

class PetListScreen extends StatefulWidget {
  const PetListScreen({super.key});

  @override
  State<PetListScreen> createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  final _symptomCheckService = SymptomCheckService();

  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PetProvider>().startWatching(userId);
    });
  }

  /// Guards against a double tap pushing two checker screens while the
  /// free-limit lookup is still in flight.
  bool _openingChecker = false;

  Future<void> _openSymptomChecker(Pet pet) async {
    if (_openingChecker) return;
    _openingChecker = true;
    try {
      final isPlusMember = context.read<SubscriptionProvider>().isPlusMember;
      if (!isPlusMember) {
        final userId = FirebaseAuth.instance.currentUser!.uid;
        if (await _symptomCheckService.shouldBlockFreeCheck(userId)) {
          if (!mounted) return;
          await UpgradePromptDialog.show(
            context,
            message: AppLocalizations.of(context)!.symptomLimitMessage,
          );
          return;
        }
      }

      if (!mounted) return;
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => SymptomCheckerScreen(pet: pet)));
    } finally {
      _openingChecker = false;
    }
  }

  Future<void> _deletePet(Pet pet) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ConfirmDeleteDialog.show(
      context,
      title: l10n.deletePetTitle(pet.name),
      message: l10n.deletePetConfirmMessage(pet.name),
    );
    if (!confirmed || !mounted) return;

    final userId = FirebaseAuth.instance.currentUser!.uid;
    final success = await context.read<PetProvider>().deletePet(
      userId,
      pet.id!,
    );
    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success ? l10n.petDeleted(pet.name) : l10n.deletePetFailed(pet.name),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pets = context.watch<PetProvider>().pets;
    final isDesktop = screenSizeOf(context).isDesktop;

    Widget body;
    if (pets.isEmpty) {
      body = const _EmptyPets();
    } else if (isDesktop) {
      // A single narrow list column reads as empty on a wide window, so
      // desktop wraps the same _PetCard into a grid instead — same data,
      // same tap targets, just laid out to use the width.
      body = Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 380,
              // Grows with the user's text-size setting so large system
              // fonts never clip the card (104px at the default scale).
              mainAxisExtent: MediaQuery.textScalerOf(context).scale(52) + 52,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: pets.length,
            itemBuilder: (context, index) => _PetCard(
              pet: pets[index],
              onCheckSymptoms: _openSymptomChecker,
              onDelete: _deletePet,
            ),
          ),
        ),
      );
    } else {
      body = ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 104),
        itemCount: pets.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md - 4),
        itemBuilder: (context, index) => _PetCard(
          pet: pets[index],
          onCheckSymptoms: _openSymptomChecker,
          onDelete: _deletePet,
        ),
      );
    }

    return Scaffold(
      body: body,
      // A labeled button, not a bare "+": the action is readable at a
      // glance for people who don't know Material's icon conventions.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const PetFormScreen()));
        },
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.addPet),
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  final Pet pet;
  final Future<void> Function(Pet) onCheckSymptoms;
  final Future<void> Function(Pet) onDelete;

  const _PetCard({
    required this.pet,
    required this.onCheckSymptoms,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => PetHealthDashboard(pet: pet)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 4, 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: colorScheme.primaryContainer,
                backgroundImage: pet.photoUrl != null
                    ? NetworkImage(pet.photoUrl!)
                    : null,
                child: pet.photoUrl == null
                    ? Icon(
                        pet.species == PetSpecies.dog
                            ? Icons.pets
                            : Icons.pets_outlined,
                        size: 28,
                        color: colorScheme.onPrimaryContainer,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.name,
                      style: textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${pet.breed.isEmpty ? L10nHelpers.species(AppLocalizations.of(context)!, pet.species) : pet.breed}'
                      ' · ${L10nHelpers.petAge(AppLocalizations.of(context)!, pet)}',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                icon: const Icon(Icons.health_and_safety_outlined),
                tooltip: AppLocalizations.of(context)!.checkSymptoms,
                onPressed: () => onCheckSymptoms(pet),
              ),
              PopupMenuButton<_PetCardAction>(
                icon: const Icon(Icons.more_vert),
                tooltip: MaterialLocalizations.of(context).showMenuTooltip,
                onSelected: (action) {
                  switch (action) {
                    case _PetCardAction.edit:
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PetFormScreen(existingPet: pet),
                        ),
                      );
                    case _PetCardAction.delete:
                      onDelete(pet);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: _PetCardAction.edit,
                    child: ListTile(
                      leading: const Icon(Icons.edit_outlined),
                      title: Text(AppLocalizations.of(context)!.editProfile),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: _PetCardAction.delete,
                    child: ListTile(
                      leading: Icon(
                        Icons.delete_outline,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.deletePet,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _PetCardAction { edit, delete }

class _EmptyPets extends StatelessWidget {
  const _EmptyPets();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.pets,
                size: 48,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Text(
                AppLocalizations.of(context)!.noPetsYet,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
