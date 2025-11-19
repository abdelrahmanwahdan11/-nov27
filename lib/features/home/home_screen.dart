import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/section_title.dart';
import '../../data/mock_food_items.dart';
import '../../models/food_item.dart';
import '../../models/growth_models.dart';
import '../catalog/food_detail_screen.dart';
import '../coach/coach_chat_screen.dart';
import '../community/community_challenges_screen.dart';
import '../flow/flow_lab_screen.dart';
import '../focus/focus_gym_screen.dart';
import '../growth/growth_arena_screen.dart';
import '../grocery/grocery_planner_screen.dart';
import '../habits/habit_studio_screen.dart';
import '../insights/insights_screen.dart';
import '../journey/journey_reflections_screen.dart';
import '../journey/legacy_capsule_screen.dart';
import '../plan/macro_forge_screen.dart';
import '../plan/meal_plan_screen.dart';
import '../recipes/recipe_lab_screen.dart';
import '../recovery/recovery_suite_screen.dart';
import '../recharge/energy_studio_screen.dart';
import '../recharge/momentum_journal_screen.dart';
import '../recharge/sleep_sanctuary_screen.dart';
import '../recharge/pulse_observatory_screen.dart';
import '../rewards/rewards_vault_screen.dart';
import '../rituals/ritual_builder_screen.dart';
import '../rhythm/rhythm_board_screen.dart';
import '../vision/vision_board_screen.dart';
import '../wellness/wellness_hub_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.dietController});

  final DietController dietController;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: dietController,
      builder: (context, _) {
        final week = dietController.currentWeek;
        return SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                title: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(texts.translate('home')),
                  subtitle: Text('${texts.translate('calories_this_week')}: '
                      '${week.totalCalories}'),
                  trailing: const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80'),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _WeekChart(week.caloriesPerDay)
                          .animate(key: ValueKey(dietController.currentWeek.weekStart))
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: .2),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => dietController.changeWeek(-1),
                            icon: const Icon(Icons.chevron_left),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            child: Text(
                              '${texts.translate('week')} ${dietController.currentWeek.weekStart.month}/${dietController.currentWeek.weekStart.day}',
                              key: ValueKey(dietController.currentWeek.weekStart),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          IconButton(
                            onPressed: () => dietController.changeWeek(1),
                            icon: const Icon(Icons.chevron_right),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: Text(
                            '${week.totalCalories} kcal',
                            key: ValueKey(week.totalCalories),
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(letterSpacing: -2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary.withOpacity(.35),
                              Theme.of(context).colorScheme.secondary.withOpacity(.15),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(texts.translate('today_focus'),
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text(texts.translate('breathing_prompt')),
                            const SizedBox(height: 12),
                            PrimaryButton(
                              label: texts.translate('start_plan'),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => MealPlanScreen(
                                      controller: dietController,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 500.ms).slideY(begin: .2),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => WellnessHubScreen(
                                controller: dietController,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(.5),
                                Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(.2),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(texts.translate('wellness_hub'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
                                    const SizedBox(height: 6),
                                    Text(
                                      texts.translate('wellness_preview'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.self_improvement, size: 42),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: 200.ms).slideX(begin: -.1),
                      const SizedBox(height: 20),
                      _EnergyPulseCard(controller: dietController, texts: texts)
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: .1),
                      const SizedBox(height: 16),
                      _SleepWindDownCard(controller: dietController, texts: texts)
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: .1),
                      const SizedBox(height: 20),
                      _FlowSpotlight(controller: dietController, texts: texts)
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideX(begin: .1),
                      const SizedBox(height: 16),
                      _FocusSparkCard(controller: dietController, texts: texts)
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: .1),
                      const SizedBox(height: 16),
                      _JourneySparkCard(controller: dietController, texts: texts)
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideX(begin: -.1),
                      const SizedBox(height: 16),
                      SectionTitle(
                        title: texts.translate('growth_preview_title'),
                        action: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => GrowthArenaScreen(
                                  controller: dietController,
                                ),
                              ),
                            );
                          },
                          child: Text(texts.translate('see_all')),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 160,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: dietController.growthMissions.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final mission =
                                dietController.growthMissions[index];
                            return _MissionPreviewCard(
                              mission: mission,
                              controller: dietController,
                              texts: texts,
                            )
                                .animate(delay: (index * 80).ms)
                                .fadeIn()
                                .slideX(begin: .1);
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      _VisionPeekCard(controller: dietController, texts: texts)
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: .1),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _HomeActionTile(
                            icon: Icons.flag_rounded,
                            label: texts.translate('community_cta'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CommunityChallengesScreen(
                                    controller: dietController,
                                  ),
                                ),
                              );
                            },
                          ),
                          _HomeActionTile(
                            icon: Icons.blender,
                            label: texts.translate('recipe_cta'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => RecipeLabScreen(
                                    controller: dietController,
                                  ),
                                ),
                              );
                            },
                          ),
                          _HomeActionTile(
                            icon: Icons.chat_bubble_outline,
                            label: texts.translate('coach_cta'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CoachChatScreen(
                                    controller: dietController,
                                  ),
                                ),
                              );
                            },
                          ),
                          _HomeActionTile(
                            icon: Icons.auto_graph,
                            label: texts.translate('insights_cta'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => InsightsScreen(
                                    controller: dietController,
                                  ),
                                ),
                              );
                            },
                          ),
                          _HomeActionTile(
                            icon: Icons.shopping_bag_outlined,
                            label: texts.translate('grocery_cta'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => GroceryPlannerScreen(
                                    controller: dietController,
                                  ),
                                ),
                              );
                            },
                          ),
                          _HomeActionTile(
                            icon: Icons.refresh_rounded,
                            label: texts.translate('habit_cta'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => HabitStudioScreen(
                                    controller: dietController,
                                  ),
                                ),
                              );
                            },
                          ),
                          _HomeActionTile(
                            icon: Icons.nightlight_round,
                            label: texts.translate('recovery_cta'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => RecoverySuiteScreen(
                                    controller: dietController,
                                  ),
                                ),
                              );
                            },
                          ),
                          _HomeActionTile(
                            icon: Icons.auto_fix_high,
                            label: texts.translate('ritual_cta'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => RitualBuilderScreen(
                                    controller: dietController,
                                  ),
                                ),
                              );
                            },
                          ),
                          _HomeActionTile(
                            icon: Icons.emoji_events,
                            label: texts.translate('rewards_cta'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => RewardsVaultScreen(
                                    controller: dietController,
                                  ),
                                ),
                              );
                            },
                          ),
                          _HomeActionTile(
                            icon: Icons.bolt,
                            label: texts.translate('energy_studio_cta'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => EnergyStudioScreen(
                                    controller: dietController,
                                  ),
                                ),
                              );
                            },
                          ),
                          _HomeActionTile(
                            icon: Icons.nights_stay,
                            label: texts.translate('sleep_sanctuary_cta'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => SleepSanctuaryScreen(
                                    controller: dietController,
                                  ),
                                ),
                              );
                            },
                          ),
                          _HomeActionTile(
                            icon: Icons.timeline,
                            label: texts.translate('momentum_cta'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => MomentumJournalScreen(
                                    controller: dietController,
                                  ),
                                ),
                              );
                            },
                          ),
                          _HomeActionTile(
                            icon: Icons.all_inclusive,
                            label: texts.translate('flow_cta'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => FlowLabScreen(
                                    controller: dietController,
                                  ),
                                ),
                              );
                            },
                          ),
                          _HomeActionTile(
                            icon: Icons.center_focus_strong,
                            label: texts.translate('focus_cta'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => FocusGymScreen(
                                    controller: dietController,
                                  ),
                                ),
                              );
                            },
                          ),
                          _HomeActionTile(
                            icon: Icons.auto_awesome,
                            label: texts.translate('journey_reflections_cta'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => JourneyReflectionsScreen(
                                    controller: dietController,
                                  ),
                                ),
                              );
                            },
                          ),
                          _HomeActionTile(
                            icon: Icons.trending_up,
                            label: texts.translate('growth_arena_title'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => GrowthArenaScreen(
                                    controller: dietController,
                                  ),
                                ),
                              );
                            },
                          ),
                          _HomeActionTile(
                            icon: Icons.graphic_eq,
                            label: texts.translate('rhythm_board_title'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => RhythmBoardScreen(
                                    controller: dietController,
                                  ),
                                ),
                              );
                            },
                          ),
                          _HomeActionTile(
                            icon: Icons.brush,
                            label: texts.translate('vision_board_title'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => VisionBoardScreen(
                                    controller: dietController,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ).animate().fadeIn(delay: 300.ms).slideY(begin: .1),
                      const SizedBox(height: 24),
                      SectionTitle(title: texts.translate('finale_suite')),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _FinaleCard(
                            icon: Icons.graphic_eq,
                            title: texts.translate('pulse_observatory'),
                            subtitle: texts.translate('pulse_hint'),
                            colors: const [Colors.amberAccent, Colors.deepPurple],
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => PulseObservatoryScreen(
                                    controller: dietController,
                                  ),
                                ),
                              );
                            },
                          ),
                          _FinaleCard(
                            icon: Icons.balcony,
                            title: texts.translate('macro_forge'),
                            subtitle: texts.translate('macro_forge_hint'),
                            colors: const [Colors.pinkAccent, Colors.blueAccent],
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => MacroForgeScreen(
                                    controller: dietController,
                                  ),
                                ),
                              );
                            },
                          ),
                          _FinaleCard(
                            icon: Icons.auto_awesome,
                            title: texts.translate('legacy_capsule'),
                            subtitle: texts.translate('legacy_capsule_hint'),
                            colors: const [Colors.tealAccent, Colors.indigo],
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => LegacyCapsuleScreen(
                                    controller: dietController,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ).animate().fadeIn(duration: 400.ms).slideY(begin: .1),
                      const SizedBox(height: 24),
                      SectionTitle(title: texts.translate('catalog')),
                      SizedBox(
                        height: 220,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: mockFoodItems.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final item = mockFoodItems[index];
                            return _FoodCard(item: item)
                                .animate(delay: (index * 120).ms)
                                .fadeIn()
                                .slideX(begin: .3);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _EnergyPulseCard extends StatelessWidget {
  const _EnergyPulseCard({required this.controller, required this.texts});

  final DietController controller;
  final AppLocalizations texts;

  @override
  Widget build(BuildContext context) {
    final charge = controller.energyCharge;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => EnergyStudioScreen(controller: controller),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(.35),
              Theme.of(context).colorScheme.secondary.withOpacity(.15),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(texts.translate('energy_studio'),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(texts.translate('energy_wave_hint')),
            const SizedBox(height: 12),
            TweenAnimationBuilder<double>(
              key: ValueKey(charge),
              tween: Tween(begin: 0, end: charge),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, _) {
                return LinearProgressIndicator(value: value);
              },
            ),
            const SizedBox(height: 8),
            Text('${(charge * 100).round()}%'),
          ],
        ),
      ),
    );
  }
}

