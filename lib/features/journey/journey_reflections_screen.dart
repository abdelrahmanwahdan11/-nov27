import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';
import '../../models/wellness_models.dart';

class JourneyReflectionsScreen extends StatefulWidget {
  const JourneyReflectionsScreen({super.key, required this.controller});

  final DietController controller;

  @override
  State<JourneyReflectionsScreen> createState() =>
      _JourneyReflectionsScreenState();
}

class _JourneyReflectionsScreenState extends State<JourneyReflectionsScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(texts.translate('journey_reflections')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openComposer(texts),
        icon: const Icon(Icons.brightness_5),
        label: Text(texts.translate('journey_log')),
      ),
      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          final moments = widget.controller.journeyMoments;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(.35),
                      Theme.of(context).colorScheme.secondary.withOpacity(.25),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(texts.translate('journey_reflections_subtitle'),
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(texts.translate('journey_preview')),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      label: texts.translate('journey_log'),
                      onPressed: () => _openComposer(texts),
                    )
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: .2),
              const SizedBox(height: 20),
              if (moments.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color:
                        Theme.of(context).colorScheme.surfaceVariant.withOpacity(.4),
                  ),
                  child: Text(texts.translate('journey_empty')),
                )
              else
                ...moments.map(
                  (moment) => _JourneyMomentTile(moment: moment)
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: .1),
                ),
            ],
          );
        },
      ),
    );
  }

  void _openComposer(AppLocalizations texts) {
    _textController.clear();
    double moodValue = .5;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(texts.translate('journey_log'),
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _textController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: texts.translate('journey_placeholder'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(texts.translate('spark_slider')),
                  Slider(
                    value: moodValue,
                    onChanged: (value) => setSheetState(() => moodValue = value),
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label: texts.translate('journey_log'),
                    onPressed: () {
                      final text = _textController.text.trim();
                      if (text.isEmpty) return;
                      final color = Color.lerp(
                        Colors.amber,
                        Colors.deepPurpleAccent,
                        moodValue,
                      );
                      widget.controller.addJourneyMoment(
                        titleEn: texts.translate('journey_manual_title'),
                        titleAr: texts.translate('journey_manual_title'),
                        detailEn: text,
                        detailAr: text,
                        moodColor: color,
                      );
                      Navigator.of(sheetContext).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(texts.translate('journey_saved'))),
                      );
                    },
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _JourneyMomentTile extends StatelessWidget {
  const _JourneyMomentTile({required this.moment});

  final JourneyMoment moment;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final time = TimeOfDay.fromDateTime(moment.timestamp);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [moment.moodColor.withOpacity(.8), moment.moodColor.withOpacity(.4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  moment.localizedTitle(locale),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text('${time.format(context)}'),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            moment.localizedDetail(locale),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            texts.translate('journey_cta'),
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
