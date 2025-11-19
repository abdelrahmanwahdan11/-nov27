import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.appController,
    required this.authController,
  });

  final AppController appController;
  final AuthController authController;

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
