import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../controllers/app_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/primary_button.dart';
import '../../entry/app.dart';
import '../../models/user_profile.dart';

class AuthFlow extends StatefulWidget {
  const AuthFlow({super.key, required this.controller});

  final AuthController controller;

  @override
  State<AuthFlow> createState() => _AuthFlowState();
}

class _AuthFlowState extends State<AuthFlow> {
  bool showLogin = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: showLogin
          ? LoginScreen(
              key: const ValueKey('login'),
              controller: widget.controller,
              onCreate: () => setState(() => showLogin = false),
            )
          : SignUpScreen(
              key: const ValueKey('signup'),
              controller: widget.controller,
              onBack: () => setState(() => showLogin = true),
            ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.controller,
    required this.onCreate,
  });

  final AuthController controller;
  final VoidCallback onCreate;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool obscure = true;
  bool shake = false;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final app = ControllerScope.of(context).app;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 400));
          email.clear();
          password.clear();
          setState(() {});
        },
        child: Container(
          decoration: gradientBackground(app.primaryColor),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: app.themeMode == ThemeMode.dark,
                      onChanged: app.toggleTheme,
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<Locale>(
                      value: app.locale,
                      underline: const SizedBox(),
                      items: AppLocalizations.supportedLocales
                          .map(
                            (locale) => DropdownMenuItem(
                              value: locale,
                              child: Text(locale.languageCode.toUpperCase()),
                            ),
                          )
                          .toList(),
                      onChanged: (locale) {
                        if (locale != null) app.setLocale(locale);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 800),
                child: Text(
                  texts.translate('login'),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 24),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                        labelText: texts.translate('email'),
                        hintText: texts.translate('email_hint'),
                      ),
                      validator: (value) =>
                          value != null && value.contains('@')
                              ? null
                              : texts.translate('invalid_email'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: password,
                      obscureText: obscure,
                      decoration: InputDecoration(
                        labelText: texts.translate('password'),
                        suffixIcon: IconButton(
                          icon: Icon(
                              obscure ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => obscure = !obscure),
                        ),
                      ),
                      validator: (value) =>
                          value != null && value.length >= 6
                              ? null
                              : texts.translate('short_password'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ForgotPasswordScreen(
                        controller: widget.controller,
                      ),
                    ),
                  ),
                  child: Text(texts.translate('forgot_password')),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.translationValues(shake ? -10 : 0, 0, 0),
                child: PrimaryButton(
                  label: texts.translate('login'),
                  onPressed: () {
                    final valid = formKey.currentState?.validate() ?? false;
                    if (valid) {
                      final ok = widget.controller
                          .login(email.text.trim(), password.text.trim());
                      if (!ok) {
                        setState(() => shake = true);
                        Future.delayed(
                          const Duration(milliseconds: 200),
                          () => setState(() => shake = false),
                        );
                      }
                    } else {
                      setState(() => shake = true);
                      Future.delayed(
                        const Duration(milliseconds: 200),
                        () => setState(() => shake = false),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  widget.controller.continueAsGuest();
                  SystemSound.play(SystemSoundType.click);
                },
                child: Text(texts.translate('guest_login')),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: widget.onCreate,
                child: Text(texts.translate('signup')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
    required this.controller,
    required this.onBack,
  });

  final AuthController controller;
  final VoidCallback onBack;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers = {
    'name': TextEditingController(),
    'email': TextEditingController(),
    'password': TextEditingController(),
    'confirm': TextEditingController(),
    'goal': TextEditingController(),
  };
  double strength = 0;
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        title: Text(texts.translate('signup')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: controllers['name'],
                  decoration:
                      InputDecoration(labelText: texts.translate('profile')),
                  validator: (value) =>
                      value != null && value.isNotEmpty ? null : 'required',
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: controllers['email'],
                  decoration: InputDecoration(labelText: texts.translate('email')),
                  validator: (value) =>
                      value != null && value.contains('@')
                          ? null
                          : texts.translate('invalid_email'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: controllers['password'],
                  obscureText: obscure,
                  onChanged: (value) {
                    setState(() {
                      strength = _computeStrength(value);
                    });
                  },
                  decoration: InputDecoration(
                    labelText: texts.translate('password'),
                    suffixIcon: IconButton(
                      icon: Icon(
                          obscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => obscure = !obscure),
                    ),
                  ),
                  validator: (value) =>
                      value != null && value.length >= 8
                          ? null
                          : texts.translate('short_password'),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: strength),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(texts.translate('password_rules')),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: controllers['confirm'],
                  obscureText: obscure,
                  decoration: InputDecoration(
                      labelText: texts.translate('confirm_password')),
                  validator: (value) =>
                      value == controllers['password']!.text
                          ? null
                          : texts.translate('mismatch_password'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: controllers['goal'],
                  decoration: InputDecoration(
                      labelText: texts.translate('weekly_goal')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween(begin: 0.95, end: 1),
            builder: (context, value, child) => Transform.scale(
              scale: value,
              child: child,
            ),
            child: PrimaryButton(
              label: texts.translate('signup'),
              onPressed: () {
                final valid = formKey.currentState?.validate() ?? false;
                if (valid) {
                  widget.controller.signup(
                    UserProfile(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: controllers['name']!.text,
                      email: controllers['email']!.text,
                      age: 24,
                      heightCm: 170,
                      weightKg: 60,
                      gender: 'other',
                      goal: controllers['goal']!.text,
                      fitnessLevel: 'starter',
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(texts.translate('success_signup'))),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  double _computeStrength(String value) {
    double score = min(value.length / 12, 1);
    if (value.contains(RegExp('[0-9]'))) score += 0.2;
    if (value.contains(RegExp('[!@#%&]'))) score += 0.2;
    return score.clamp(0, 1);
  }
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key, required this.controller});

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final email = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text(texts.translate('forgot_password'))),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(labelText: texts.translate('email')),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: texts.translate('send_link'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(texts.translate('fake_reset'))),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
