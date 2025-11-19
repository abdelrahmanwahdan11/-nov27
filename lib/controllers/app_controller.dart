import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/theme/app_theme.dart';

class AppController extends ChangeNotifier {
  AppController(this._prefs);

  final SharedPreferences _prefs;

  ThemeMode _themeMode = ThemeMode.light;
  Color _primaryColor = primaryCandidates.first;
  Locale _locale = const Locale('en');
  int _currentIndex = 0;
  bool _onboarded = false;

  ThemeMode get themeMode => _themeMode;
  Color get primaryColor => _primaryColor;
  Locale get locale => _locale;
  int get currentIndex => _currentIndex;
  bool get onboarded => _onboarded;

  Future<void> load() async {
    _themeMode = _prefs.getBool('darkMode') == true
        ? ThemeMode.dark
        : ThemeMode.light;
    final primaryValue = _prefs.getInt('primaryColor');
    if (primaryValue != null) {
      _primaryColor = Color(primaryValue);
    }
    final lang = _prefs.getString('locale');
    if (lang != null) {
      _locale = Locale(lang);
    }
    _onboarded = _prefs.getBool('onboarded') ?? false;
  }

  void setOnboarded() {
    _onboarded = true;
    _prefs.setBool('onboarded', true);
    notifyListeners();
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _prefs.setBool('darkMode', isDark);
    notifyListeners();
  }

  void setPrimary(Color color) {
    _primaryColor = color;
    _prefs.setInt('primaryColor', color.value);
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    _prefs.setString('locale', locale.languageCode);
    notifyListeners();
  }

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
