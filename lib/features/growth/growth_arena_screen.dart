import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/section_title.dart';
import '../rhythm/rhythm_board_screen.dart';

class GrowthArenaScreen extends StatelessWidget {
  const GrowthArenaScreen({super.key, required this.controller});

  final DietController controller;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(texts.translate('growth_arena_title')),
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final missions = controller.growthMissions;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                texts.translate('growth_arena_caption'),
                style: Theme.of(context).textTheme.titleMedium,
              ).animate().fadeIn(duration: 400.ms).slideY(begin: .2),
              const SizedBox(height: 20),
              SectionTitle(
                title: texts.translate('growth_missions_section'),
                action: TextButton(
                  onPressed: controller.resetGrowthMissions,
                  child: Text(texts.translate('reset_button')),
                ),
              ),
              const SizedBox(height: 12),
              ...missions.map(
                (mission) => _MissionCard(
                  controller: controller,
                  missionId: mission.id,
                  texts: texts,
                ).animate().fadeIn(duration: 300.ms).slideY(begin: .1),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(.4),
                      Theme.of(context).colorScheme.secondary.withOpacity(.2),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(texts.translate('growth_boost_cta'),
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Text(texts.translate('growth_boost_hint')),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      label: texts.translate('open_rhythm_board'),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => RhythmBoardScreen(
                              controller: controller,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: .2),
            ],
          );
        },
      ),
    );
  }
}

class _MissionCard extends StatelessWidget {
  const _MissionCard({
    required this.controller,
    required this.missionId,
    required this.texts,
  });

  final DietController controller;
  final String missionId;
  final AppLocalizations texts;

  @override
  Widget build(BuildContext context) {
    final mission =
        controller.growthMissions.firstWhere((element) => element.id == missionId);
    final completion = (mission.progress / mission.target).clamp(0.0, 1.0);
    final locale = Localizations.localeOf(context).languageCode;
    final title = locale == 'ar' ? mission.titleAr : mission.titleEn;
    final description =
        locale == 'ar' ? mission.descriptionAr : mission.descriptionEn;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(.15),
            blurRadius: 12,
          ),
        ],
        gradient: LinearGradient(
          colors: mission.highlighted
              ? [
                  Theme.of(context).colorScheme.primary.withOpacity(.7),
                  Theme.of(context).colorScheme.secondary.withOpacity(.2),
                ]
              : [
                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(.4),
                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(.2),
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
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: mission.highlighted ? Colors.black : null),
                ),
              ),
              IconButton(
                onPressed: () => controller.toggleMissionHighlight(mission.id),
                icon: Icon(
                  mission.highlighted ? Icons.star : Icons.star_border,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: completion),
            duration: const Duration(milliseconds: 400),
            builder: (context, value, _) => LinearProgressIndicator(value: value),
          ),
          const SizedBox(height: 4),
          Text('${mission.progress.toStringAsFixed(0)} / ${mission.target}'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: texts.translate('advance_button'),
                  onPressed: () => controller.advanceGrowthMission(mission.id),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () => controller.advanceGrowthMission(
                    mission.id,
                    delta: mission.target.toDouble()),
                icon: const Icon(Icons.done_all),
              )
            ],
          )
        ],
      ),
    );
  }
}
