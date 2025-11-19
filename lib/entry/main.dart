import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/app_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/diet_controller.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final appController = AppController(prefs);
  final authController = AuthController(prefs);
  final dietController = DietController();
  await appController.load();
  await authController.load();

  runApp(
    AppEntry(
      appController: appController,
      authController: authController,
      dietController: dietController,
    ),
  );
}
