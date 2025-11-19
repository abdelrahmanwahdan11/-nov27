import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/section_title.dart';

class LegacyCapsuleScreen extends StatefulWidget {
  const LegacyCapsuleScreen({super.key, required this.controller});

  final DietController controller;

  @override
  State<LegacyCapsuleScreen> createState() => _LegacyCapsuleScreenState();
}

class _LegacyCapsuleScreenState extends State<LegacyCapsuleScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(texts.translate('legacy_capsule')),
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openComposer(texts),
        icon: const Icon(Icons.add),
        label: Text(texts.translate('add_capsule')),
      ),
      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          final capsules = widget.controller.legacyCapsules;
          final recents = widget.controller.recentLegacyCapsules;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(.3),
                      Theme.of(context).colorScheme.secondary.withOpacity(.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(texts.translate('legacy_capsule_hint'),
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: recents
                          .map(
                            (capsule) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: capsule.moodColor.withOpacity(.3),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    capsule.localizedTitle(locale),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    capsule.localizedNote(locale),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: .2),
              const SizedBox(height: 24),
              SectionTitle(title: texts.translate('capsule_timeline')),
              const SizedBox(height: 12),
              if (capsules.isEmpty)
                Text(
                  texts.translate('legacy_empty'),
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              else
                Column(
                  children: capsules
                      .map(
                        (capsule) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            gradient: LinearGradient(
                              colors: [
                                capsule.moodColor.withOpacity(.75),
                                capsule.moodColor.withOpacity(.25),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      capsule.localizedTitle(locale),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => widget.controller
                                        .toggleLegacyFavorite(capsule.id),
                                    icon: Icon(
                                      capsule.favorite
                                          ? Icons.star
                                          : Icons.star_border,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                capsule.localizedNote(locale),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${capsule.timestamp.hour.toString().padLeft(2, '0')}:${capsule.timestamp.minute.toString().padLeft(2, '0')} · ${capsule.timestamp.month}/${capsule.timestamp.day}',
                              ),
                            ],
                          ),
                        ).animate(delay: capsules.indexOf(capsule) * 60.ms)
                            .fadeIn()
                            .slideY(begin: .1),
                      )
                      .toList(),
                ),
            ],
          );
        },
      ),
    );
  }

  void _openComposer(AppLocalizations texts) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(texts.translate('add_capsule'),
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              TextField(
                controller: _titleController,
                decoration:
                    InputDecoration(labelText: texts.translate('capsule_title')),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _noteController,
                decoration:
                    InputDecoration(labelText: texts.translate('capsule_note')),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: texts.translate('save_capsule'),
                onPressed: () {
                  widget.controller.addLegacyCapsule(
                    _titleController.text,
                    _noteController.text,
                  );
                  _titleController.clear();
                  _noteController.clear();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(texts.translate('capsule_saved'))),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
