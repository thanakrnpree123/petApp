import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/pet.dart';
import '../../providers/pet_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../services/symptom_check_service.dart';
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

  Future<void> _openSymptomChecker(Pet pet) async {
    final isPlusMember = context.read<SubscriptionProvider>().isPlusMember;

    if (!isPlusMember) {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final limitReached = await _symptomCheckService.hasReachedFreeLimit(
        userId,
      );
      if (limitReached) {
        if (!mounted) return;
        await UpgradePromptDialog.show(
          context,
          message: AppLocalizations.of(context)!.symptomLimitMessage,
        );
        return;
      }
    }

    if (!mounted) return;
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => SymptomCheckerScreen(pet: pet)));
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
          success
              ? l10n.petDeleted(pet.name)
              : l10n.deletePetFailed(pet.name),
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
      body = Center(child: Text(AppLocalizations.of(context)!.noPetsYet));
    } else if (isDesktop) {
      // A single narrow list column reads as empty on a wide window, so
      // desktop wraps the same _PetCard into a grid instead — same data,
      // same tap targets, just laid out to use the width.
      body = Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 360,
              mainAxisExtent: 108,
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
      body = ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        itemCount: pets.length,
        itemBuilder: (context, index) => _PetCard(
          pet: pets[index],
          onCheckSymptoms: _openSymptomChecker,
          onDelete: _deletePet,
        ),
      );
    }

    return Scaffold(
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const PetFormScreen()));
        },
        child: const Icon(Icons.add),
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

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => PetHealthDashboard(pet: pet)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: colorScheme.secondaryContainer,
                backgroundImage: pet.photoUrl != null
                    ? NetworkImage(pet.photoUrl!)
                    : null,
                child: pet.photoUrl == null
                    ? Icon(
                        pet.species == PetSpecies.dog
                            ? Icons.pets
                            : Icons.pets_outlined,
                        color: colorScheme.onSecondaryContainer,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${pet.breed.isEmpty ? L10nHelpers.species(AppLocalizations.of(context)!, pet.species) : pet.breed}'
                      ' · ${L10nHelpers.petAge(AppLocalizations.of(context)!, pet)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
