import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/section_title.dart';
import '../../models/wellness_models.dart';
import 'sync_arena_screen.dart';

class ClarityConsoleScreen extends StatelessWidget {
  const ClarityConsoleScreen({super.key, required this.controller});

  final DietController controller;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(texts.translate('clarity_console')),
        backgroundColor: Colors.transparent,
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final focus = controller.clarityFocus;
          final signals = controller.claritySignals;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepPurple.withOpacity(.35),
                      Colors.indigo.withOpacity(.2),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      texts.translate('clarity_hint'),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(texts.translate('clarity_focus')),
                    const SizedBox(height: 8),
                    Slider(
                      value: focus,
                      onChanged: controller.setClarityFocus,
                    ),
                    Text('${(focus * 100).round()}%'),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      label: texts.translate('sync_arena'),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SyncArenaScreen(controller: controller),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: .1),
              const SizedBox(height: 24),
              SectionTitle(title: texts.translate('clarity_signals')),
              const SizedBox(height: 12),
              ...signals.map(
                (signal) => _SignalCard(
                  signal: signal,
                  locale: locale,
                  texts: texts,
                  onBoost: () {
                    controller.pulseClaritySignal(signal.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(texts.translate('signal_boosted')),
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

class _SignalCard extends StatelessWidget {
  const _SignalCard({
    required this.signal,
    required this.locale,
    required this.texts,
    required this.onBoost,
  });

  final ClaritySignal signal;
  final Locale locale;
  final AppLocalizations texts;
  final VoidCallback onBoost;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            signal.localizedLabel(locale),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(signal.localizedDescription(locale)),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: signal.current),
          const SizedBox(height: 4),
          Text('${texts.translate('sync_progress')}: ${(signal.current * 100).round()}%'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${texts.translate('clarity_focus')}: ${(signal.target * 100).round()}%'),
              Text('${(signal.trend * 100).round()}%'),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: PrimaryButton(
              label: texts.translate('boost_signal'),
              onPressed: onBoost,
            ),
          )
        ],
      ),
    );
  }
}
