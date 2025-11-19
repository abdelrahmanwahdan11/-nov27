import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/section_title.dart';
import '../../models/community_models.dart';
import '../recipes/recipe_lab_screen.dart';

class CommunityChallengesScreen extends StatelessWidget {
  const CommunityChallengesScreen({super.key, required this.controller});

  final DietController controller;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: true,
                  backgroundColor: Colors.transparent,
                  title: Text(texts.translate('community_challenges')),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.blender_outlined),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => RecipeLabScreen(controller: controller),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          texts.translate('challenges_intro'),
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                            .animate()
                            .fadeIn(duration: 500.ms)
                            .slideY(begin: .2),
                        const SizedBox(height: 16),
                        ...controller.challenges.asMap().entries.map(
                          (entry) => _ChallengeCard(
                            challenge: entry.value,
                            controller: controller,
                            texts: texts,
                          )
                              .animate(
                                  delay: Duration(milliseconds: 120 * entry.key))
                              .fadeIn(),
                        ),
                        const SizedBox(height: 32),
                        SectionTitle(title: texts.translate('recipe_lab')),
                        const SizedBox(height: 12),
                        _RecipePreview(controller: controller),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({
    required this.challenge,
    required this.controller,
    required this.texts,
  });

  final ChallengeRoutine challenge;
  final DietController controller;
  final AppLocalizations texts;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(.45),
            Theme.of(context).colorScheme.secondary.withOpacity(.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  challenge.localizedTitle(locale),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: challenge.joined
                    ? const Icon(Icons.star, color: Colors.amber)
                    : const Icon(Icons.star_border),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(challenge.localizedDescription(locale)),
          const SizedBox(height: 12),
          Text('${texts.translate('challenge_progress')} '
              '${challenge.completedDays}/${challenge.days}'),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(value: challenge.progress),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: challenge.joined
                      ? texts.translate('challenge_joined')
                      : texts.translate('join_challenge'),
                  onPressed: () => controller.toggleChallenge(challenge.id),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => controller.incrementChallengeDay(challenge.id),
                child: Text(texts.translate('challenge_day_done')),
              )
            ],
          )
        ],
      ),
    );
  }
}

class _RecipePreview extends StatelessWidget {
  const _RecipePreview({required this.controller});

  final DietController controller;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.recipeIdeas.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final recipe = controller.recipeIdeas[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RecipeLabScreen(controller: controller),
                ),
              );
            },
            child: Container(
              width: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(
                  image: NetworkImage(recipe.image),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(.6), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.localizedTitle(locale),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white),
                    ),
                    const Spacer(),
                    Text('${recipe.calories} kcal',
                        style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    Text(texts.translate('recipe_preview_cta'),
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ).animate(delay: (index * 120).ms).fadeIn().slideX(begin: .2);
        },
      ),
    );
  }
}
