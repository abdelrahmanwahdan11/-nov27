import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/mock_food_items.dart';
import '../../models/food_item.dart';

class JourneyTimelineScreen extends StatefulWidget {
  const JourneyTimelineScreen({super.key, required this.controller});

  final DietController controller;

  @override
  State<JourneyTimelineScreen> createState() => _JourneyTimelineScreenState();
}

class _JourneyTimelineScreenState extends State<JourneyTimelineScreen> {
  late final List<_JourneyEvent> _events;
  String? _expandedId;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final pool = mockFoodItems;
    _events = List.generate(pool.length, (index) {
      return _JourneyEvent(
        id: 'journey-${pool[index].id}',
        food: pool[index],
        dayOffset: index,
        progress: (index + 2) / (pool.length + 2),
      );
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(
        title: Text(texts.translate('journey')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            texts.translate('journey_subtitle'),
            style: Theme.of(context).textTheme.bodyMedium,
          ).animate().fadeIn(duration: 400.ms).slideY(begin: .2),
          const SizedBox(height: 16),
          ..._events.asMap().entries.map((entry) {
            final delay = (entry.key * 120).ms;
            final event = entry.value;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _expandedId = _expandedId == event.id ? null : event.id;
                });
              },
              child: _TimelineCard(
                event: event,
                expanded: _expandedId == event.id,
                languageCode: lang,
              ),
            ).animate(delay: delay).fadeIn().slideY(begin: .2);
          }),
          const SizedBox(height: 24),
          TextField(
            controller: _noteController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: texts.translate('add_reflection'),
              hintText: texts.translate('notes_hint'),
              filled: true,
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 12),
          PrimaryButton(
            label: texts.translate('add_reflection'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(texts.translate('reflection_saved'))),
              );
              _noteController.clear();
            },
          ).animate().scale(duration: 300.ms),
        ],
      ),
    );
  }
}

class _JourneyEvent {
  _JourneyEvent({
    required this.id,
    required this.food,
    required this.dayOffset,
    required this.progress,
  });

  final String id;
  final FoodItem food;
  final int dayOffset;
  final double progress;
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({
    required this.event,
    required this.expanded,
    required this.languageCode,
  });

  final _JourneyEvent event;
  final bool expanded;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = DateTime.now().subtract(Duration(days: event.dayOffset));
    final label = DateFormat.E(languageCode).format(date).toUpperCase();
    return Stack(
      children: [
        Positioned(
          left: languageCode == 'ar' ? null : 20,
          right: languageCode == 'ar' ? 20 : null,
          top: 0,
          bottom: 0,
          child: Container(
            width: 2,
            color: theme.colorScheme.primary.withOpacity(.4),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: languageCode == 'ar' ? 0 : 48,
            right: languageCode == 'ar' ? 48 : 0,
            bottom: 16,
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: theme.colorScheme.surface.withOpacity(.8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label, style: theme.textTheme.labelLarge),
                  Text('${event.food.calories} kcal'),
                ],
              ),
              const SizedBox(height: 8),
              Text(event.food.name(languageCode),
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: event.progress.clamp(0, 1)),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: expanded
                    ? Padding(
                        key: ValueKey(event.id),
                        padding: const EdgeInsets.only(top: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.food.shortDescription(languageCode)),
                            const SizedBox(height: 8),
                            Text(event.food.longDescription(languageCode)),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              )
            ],
          ),
        ),
        Positioned(
          left: languageCode == 'ar' ? null : 12,
          right: languageCode == 'ar' ? 12 : null,
          top: 24,
          child: CircleAvatar(
            radius: 12,
            backgroundColor: theme.colorScheme.primary,
          ),
        )
      ],
    );
  }
}