class _MissionPreviewCard extends StatelessWidget {
  const _MissionPreviewCard({
    required this.mission,
    required this.controller,
    required this.texts,
  });

  final GrowthMission mission;
  final DietController controller;
  final AppLocalizations texts;

  @override
  Widget build(BuildContext context) {
    final completion = (mission.progress / mission.target).clamp(0.0, 1.0);
    final locale = Localizations.localeOf(context).languageCode;
    final title = locale == 'ar' ? mission.titleAr : mission.titleEn;
    final description =
        locale == 'ar' ? mission.descriptionAr : mission.descriptionEn;
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(.6),
            Theme.of(context).colorScheme.secondary.withOpacity(.2),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              description,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.black87),
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: completion),
          const SizedBox(height: 4),
          Text('${mission.progress.toStringAsFixed(0)} / ${mission.target}',
              style: const TextStyle(color: Colors.black87)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () => controller.advanceGrowthMission(mission.id),
              icon: const Icon(Icons.play_arrow, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}

class _VisionPeekCard extends StatelessWidget {
  const _VisionPeekCard({required this.controller, required this.texts});

  final DietController controller;
  final AppLocalizations texts;

  @override
  Widget build(BuildContext context) {
    final entries = controller.visionEntries;
    final pinned = entries.where((element) => element.pinned).toList();
    final entry = pinned.isNotEmpty
        ? pinned.first
        : (entries.isNotEmpty ? entries.first : null);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => VisionBoardScreen(controller: controller),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [
              entry?.moodColor.withOpacity(.8) ??
                  Theme.of(context).colorScheme.primary.withOpacity(.5),
              entry?.moodColor.withOpacity(.4) ??
                  Theme.of(context).colorScheme.secondary.withOpacity(.2),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(texts.translate('vision_peek_title'),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.black)),
            const SizedBox(height: 6),
            Text(
              entry == null
                  ? texts.translate('vision_empty_state')
                  : (Localizations.localeOf(context).languageCode == 'ar'
                      ? entry.titleAr
                      : entry.titleEn),
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              texts.translate('vision_peek_hint'),
              style: const TextStyle(color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

class _SleepWindDownCard extends StatelessWidget {
  const _SleepWindDownCard({required this.controller, required this.texts});

  final DietController controller;
  final AppLocalizations texts;

  @override
  Widget build(BuildContext context) {
    final progress = controller.windDownProgress;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SleepSanctuaryScreen(controller: controller),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(texts.translate('sleep_sanctuary'),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(texts.translate('sleep_preview')),
            const SizedBox(height: 12),
            TweenAnimationBuilder<double>(
              key: ValueKey(progress),
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 400),
              builder: (context, value, _) {
                return LinearProgressIndicator(value: value);
              },
            ),
            const SizedBox(height: 8),
            Text('${(progress * 100).round()}%'),
          ],
        ),
      ),
    );
  }
}

class _FlowSpotlight extends StatelessWidget {
  const _FlowSpotlight({required this.controller, required this.texts});

  final DietController controller;
  final AppLocalizations texts;

  @override
  Widget build(BuildContext context) {
    final routine = controller.flowRoutines.first;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => FlowLabScreen(controller: controller),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(.4),
              Theme.of(context).colorScheme.secondary.withOpacity(.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(texts.translate('flow_preview'),
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(routine.localizedTitle(Localizations.localeOf(context))),
                  const SizedBox(height: 8),
                  Text('${texts.translate('flow_loops')}: ${routine.loops} · '
                      '${texts.translate('flow_tempo')}: ${routine.tempo}'),
                ],
              ),
            ),
            const Icon(Icons.all_inclusive, size: 42),
          ],
        ),
      ),
    );
  }
}

