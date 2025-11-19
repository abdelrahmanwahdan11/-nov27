import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';
import '../../models/wellness_models.dart';

class FocusGymScreen extends StatelessWidget {
  const FocusGymScreen({super.key, required this.controller});

  final DietController controller;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(texts.translate('focus_gym')),
        actions: [
          IconButton(
            onPressed: controller.resetFocusDrills,
            icon: const Icon(Icons.refresh),
            tooltip: texts.translate('focus_reset'),
          )
        ],
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final drills = controller.focusDrills;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(texts.translate('focus_intro'),
                      style: Theme.of(context).textTheme.bodyLarge)
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: .2),
              const SizedBox(height: 16),
              ...drills.map(
                (drill) => _FocusDrillCard(
                  drill: drill,
                  controller: controller,
                  texts: texts,
                ).animate().fadeIn(duration: 400.ms).slideY(begin: .1),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FocusDrillCard extends StatelessWidget {
  const _FocusDrillCard({
    required this.drill,
    required this.controller,
    required this.texts,
  });

  final FocusDrill drill;
  final DietController controller;
  final AppLocalizations texts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: theme.colorScheme.surfaceVariant.withOpacity(.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(drill.localizedCue(Localizations.localeOf(context)),
                        style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text('${drill.durationSeconds} s · ${drill.breaths} breaths'),
                  ],
                ),
              ),
              Icon(
                drill.completed ? Icons.check_circle : Icons.timelapse,
                color: drill.completed
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: drill.progress,
            minHeight: 8,
            backgroundColor: theme.colorScheme.surface.withOpacity(.4),
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: texts.translate('focus_complete'),
                  onPressed: drill.completed
                      ? null
                      : () => controller.completeFocusDrill(drill.id),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () => controller.nudgeFocusDrill(drill.id),
                icon: const Icon(Icons.add),
              ),
            ],
          )
        ],
      ),
    );
  }
}
