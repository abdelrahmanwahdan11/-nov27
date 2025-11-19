import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../models/wellness_models.dart';

class RewardsVaultScreen extends StatelessWidget {
  const RewardsVaultScreen({super.key, required this.controller});

  final DietController controller;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final rewards = controller.rewardBadges;
        final unlocked = controller.unlockedRewards;
        final totalPoints = controller.totalVaultPoints;
        final progress = rewards.isEmpty
            ? 0.0
            : unlocked / rewards.length.clamp(1, rewards.length);
        return Scaffold(
          appBar: AppBar(
            title: Text(texts.translate('rewards_vault')),
          ),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                texts.translate('rewards_intro'),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              Container(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${texts.translate('rewards_points')}: $totalPoints'),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: progress),
                    const SizedBox(height: 4),
                    Text(
                      '${texts.translate('rewards_unlock_hint')} '
                      '$unlocked/${rewards.length}',
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: .2),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: rewards
                    .map(
                      (badge) => _RewardTile(
                        badge: badge,
                        onTap: () {
                          controller.unlockReward(badge.id);
                          if (!badge.unlocked) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  texts.translate('rewards_unlocked_toast'),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RewardTile extends StatelessWidget {
  const _RewardTile({required this.badge, required this.onTap});

  final RewardBadge badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: badge.unlocked
              ? Theme.of(context).colorScheme.primary.withOpacity(.4)
              : Theme.of(context).colorScheme.surfaceVariant.withOpacity(.4),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(.2),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              badge.unlocked ? Icons.emoji_events : Icons.lock_outline,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              badge.localizedTitle(locale),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(badge.localizedDescription(locale)),
            const Spacer(),
            Text('${badge.points} pts'),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms).slideY(begin: .2),
    );
  }
}
