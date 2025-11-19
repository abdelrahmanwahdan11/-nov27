import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';
import '../../models/wellness_models.dart';

class SerenityCircuitScreen extends StatefulWidget {
  const SerenityCircuitScreen({super.key, required this.controller});

  final DietController controller;

  @override
  State<SerenityCircuitScreen> createState() => _SerenityCircuitScreenState();
}

class _SerenityCircuitScreenState extends State<SerenityCircuitScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: .85,
      initialPage: widget.controller.activeSerenityIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(texts.translate('serenity_circuit')),
        actions: [
          IconButton(
            onPressed: widget.controller.cycleSerenityModule,
            icon: const Icon(Icons.autorenew),
            tooltip: texts.translate('cycle_serenity'),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          final locale = Localizations.localeOf(context);
          final modules = widget.controller.serenityModules;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  texts.translate('serenity_hint'),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: widget.controller.setActiveSerenityIndex,
                  itemCount: modules.length,
                  itemBuilder: (context, index) {
                    final module = modules[index];
                    final bool active =
                        index == widget.controller.activeSerenityIndex;
                    return AnimatedScale(
                      scale: active ? 1 : .94,
                      duration: const Duration(milliseconds: 300),
                      child: _SerenityCard(
                        module: module,
                        locale: locale,
                        controller: widget.controller,
                        active: active,
                        texts: texts,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: PrimaryButton(
                  label: texts.translate('serenity_cta'),
                  onPressed: widget.controller.cycleSerenityModule,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class _SerenityCard extends StatelessWidget {
  const _SerenityCard({
    required this.module,
    required this.locale,
    required this.controller,
    required this.active,
    required this.texts,
  });

  final SerenityModule module;
  final Locale locale;
  final DietController controller;
  final bool active;
  final AppLocalizations texts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(.8),
            theme.colorScheme.secondary.withOpacity(.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(.2),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(active ? Icons.blur_on : Icons.blur_linear),
              const SizedBox(width: 8),
              Text(
                module.localizedTitle(locale),
                style: theme.textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(module.localizedMantra(locale)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: module.cues
                .map(
                  (cue) => Chip(
                    backgroundColor:
                        theme.colorScheme.surfaceVariant.withOpacity(.4),
                    label: Text(cue),
                  ),
                )
                .toList(),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: .2),
          const Spacer(),
          Text('${texts.translate('serenity_depth')} ${(module.depth * 100).toInt()}%'),
          Slider(
            value: module.depth,
            onChanged: (value) =>
                controller.updateSerenityDepth(module.id, value),
          ),
          Row(
            children: [
              Text('${texts.translate('serenity_breaths')}: ${module.breaths}'),
              const Spacer(),
              IconButton(
                onPressed: () => controller.adjustSerenityBreaths(module.id, -1),
                icon: const Icon(Icons.remove_circle_outline),
              ),
              IconButton(
                onPressed: () => controller.adjustSerenityBreaths(module.id, 1),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          )
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: .2);
  }
}
