import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';
import '../../models/wellness_models.dart';

class SleepSanctuaryScreen extends StatelessWidget {
  const SleepSanctuaryScreen({super.key, required this.controller});

  final DietController controller;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(texts.translate('sleep_sanctuary'))),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final cues = controller.sleepCues;
          final progress = controller.windDownProgress;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(texts.translate('sleep_preview')),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(.3),
                      Theme.of(context).colorScheme.secondary.withOpacity(.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(texts.translate('sleep_progress'),
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: progress),
                      duration: const Duration(milliseconds: 400),
                      builder: (context, value, _) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LinearProgressIndicator(value: value),
                            const SizedBox(height: 8),
                            Text('${(value * 100).round()}%'),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(texts.translate('winddown_hint')),
                  ],
                ),
              ).animate().fadeIn(duration: 500.ms).slideY(begin: .1),
              const SizedBox(height: 20),
              Text(texts.translate('sleep_cues'),
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              ...cues.map(
                (cue) => _SleepCueTile(
                  cue: cue,
                  onTap: () {
                    controller.toggleSleepCue(cue.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(texts.translate('sleep_cue_toast'))),
                    );
                  },
                )
                    .animate()
                    .fadeIn(duration: 350.ms)
                    .slideY(begin: .08),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: texts.translate('sleep_cta'),
                onPressed: () => controller.updateWindDownProgress(1),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SleepCueTile extends StatelessWidget {
  const _SleepCueTile({required this.cue, required this.onTap});

  final SleepCue cue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: cue.completed
              ? Theme.of(context).colorScheme.primary.withOpacity(.25)
              : Theme.of(context).colorScheme.surfaceVariant.withOpacity(.4),
          border: Border.all(
            color: cue.completed
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Text(cue.emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cue.localizedTitle(locale),
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(cue.localizedDetail(locale)),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: cue.completed
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : const Icon(Icons.circle_outlined),
            )
          ],
        ),
      ),
    );
  }
}
