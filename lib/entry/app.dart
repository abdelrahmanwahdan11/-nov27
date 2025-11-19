import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../controllers/app_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/diet_controller.dart';
import '../core/localization/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/auth_flow.dart';
import '../features/home/main_shell.dart';
import '../features/onboarding/onboarding_story_screen.dart';

class AppEntry extends StatefulWidget {
  const AppEntry({
    super.key,
    required this.appController,
    required this.authController,
    required this.dietController,
  });

  final AppController appController;
  final AuthController authController;
  final DietController dietController;

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  @override
  void initState() {
    super.initState();
    widget.dietController.init();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        widget.appController,
        widget.authController,
      ]),
      builder: (context, _) {
        final themeMode = widget.appController.themeMode;
        final primary = widget.appController.primaryColor;
        return ControllerScope(
          app: widget.appController,
          auth: widget.authController,
          diet: widget.dietController,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Neon Diet',
            theme: AppTheme.light(primary),
            darkTheme: AppTheme.dark(primary),
            themeMode: themeMode,
            locale: widget.appController.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: _buildHome(),
          ),
        );
      },
    );
  }

  Widget _buildHome() {
    if (!widget.appController.onboarded) {
      return OnboardingStoryScreen(appController: widget.appController);
    }
    if (!widget.authController.loggedIn) {
      return AuthFlow(controller: widget.authController);
    }
    return MainShell(
      appController: widget.appController,
      authController: widget.authController,
      dietController: widget.dietController,
    );
  }
}

class ControllerScope extends InheritedWidget {
  const ControllerScope({
    super.key,
    required super.child,
    required this.app,
    required this.auth,
    required this.diet,
  });

  final AppController app;
  final AuthController auth;
  final DietController diet;

  static ControllerScope of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ControllerScope>()!;
  }

  @override
  bool updateShouldNotify(ControllerScope oldWidget) =>
      app != oldWidget.app || auth != oldWidget.auth || diet != oldWidget.diet;
}
