import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';

class MomentumPulseScreen extends StatelessWidget {
  const MomentumPulseScreen({super.key, required this.controller});

  final DietController controller;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(texts.translate('momentum_pulse')),
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final locale = Localizations.localeOf(context);
          final pulses = controller.momentumPulses;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                texts.translate('momentum_hint'),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              ...List.generate(pulses.length, (index) {
                final pulse = pulses[index];
                final progressPercent = (pulse.progress * 100).toInt();
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceVariant
                        .withOpacity(.3),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            pulse.completed
                                ? Icons.verified
                                : Icons.bolt_outlined,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              locale.languageCode == 'ar'
                                  ? pulse.titleAr
                                  : pulse.titleEn,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                controller.toggleMomentumPulse(pulse.id),
                            icon: Icon(
                              pulse.completed
                                  ? Icons.restart_alt
                                  : Icons.check_circle_outline,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        locale.languageCode == 'ar'
                            ? pulse.descriptionAr
                            : pulse.descriptionEn,
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: pulse.progress,
                        minHeight: 8,
                      )
                          .animate()
                          .slideX(begin: -.4, duration: 500.ms)
                          .fadeIn(),
                      const SizedBox(height: 8),
                      Text(
                        '${texts.translate('momentum_progress')} $progressPercent%',
                      ),
                      Slider(
                        value: pulse.progress,
                        onChanged: (value) => controller
                            .setMomentumPulseProgress(pulse.id, value),
                      ),
                      Row(
                        children: [
                          Chip(
                            label: Text(
                              pulse.completed
                                  ? texts.translate('pulse_completed')
                                  : texts.translate('pulse_remaining'),
                            ),
                          ),
                          const Spacer(),
                          Text('${texts.translate('pulse_goal')} ${(pulse.goal * 100).toInt()}%'),
                        ],
                      ),
                    ],
                  ),
                ).animate(delay: (index * 80).ms).fadeIn().slideY(begin: .2);
              }),
              const SizedBox(height: 12),
              PrimaryButton(
                label: texts.translate('pulse_cta'),
                onPressed: () {
                  for (final pulse in pulses) {
                    controller.setMomentumPulseProgress(
                        pulse.id, (pulse.progress + .2).clamp(0, 1));
                  }
                },
              )
            ],
          );
        },
      ),
    );
  }
}
