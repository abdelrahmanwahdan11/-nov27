import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';

class DailyCheckInScreen extends StatefulWidget {
  const DailyCheckInScreen({super.key, required this.controller});

  final DietController controller;

  @override
  State<DailyCheckInScreen> createState() => _DailyCheckInScreenState();
}

class _DailyCheckInScreenState extends State<DailyCheckInScreen> {
  final TextEditingController _noteController = TextEditingController();
  double _hydrationToLog = 350;
  double _energyLevel = .6;
  int _moodLevel = 3;

  @override
  void initState() {
    super.initState();
    _moodLevel = widget.controller.moodLevel;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(texts.translate('daily_check_in')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _AnimatedSection(
            delay: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(texts.translate('log_hydration'),
                    style: Theme.of(context).textTheme.titleMedium),
                Slider(
                  value: _hydrationToLog,
                  min: 150,
                  max: 600,
                  divisions: 9,
                  label: '${_hydrationToLog.toStringAsFixed(0)} ml',
                  onChanged: (value) => setState(() => _hydrationToLog = value),
                ),
                Text('${_hydrationToLog.toStringAsFixed(0)} ml'),
              ],
            ),
          ),
          _AnimatedSection(
            delay: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(texts.translate('energy')),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: _energyLevel),
                  duration: const Duration(milliseconds: 400),
                  builder: (context, value, child) {
                    return LinearProgressIndicator(value: value);
                  },
                ),
                Slider(
                  value: _energyLevel,
                  onChanged: (value) => setState(() => _energyLevel = value),
                ),
              ],
            ),
          ),
          _AnimatedSection(
            delay: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(texts.translate('mood')),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: List.generate(5, (index) {
                    final selected = _moodLevel == index + 1;
                    return ChoiceChip(
                      label: Text('${index + 1}'),
                      selected: selected,
                      onSelected: (_) => setState(() => _moodLevel = index + 1),
                    );
                  }),
                ),
              ],
            ),
          ),
          _AnimatedSection(
            delay: 450,
            child: TextField(
              controller: _noteController,
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: texts.translate('reflection'),
                hintText: texts.translate('reflection_placeholder'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: texts.translate('save_check_in'),
            onPressed: () {
              widget.controller.logHydration(_hydrationToLog);
              widget.controller.updateMood(_moodLevel);
              widget.controller.addReflection(_noteController.text);
              SystemSound.play(SystemSoundType.click);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(texts.translate('check_in_saved'))),
              );
              Navigator.of(context).pop();
            },
          ).animate().scale(delay: 200.ms),
        ],
      ),
    );
  }
}

class _AnimatedSection extends StatelessWidget {
  const _AnimatedSection({required this.child, required this.delay});

  final Widget child;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return child
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 400.ms)
        .slideY(begin: .1);
  }
}
