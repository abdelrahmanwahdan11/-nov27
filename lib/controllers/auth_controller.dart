import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._prefs);

  final SharedPreferences _prefs;
  bool _loggedIn = false;
  bool _guestMode = false;
  UserProfile? _profile;

  bool get loggedIn => _loggedIn;
  bool get guestMode => _guestMode;
  UserProfile? get profile => _profile;

  Future<void> load() async {
    _loggedIn = _prefs.getBool('loggedIn') ?? false;
    _guestMode = _prefs.getBool('guest') ?? false;
    _profile = UserProfile.fromPrefsString(_prefs.getString('profile'));
  }

  bool login(String email, String password) {
    final valid = _validateEmail(email) && password.length >= 6;
    if (valid) {
      _loggedIn = true;
      _guestMode = false;
      _prefs
        ..setBool('loggedIn', true)
        ..setBool('guest', false);
      notifyListeners();
    }
    return valid;
  }

  bool signup(UserProfile profile) {
    _profile = profile;
    _loggedIn = true;
    _guestMode = false;
    _prefs
      ..setString('profile', profile.toPrefsString())
      ..setBool('loggedIn', true)
      ..setBool('guest', false);
    notifyListeners();
    return true;
  }

  void continueAsGuest() {
    _guestMode = true;
    _loggedIn = true;
    _prefs
      ..setBool('guest', true)
      ..setBool('loggedIn', true);
    notifyListeners();
  }

  void logout() {
    _loggedIn = false;
    _guestMode = false;
    _prefs
      ..setBool('guest', false)
      ..setBool('loggedIn', false);
    notifyListeners();
  }

  bool _validateEmail(String email) =>
      email.contains('@') && email.contains('.');
}