class _FocusSparkCard extends StatelessWidget {
  const _FocusSparkCard({required this.controller, required this.texts});

  final DietController controller;
  final AppLocalizations texts;

  @override
  Widget build(BuildContext context) {
    final progress = controller.focusDrills
            .map((drill) => drill.progress)
            .fold<double>(0, (sum, value) => sum + value) /
        controller.focusDrills.length;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(texts.translate('focus_progress'),
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: progress),
          const SizedBox(height: 8),
          PrimaryButton(
            label: texts.translate('focus_cta'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FocusGymScreen(controller: controller),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class _JourneySparkCard extends StatelessWidget {
  const _JourneySparkCard({required this.controller, required this.texts});

  final DietController controller;
  final AppLocalizations texts;

  @override
  Widget build(BuildContext context) {
    final latest = controller.journeyMoments.first;
    final locale = Localizations.localeOf(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [latest.moodColor.withOpacity(.8), latest.moodColor.withOpacity(.3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(texts.translate('journey_preview'),
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(latest.localizedTitle(locale),
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 4),
          Text(latest.localizedDetail(locale)),
          const SizedBox(height: 12),
          PrimaryButton(
            label: texts.translate('journey_reflections_cta'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => JourneyReflectionsScreen(controller: controller),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FinaleCard extends StatelessWidget {
  const _FinaleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 2 - 32;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        constraints: const BoxConstraints(minWidth: 160),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: Colors.black87),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeActionTile extends StatelessWidget {
  const _HomeActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 36,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(.4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Expanded(child: Text(label)),
          ],
        ),
      ),
    );
  }
}

class _FoodCard extends StatelessWidget {
  const _FoodCard({required this.item});

  final FoodItem item;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => FoodDetailScreen(item: item),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
      ),
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Theme.of(context).colorScheme.surface.withOpacity(.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: item.id,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Image.network(
                    item.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.nameEn,
                      style: Theme.of(context).textTheme.titleMedium),
                  Text('${item.calories} kcal'),
                  Text(texts.translate('add_to_diet')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _WeekChart extends StatelessWidget {
  const _WeekChart(this.values);
  final List<int> values;

  @override
  Widget build(BuildContext context) {
    final maxValue = values.reduce((a, b) => a > b ? a : b).toDouble();
    return SizedBox(
      height: 160,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: values
            .map(
              (value) => Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  height: 40 + 120 * (value / maxValue),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(.6),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
                          _HomeActionTile(
                            icon: Icons.auto_graph,
                            label: texts.translate('insights_cta'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => InsightsScreen(
                                    controller: dietController,
                                  ),
                                ),
                              );
                            },
                          ),
                          _HomeActionTile(
                            icon: Icons.shopping_bag_outlined,
                            label: texts.translate('grocery_cta'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => GroceryPlannerScreen(
                                    controller: dietController,
                                  ),
                                ),
                              );
                            },
                          ),
                          _HomeActionTile(
                            icon: Icons.refresh_rounded,
                            label: texts.translate('habit_cta'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => HabitStudioScreen(
                                    controller: dietController,
                                  ),
                                ),
                              );
                            },
                          ),
