import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';
import '../../models/wellness_models.dart';

class FlowLabScreen extends StatelessWidget {
  const FlowLabScreen({super.key, required this.controller});

  final DietController controller;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(texts.translate('flow_lab')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.shuffleFlowRoutines();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(texts.translate('flow_shuffle_toast'))),
          );
        },
        child: const Icon(Icons.shuffle),
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final routines = controller.flowRoutines;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                texts.translate('flow_lab_subtitle'),
                style: Theme.of(context).textTheme.bodyLarge,
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: .2),
              const SizedBox(height: 16),
              ...routines.map(
                (routine) => _FlowRoutineCard(
                  routine: routine,
                  controller: controller,
                  texts: texts,
                ).animate().fadeIn(duration: 450.ms).slideY(begin: .1),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FlowRoutineCard extends StatelessWidget {
  const _FlowRoutineCard({
    required this.routine,
    required this.controller,
    required this.texts,
  });

  final FlowRoutine routine;
  final DietController controller;
  final AppLocalizations texts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => controller.toggleFlowRoutine(routine.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withOpacity(.3 + routine.intensity * .4),
              theme.colorScheme.secondary
                  .withOpacity(.2 + (routine.active ? .3 : .1)),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(.15),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
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
                      Text(
                        routine.localizedTitle(Localizations.localeOf(context)),
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        routine.localizedDescription(
                          Localizations.localeOf(context),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: routine.active
                        ? theme.colorScheme.primary.withOpacity(.8)
                        : theme.colorScheme.surfaceVariant.withOpacity(.4),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Text(
                    routine.active
                        ? texts.translate('flow_play')
                        : texts.translate('flow_sequence'),
                    style: theme.textTheme.labelMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(texts.translate('flow_tempo'),
                          style: theme.textTheme.labelLarge),
                      Text('${routine.tempo} bpm'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(texts.translate('flow_loops'),
                          style: theme.textTheme.labelLarge),
                      Text('${routine.loops}'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(texts.translate('flow_intensity')),
            Slider(
              value: routine.intensity,
              onChanged: (value) =>
                  controller.updateFlowRoutineIntensity(routine.id, value),
            ),
            const SizedBox(height: 8),
            PrimaryButton(
              label: texts.translate('flow_play'),
              onPressed: () => controller.toggleFlowRoutine(routine.id),
            ),
          ],
        ),
      ),
    );
  }
}
