import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';
import '../wellness/daily_check_in_screen.dart';
import '../wellness/mindful_stories_screen.dart';

class WellnessHubScreen extends StatelessWidget {
  const WellnessHubScreen({super.key, required this.controller});

  final DietController controller;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(texts.translate('wellness_hub')),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  texts.translate('wellness_intro'),
                  style: Theme.of(context).textTheme.titleMedium,
                ).animate().fadeIn().slideY(begin: .2),
                const SizedBox(height: 20),
                _HydrationCard(controller: controller),
                const SizedBox(height: 16),
                _MoodCard(controller: controller),
                const SizedBox(height: 16),
                _ReflectionList(controller: controller),
                const SizedBox(height: 28),
                PrimaryButton(
                  label: texts.translate('start_check_in'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DailyCheckInScreen(controller: controller),
                      ),
                    );
                  },
                ).animate().shake(delay: 200.ms),
                const SizedBox(height: 12),
                FilledButton.tonalIcon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MindfulStoriesScreen(controller: controller),
                      ),
                    );
                  },
                  icon: const Icon(Icons.self_improvement),
                  label: Text(texts.translate('mindful_stories')),
                ).animate().fadeIn(delay: 300.ms).slideY(begin: .1),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HydrationCard extends StatelessWidget {
  const _HydrationCard({required this.controller});

  final DietController controller;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final color = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            color.withOpacity(.8),
            color.withOpacity(.3),
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
              const Icon(Icons.water_drop, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                texts.translate('hydration'),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: controller.hydrationProgress),
            duration: const Duration(milliseconds: 800),
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                color: Colors.white,
                backgroundColor: Colors.white24,
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            '${controller.hydrationConsumed.toStringAsFixed(0)} / '
            '${controller.hydrationTarget.toStringAsFixed(0)} ml',
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            children: [
              ActionChip(
                label: Text(texts.translate('log_hydration_250')),
                onPressed: () => controller.logHydration(250),
                backgroundColor: Colors.white.withOpacity(.2),
                labelStyle: const TextStyle(color: Colors.white),
              ),
              ActionChip(
                label: Text(texts.translate('log_hydration_500')),
                onPressed: () => controller.logHydration(500),
                backgroundColor: Colors.white.withOpacity(.2),
                labelStyle: const TextStyle(color: Colors.white),
              ),
              TextButton(
                onPressed: controller.resetHydration,
                child: Text(
                  texts.translate('hydration_reset'),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: .2);
  }
}

class _MoodCard extends StatelessWidget {
  const _MoodCard({required this.controller});

  final DietController controller;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final moods = [
      texts.translate('mood_low'),
      texts.translate('mood_chill'),
      texts.translate('mood_balanced'),
      texts.translate('mood_focused'),
      texts.translate('mood_euphoric'),
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                texts.translate('current_mood'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Chip(
                label: Text('${controller.moodLevel}/5'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 64,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: moods.length,
              itemBuilder: (context, index) {
                final selected = controller.moodLevel == index + 1;
                return GestureDetector(
                  onTap: () => controller.updateMood(index + 1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: selected
                          ? Theme.of(context).colorScheme.primary.withOpacity(.2)
                          : Theme.of(context).colorScheme.surface,
                      border: Border.all(
                        color: selected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.emoji_emotions,
                          color: selected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          moods[index],
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    ).animate().fadeIn(delay: 150.ms).slideX(begin: -.1);
  }
}

class _ReflectionList extends StatelessWidget {
  const _ReflectionList({required this.controller});

  final DietController controller;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final reflections = controller.reflections.take(3).toList();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            texts.translate('recent_reflections'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          if (reflections.isEmpty)
            Text(texts.translate('no_reflections'))
          else
            ...reflections.map(
              (text) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.brightness_1, size: 8),
                    const SizedBox(width: 8),
                    Expanded(child: Text(text)),
                  ],
                ),
              ),
            )
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }
}
