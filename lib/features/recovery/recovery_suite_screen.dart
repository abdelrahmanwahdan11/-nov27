import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';
import '../../models/wellness_models.dart';

class RecoverySuiteScreen extends StatefulWidget {
  const RecoverySuiteScreen({super.key, required this.controller});

  final DietController controller;

  @override
  State<RecoverySuiteScreen> createState() => _RecoverySuiteScreenState();
}

class _RecoverySuiteScreenState extends State<RecoverySuiteScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breathController;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _breathController =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
          ..repeat(reverse: true);
    _pageController = PageController(viewportFraction: .82);
  }

  @override
  void dispose() {
    _breathController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final sessions = widget.controller.recoverySessions;
        return Scaffold(
          appBar: AppBar(
            title: Text(texts.translate('recovery_suite')),
            actions: [
              IconButton(
                onPressed: () {
                  widget.controller.shuffleRecoverySessions();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(texts.translate('recovery_shuffle_toast')),
                    ),
                  );
                },
                icon: const Icon(Icons.shuffle_rounded),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              widget.controller.addCustomRecoverySession();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(texts.translate('recovery_added')),
                ),
              );
            },
            label: Text(texts.translate('recovery_add_session')),
            icon: const Icon(Icons.add_rounded),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
            children: [
              Text(
                texts.translate('recovery_intro'),
                style: Theme.of(context).textTheme.bodyLarge,
              ).animate().fadeIn(duration: 400.ms).slideY(begin: .2),
              const SizedBox(height: 20),
              AnimatedBuilder(
                animation: _breathController,
                builder: (context, child) {
                  final progress = _breathController.value;
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(.45 + progress * .2),
                          Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(.2 + (.4 - progress * .2)),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          texts.translate('recovery_breath_title'),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(texts.translate('recovery_breath_subtitle')),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 120,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              _PulseCircle(size: 90 + (progress * 50)),
                              _PulseCircle(
                                size: 60 + (progress * 30),
                                opacity: .4,
                              ),
                              Text('${(progress * 6 + 4).toStringAsFixed(0)}s'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ).animate().fadeIn(duration: 400.ms).scale(begin: .95),
              const SizedBox(height: 24),
              Text(texts.translate('recovery_sessions'),
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              SizedBox(
                height: 220,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _RecoveryCard(
                        session: session,
                        onToggle: () {
                          widget.controller.toggleRecovery(session.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(session.completed
                                  ? texts.translate('recovery_completed_toast')
                                  : texts.translate('recovery_complete')),
                            ),
                          );
                        },
                        onEnergyChange: (value) =>
                            widget.controller.updateRecoveryEnergy(
                          session.id,
                          value,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: texts.translate('recovery_add_session'),
                onPressed: () {
                  widget.controller.addCustomRecoverySession();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(texts.translate('recovery_added'))),
                  );
                },
              ).animate().fadeIn(duration: 400.ms).slideY(begin: .2),
            ],
          ),
        );
      },
    );
  }
}

class _RecoveryCard extends StatelessWidget {
  const _RecoveryCard({
    required this.session,
    required this.onToggle,
    required this.onEnergyChange,
  });

  final RecoverySession session;
  final VoidCallback onToggle;
  final ValueChanged<double> onEnergyChange;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Theme.of(context)
            .colorScheme
            .surfaceVariant
            .withOpacity(.4 + (session.completed ? .2 : 0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  session.localizedTitle(Localizations.localeOf(context)),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                onPressed: onToggle,
                icon: Icon(
                  session.completed
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            session.localizedDescription(Localizations.localeOf(context)),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: session.tags
                .map((tag) => Chip(label: Text(tag)))
                .toList(),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                '${texts.translate('recovery_duration')}: '
                '${session.duration.inMinutes} min',
              ),
              const Spacer(),
              Text(texts.translate('recovery_energy')),
            ],
          ),
          Slider(
            value: session.energy,
            onChanged: onEnergyChange,
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: .2);
  }
}

class _PulseCircle extends StatelessWidget {
  const _PulseCircle({required this.size, this.opacity = .25});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primary.withOpacity(opacity),
      ),
    );
  }
}
