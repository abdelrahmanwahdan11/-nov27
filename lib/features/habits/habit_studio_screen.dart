import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';

class HabitStudioScreen extends StatelessWidget {
  const HabitStudioScreen({super.key, required this.controller});

  final DietController controller;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final locale = Localizations.localeOf(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(texts.translate('habit_studio')),
            actions: [
              IconButton(
                icon: const Icon(Icons.shuffle),
                onPressed: controller.refreshMindfulStories,
                tooltip: texts.translate('refresh_stories'),
              ).animate(onPlay: (controller) => controller.repeat(period: 6.seconds)).rotate(begin: -0.04, end: 0.04),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                texts.translate('habit_intro'),
                style: Theme.of(context).textTheme.bodyLarge,
              ).animate().fadeIn(duration: 500.ms).slideY(begin: .2),
              const SizedBox(height: 16),
              ...controller.habits.asMap().entries.map((entry) {
                final habit = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: LinearGradient(
                        colors: habit.enabled
                            ? [
                                Theme.of(context).colorScheme.primary.withOpacity(.6),
                                Theme.of(context).colorScheme.secondary.withOpacity(.2),
                              ]
                            : [
                                Theme.of(context).colorScheme.surfaceVariant,
                                Theme.of(context).colorScheme.surface,
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
                                habit.localizedTitle(locale),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            Switch(
                              value: habit.enabled,
                              onChanged: (_) => controller.toggleHabit(habit.id),
                            ),
                          ],
                        ),
                        Text(habit.localizedDescription(locale)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: habit.schedule
                              .map((day) => Chip(
                                    label: Text(day),
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .surfaceTint
                                        .withOpacity(.15),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 12),
                        Text(texts.translate('habit_focus')),
                        Slider(
                          value: habit.focus,
                          onChanged: (value) => controller.setHabitFocus(habit.id, value),
                        ),
                        Row(
                          children: [
                            Text('${texts.translate('habit_streak')}: ${habit.streak}'),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: () => controller.boostHabitStreak(habit.id),
                              icon: const Icon(Icons.bolt),
                              label: Text(texts.translate('habit_boost')),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
                    .animate(delay: (entry.key * 80).ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: .1)
                    .shimmer(duration: 1200.ms, color: Colors.white24);
              }),
            ],
          ),
        );
      },
    );
  }
}
