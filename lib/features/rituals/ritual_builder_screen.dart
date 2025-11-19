import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';
import '../../models/wellness_models.dart';

class RitualBuilderScreen extends StatefulWidget {
  const RitualBuilderScreen({super.key, required this.controller});

  final DietController controller;

  @override
  State<RitualBuilderScreen> createState() => _RitualBuilderScreenState();
}

class _RitualBuilderScreenState extends State<RitualBuilderScreen> {
  final TextEditingController _cueController = TextEditingController();
  String? _selectedRitualId;

  RitualBlueprint get _activeRitual {
    final list = widget.controller.ritualBlueprints;
    if (list.isEmpty) {
      throw Exception('No rituals');
    }
    return list.firstWhere(
      (ritual) => ritual.id == _selectedRitualId,
      orElse: () => list.first,
    );
  }

  @override
  void dispose() {
    _cueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final rituals = widget.controller.ritualBlueprints;
        final active = _activeRitual;
        return Scaffold(
          appBar: AppBar(
            title: Text(texts.translate('ritual_builder')),
          ),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                texts.translate('ritual_intro'),
                style: Theme.of(context).textTheme.bodyLarge,
              ).animate().fadeIn(duration: 400.ms).slideY(begin: .2),
              const SizedBox(height: 12),
              DropdownButton<String>(
                value: active.id,
                items: rituals
                    .map(
                      (ritual) => DropdownMenuItem(
                        value: ritual.id,
                        child: Text(ritual
                            .localizedTitle(Localizations.localeOf(context))),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedRitualId = value);
                },
              ),
              const SizedBox(height: 12),
              _RitualCard(
                ritual: active,
                onFocusChange: (value) =>
                    widget.controller.updateRitualFocus(active.id, value),
                onStepToggle: (index) =>
                    widget.controller.toggleRitualStep(active.id, index),
              ),
              const SizedBox(height: 24),
              Text(texts.translate('ritual_steps'),
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ...List.generate(active.steps.length, (index) {
                final step = active.steps[index];
                return ListTile(
                  key: ValueKey(step.labelEn + index.toString()),
                  leading: Checkbox(
                    value: step.completed,
                    onChanged: (_) =>
                        widget.controller.toggleRitualStep(active.id, index),
                  ),
                  title: Text(step
                      .localizedLabel(Localizations.localeOf(context))),
                ).animate(delay: (index * 80).ms).fadeIn().slideX(begin: .2);
              }),
              const SizedBox(height: 12),
              TextField(
                controller: _cueController,
                decoration: InputDecoration(
                  labelText: texts.translate('ritual_add_step'),
                  hintText: texts.translate('ritual_placeholder'),
                ),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 12),
              PrimaryButton(
                label: texts.translate('ritual_add_step'),
                onPressed: () {
                  widget.controller
                      .addRitualStep(active.id, _cueController.text.trim());
                  _cueController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(texts.translate('ritual_custom_added')),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RitualCard extends StatelessWidget {
  const _RitualCard({
    required this.ritual,
    required this.onFocusChange,
    required this.onStepToggle,
  });

  final RitualBlueprint ritual;
  final ValueChanged<double> onFocusChange;
  final ValueChanged<int> onStepToggle;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final texts = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
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
          Text(
            ritual.localizedTitle(locale),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(ritual.localizedDescription(locale)),
          const SizedBox(height: 20),
          Text(texts.translate('ritual_focus_label')),
          Slider(
            value: ritual.focus,
            onChanged: onFocusChange,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: List.generate(ritual.steps.length, (index) {
              final step = ritual.steps[index];
              return FilterChip(
                label: Text(step.localizedLabel(locale)),
                selected: step.completed,
                onSelected: (_) => onStepToggle(index),
              );
            }),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: .2);
  }
}
