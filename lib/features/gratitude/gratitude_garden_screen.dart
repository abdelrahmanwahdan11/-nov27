import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';
import '../../models/wellness_models.dart';

class GratitudeGardenScreen extends StatefulWidget {
  const GratitudeGardenScreen({super.key, required this.controller});

  final DietController controller;

  @override
  State<GratitudeGardenScreen> createState() => _GratitudeGardenScreenState();
}

class _GratitudeGardenScreenState extends State<GratitudeGardenScreen> {
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
        title: Text(texts.translate('gratitude_garden')),
      ),
      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          final locale = Localizations.localeOf(context);
          final moments = widget.controller.gratitudeMoments;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      texts.translate('gratitude_hint'),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: texts.translate('gratitude_placeholder'),
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .surfaceVariant
                            .withOpacity(.4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _addMoment(locale),
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      label: texts.translate('plant_gratitude'),
                      onPressed: () => _addMoment(locale),
                    )
                  ],
                ),
              ),
              Expanded(
                child: moments.isEmpty
                    ? Center(
                        child: Text(texts.translate('gratitude_empty')),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: moments.length,
                        itemBuilder: (context, index) {
                          final moment = moments[index];
                          return _GratitudeMomentTile(
                            moment: moment,
                            locale: locale,
                            onCycleColor: () => widget.controller
                                .cycleGratitudeColor(moment.id),
                          ).animate(delay: (index * 60).ms).fadeIn().slideY(begin: .2);
                        },
                      ),
              )
            ],
          );
        },
      ),
    );
  }

  void _addMoment(Locale locale) {
    widget.controller.addGratitudeMoment(_textController.text, locale);
    if (_textController.text.trim().isNotEmpty) {
      SystemSound.play(SystemSoundType.click);
    }
    _textController.clear();
    FocusScope.of(context).unfocus();
  }
}

class _GratitudeMomentTile extends StatelessWidget {
  const _GratitudeMomentTile({
    required this.moment,
    required this.locale,
    required this.onCycleColor,
  });

  final GratitudeMoment moment;
  final Locale locale;
  final VoidCallback onCycleColor;

  @override
  Widget build(BuildContext context) {
    final time = TimeOfDay.fromDateTime(moment.createdAt);
    return GestureDetector(
      onLongPress: onCycleColor,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [moment.moodColor.withOpacity(.8), Colors.black12],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              moment.localizedMessage(locale),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(time.format(context)),
          ],
        ),
      ),
    );
  }
}
