import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/section_title.dart';
import '../../models/wellness_models.dart';

class MacroForgeScreen extends StatefulWidget {
  const MacroForgeScreen({super.key, required this.controller});

  final DietController controller;

  @override
  State<MacroForgeScreen> createState() => _MacroForgeScreenState();
}

class _MacroForgeScreenState extends State<MacroForgeScreen> {
  late String _activeId;

  @override
  void initState() {
    super.initState();
    _activeId = widget.controller.highlightedBlueprint.id;
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(texts.translate('macro_forge')),
        backgroundColor: Colors.transparent,
      ),
      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          final blueprints = widget.controller.macroBlueprints;
          final MacroBlueprint blueprint = blueprints.firstWhere(
            (element) => element.id == _activeId,
            orElse: () => widget.controller.highlightedBlueprint,
          );
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(.35),
                      Theme.of(context).colorScheme.secondary.withOpacity(.12),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blueprint.localizedTitle(locale),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(blueprint.localizedDescription(locale)),
                    const SizedBox(height: 16),
                    Text(texts.translate('macro_focus')),
                    Slider(
                      min: 0,
                      max: 1,
                      value: blueprint.glow,
                      onChanged: (value) =>
                          widget.controller.updateMacroGlow(blueprint.id, value),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('${(blueprint.glow * 100).round()}%'),
                    )
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: .2),
              const SizedBox(height: 24),
              SectionTitle(title: texts.translate('macro_templates')),
              const SizedBox(height: 12),
              Column(
                children: blueprints
                    .map(
                      (item) => GestureDetector(
                        onTap: () => setState(() => _activeId = item.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            color: item.id == blueprint.id
                                ? Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant
                                    .withOpacity(.6)
                                : Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant
                                    .withOpacity(.3),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.localizedTitle(locale),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    const SizedBox(height: 4),
                                    Text(item.localizedDescription(locale)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                item.id == blueprint.id
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              SectionTitle(title: texts.translate('macro_adjust')),
              const SizedBox(height: 8),
              _MacroDial(
                label: texts.translate('protein_label'),
                value: blueprint.protein,
                color: Colors.pinkAccent,
                onChanged: (value) => widget.controller.updateMacroTargets(
                  blueprint.id,
                  protein: value,
                ),
              ),
              _MacroDial(
                label: texts.translate('carbs_label'),
                value: blueprint.carbs,
                color: Colors.lightBlueAccent,
                onChanged: (value) => widget.controller.updateMacroTargets(
                  blueprint.id,
                  carbs: value,
                ),
              ),
              _MacroDial(
                label: texts.translate('fats_label'),
                value: blueprint.fats,
                color: Colors.amber,
                onChanged: (value) => widget.controller.updateMacroTargets(
                  blueprint.id,
                  fats: value,
                ),
              ),
              _MacroDial(
                label: texts.translate('micros_label'),
                value: blueprint.micros,
                color: Colors.greenAccent,
                max: 30,
                onChanged: (value) => widget.controller.updateMacroTargets(
                  blueprint.id,
                  micros: value,
                ),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: texts.translate('macro_apply_cta'),
                onPressed: () => widget.controller.cycleMacroBlueprint(1),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MacroDial extends StatelessWidget {
  const _MacroDial({
    required this.label,
    required this.value,
    required this.color,
    required this.onChanged,
    this.max = 80,
  });

  final String label;
  final int value;
  final Color color;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('$value g'),
          ],
        ),
        Slider(
          min: 0,
          max: max.toDouble(),
          activeColor: color,
          value: value.toDouble(),
          onChanged: (val) => onChanged(val.round()),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms).slideY(begin: .1);
  }
}
