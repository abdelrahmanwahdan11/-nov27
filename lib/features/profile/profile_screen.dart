import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../coach/coach_chat_screen.dart';
import '../community/community_challenges_screen.dart';
import '../flow/flow_lab_screen.dart';
import '../focus/focus_gym_screen.dart';
import '../grocery/grocery_planner_screen.dart';
import '../habits/habit_studio_screen.dart';
import '../insights/insights_screen.dart';
import '../journey/journey_reflections_screen.dart';
import '../recipes/recipe_lab_screen.dart';
import '../recovery/recovery_suite_screen.dart';
import '../recharge/energy_studio_screen.dart';
import '../recharge/momentum_journal_screen.dart';
import '../recharge/sleep_sanctuary_screen.dart';
import '../rewards/rewards_vault_screen.dart';
import '../rituals/ritual_builder_screen.dart';
import '../wellness/wellness_hub_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.appController,
    required this.authController,
    required this.dietController,
  });

  final AppController appController;
  final AuthController authController;
  final DietController dietController;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: appController,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: appController.primaryColor,
              child: Text(
                authController.profile?.name.substring(0, 1).toUpperCase() ??
                    texts.translate('guest'),
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              authController.profile?.name ?? texts.translate('guest'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(authController.profile?.email ?? '-'),
            const Divider(height: 32),
            SwitchListTile(
              title: Text(texts.translate('dark_mode')),
              value: appController.themeMode == ThemeMode.dark,
              onChanged: appController.toggleTheme,
            ),
            ListTile(
              title: Text(texts.translate('language')),
              trailing: DropdownButton<Locale>(
                value: appController.locale,
                items: AppLocalizations.supportedLocales
                    .map(
                      (locale) => DropdownMenuItem(
                        value: locale,
                        child: Text(locale.languageCode.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (locale) {
                  if (locale != null) appController.setLocale(locale);
                },
              ),
            ),
            Wrap(
              spacing: 12,
              children: primaryCandidates
                  .map(
                    (color) => GestureDetector(
                      onTap: () => appController.setPrimary(color),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                          border: Border.all(
                            color: appController.primaryColor == color
                                ? Colors.black
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: Text(texts.translate('wellness_hub')),
              subtitle: Text(texts.translate('wellness_settings_hint')),
              leading: const Icon(Icons.self_improvement),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WellnessHubScreen(controller: dietController),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(texts.translate('recovery_suite')),
              subtitle: Text(texts.translate('recovery_intro')),
              leading: const Icon(Icons.nightlight_round),
              trailing: const Icon(Icons.chevron_right),
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
            ListTile(
              title: Text(texts.translate('energy_studio')),
              subtitle: Text(texts.translate('energy_wave_hint')),
              leading: const Icon(Icons.bolt),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EnergyStudioScreen(controller: dietController),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(texts.translate('sleep_sanctuary')),
              subtitle: Text(texts.translate('sleep_preview')),
              leading: const Icon(Icons.nights_stay),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SleepSanctuaryScreen(controller: dietController),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(texts.translate('flow_lab')),
              subtitle: Text(texts.translate('flow_lab_subtitle')),
              leading: const Icon(Icons.all_inclusive),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => FlowLabScreen(controller: dietController),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(texts.translate('focus_gym')),
              subtitle: Text(texts.translate('focus_intro')),
              leading: const Icon(Icons.center_focus_strong),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => FocusGymScreen(controller: dietController),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(texts.translate('habit_studio')),
              subtitle: Text(texts.translate('habit_settings_hint')),
              leading: const Icon(Icons.refresh_rounded),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => HabitStudioScreen(controller: dietController),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(texts.translate('ritual_builder')),
              subtitle: Text(texts.translate('ritual_intro')),
              leading: const Icon(Icons.auto_fix_high),
              trailing: const Icon(Icons.chevron_right),
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
            ListTile(
              title: Text(texts.translate('coach_chat')),
              subtitle: Text(texts.translate('coach_intro')),
              leading: const Icon(Icons.chat),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CoachChatScreen(controller: dietController),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(texts.translate('journey_reflections')),
              subtitle: Text(texts.translate('journey_reflections_subtitle')),
              leading: const Icon(Icons.auto_awesome),
              trailing: const Icon(Icons.chevron_right),
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
            ListTile(
              title: Text(texts.translate('community_challenges')),
              subtitle: Text(texts.translate('challenges_intro')),
              leading: const Icon(Icons.flag),
              trailing: const Icon(Icons.chevron_right),
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
            ListTile(
              title: Text(texts.translate('recipe_lab')),
              subtitle: Text(texts.translate('recipe_intro')),
              leading: const Icon(Icons.blender),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RecipeLabScreen(controller: dietController),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(texts.translate('grocery_planner')),
              subtitle: Text(texts.translate('grocery_intro')),
              leading: const Icon(Icons.shopping_bag_outlined),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => GroceryPlannerScreen(controller: dietController),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(texts.translate('insights')),
              subtitle: Text(texts.translate('insights_intro')),
              leading: const Icon(Icons.auto_graph),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => InsightsScreen(controller: dietController),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(texts.translate('rewards_vault')),
              subtitle: Text(texts.translate('rewards_intro')),
              leading: const Icon(Icons.emoji_events),
              trailing: const Icon(Icons.chevron_right),
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
            ListTile(
              title: Text(texts.translate('momentum_journal')),
              subtitle: Text(texts.translate('momentum_intro')),
              leading: const Icon(Icons.timeline),
              trailing: const Icon(Icons.chevron_right),
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: authController.logout,
              child: Text(texts.translate('logout')),
            )
          ],
        );
      },
    );
  }
}
