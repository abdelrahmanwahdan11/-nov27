import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../catalog/catalog_screen.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../progress/progress_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.appController,
    required this.authController,
    required this.dietController,
  });

  final AppController appController;
  final AuthController authController;
  final DietController dietController;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      HomeScreen(dietController: widget.dietController),
      CatalogScreen(controller: widget.dietController),
      ProgressScreen(controller: widget.dietController),
      ProfileScreen(
        appController: widget.appController,
        authController: widget.authController,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.appController,
      builder: (context, _) {
        final texts = AppLocalizations.of(context);
        return Scaffold(
          body: IndexedStack(
            index: widget.appController.currentIndex,
            children: pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: widget.appController.currentIndex,
            onTap: widget.appController.setIndex,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                label: texts.translate('home'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.list_alt),
                label: texts.translate('catalog'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.timeline_outlined),
                label: texts.translate('progress'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                label: texts.translate('profile'),
              ),
            ],
          ),
        );
      },
    );
  }
}
