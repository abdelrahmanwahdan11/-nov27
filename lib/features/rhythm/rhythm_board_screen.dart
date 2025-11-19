import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';
import '../vision/vision_board_screen.dart';

class RhythmBoardScreen extends StatelessWidget {
  const RhythmBoardScreen({super.key, required this.controller});

  final DietController controller;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(texts.translate('rhythm_board_title')),
        actions: [
          IconButton(
            onPressed: controller.shuffleRhythms,
            icon: const Icon(Icons.shuffle),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final rhythms = controller.rhythmCards;
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: rhythms.length,
            itemBuilder: (context, index) {
              final rhythm = rhythms[index];
              final subtitle =
                  Localizations.localeOf(context).languageCode == 'ar'
                      ? rhythm.subtitleAr
                      : rhythm.subtitleEn;
              final title =
                  Localizations.localeOf(context).languageCode == 'ar'
                      ? rhythm.titleAr
                      : rhythm.titleEn;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color:
                      Theme.of(context).colorScheme.surfaceVariant.withOpacity(.4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(title,
                              style: Theme.of(context).textTheme.titleMedium),
                        ),
                        IconButton(
                          onPressed: () => controller.toggleRhythmExpansion(rhythm.id),
                          icon: Icon(rhythm.expanded
                              ? Icons.expand_less
                              : Icons.expand_more),
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle),
                    const SizedBox(height: 12),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: rhythm.focus),
                      duration: const Duration(milliseconds: 400),
                      builder: (context, value, _) => LinearProgressIndicator(
                        value: value,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                        '${(rhythm.focus * 100).round()}% ${texts.translate('focus_progress')}'),
                    if (rhythm.expanded) ...[
                      const SizedBox(height: 12),
                      Text('${texts.translate('bpm_label')}: ${rhythm.bpm}'),
                      Slider(
                        value: rhythm.bpm.toDouble(),
                        min: 40,
                        max: 120,
                        onChanged: (value) =>
                            controller.setRhythmBpm(rhythm.id, value.round()),
                      ),
                      Text(texts.translate('focus_slider_label')),
                      Slider(
                        value: rhythm.focus,
                        onChanged: (value) =>
                            controller.setRhythmFocus(rhythm.id, value),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              label: texts.translate('boost_focus'),
                              onPressed: () => controller.tuneRhythm(rhythm.id,
                                  bpmDelta: 2, focusDelta: .08),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text('${texts.translate('waves_label')}: ${rhythm.waves}'),
                        ],
                      )
                    ]
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms).slideY(begin: .1);
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: PrimaryButton(
          label: texts.translate('open_vision_board'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => VisionBoardScreen(
                  controller: controller,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
