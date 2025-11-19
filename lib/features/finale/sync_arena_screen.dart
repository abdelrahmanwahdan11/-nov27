import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/section_title.dart';
import '../../models/wellness_models.dart';

class SyncArenaScreen extends StatelessWidget {
  const SyncArenaScreen({super.key, required this.controller});

  final DietController controller;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(texts.translate('sync_arena')),
        backgroundColor: Colors.transparent,
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final drills = controller.syncDrills;
          final average = drills.isEmpty
              ? 0.0
              : drills.map((e) => e.progress).reduce((a, b) => a + b) /
                  drills.length;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(.25),
                      Theme.of(context).colorScheme.secondary.withOpacity(.15),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      texts.translate('sync_hint'),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    Text('${texts.translate('sync_progress')}: ${(average * 100).round()}%'),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(value: average),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: .1),
              const SizedBox(height: 24),
              SectionTitle(title: texts.translate('sync_drills')),
              const SizedBox(height: 12),
              ...drills.map(
                (drill) => _DrillCard(
                  drill: drill,
                  locale: locale,
                  texts: texts,
                  onAdvance: () {
                    controller.advanceSyncDrill(drill.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(texts.translate('drill_advanced')),
                      ),
                    );
                  },
                )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: .1),
              )
            ],
          );
        },
      ),
    );
  }
}

class _DrillCard extends StatelessWidget {
  const _DrillCard({
    required this.drill,
    required this.locale,
    required this.texts,
    required this.onAdvance,
  });

  final SyncDrill drill;
  final Locale locale;
  final AppLocalizations texts;
  final VoidCallback onAdvance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            Colors.blueAccent.withOpacity(.2),
            Colors.purpleAccent.withOpacity(.1),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  drill.localizedTitle(locale),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                '${drill.completedRounds}/${drill.rounds} ${texts.translate('rounds_complete')}',
              )
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: drill.progress),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: drill
                .localizedCues(locale)
                .map((cue) => Chip(label: Text(cue)))
                .toList(),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: ElevatedButton.icon(
              onPressed: onAdvance,
              icon: const Icon(Icons.trending_up),
              label: Text(texts.translate('advance_round')),
            ),
          )
        ],
      ),
    );
  }
}
