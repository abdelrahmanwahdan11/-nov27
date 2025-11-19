import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/mock_food_items.dart';
import '../../models/food_item.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key, required this.controller});

  final DietController controller;

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen>
    with TickerProviderStateMixin {
  final ValueNotifier<int> _selectedDay = ValueNotifier(0);
  final ValueNotifier<int> _hydration = ValueNotifier(3);
  final int _hydrationGoal = 6;
  late final List<DateTime> _days;
  String? _expandedId;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _days = List.generate(5, (index) => DateTime.now().add(Duration(days: index)));
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _selectedDay.dispose();
    _hydration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final pool = widget.controller.visibleItems.isEmpty
        ? mockFoodItems
        : widget.controller.visibleItems;
    final planSlots = _buildPlanSlots(pool, texts);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(texts.translate('meal_plan')),
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surface.withOpacity(.7),
              Theme.of(context).colorScheme.background,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            _DaySelector(days: _days, notifier: _selectedDay),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  texts.translate('today_focus'),
                  style: Theme.of(context).textTheme.titleMedium,
                ).animate().fadeIn(duration: 400.ms).slideX(begin: -.1),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<int>(
                valueListenable: _selectedDay,
                builder: (context, selected, _) {
                  final energy =
                      (widget.controller.currentWeek.totalCalories / 7).round();
                  return ListView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    children: [
                      Text(
                        '${texts.translate('daily_energy')}: $energy kcal',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ).animate().fadeIn(duration: 400.ms).slideY(begin: .2),
                      const SizedBox(height: 12),
                      ...planSlots.asMap().entries.map((entry) {
                        final delay = (entry.key * 120).ms;
                        final slot = entry.value;
                        final isExpanded = _expandedId == slot.item.id;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _expandedId = isExpanded ? null : slot.item.id;
                            });
                          },
                          child: _PlanCard(
                            slot: slot,
                            expanded: isExpanded,
                            pulse: _pulseController,
                          ),
                        )
                            .animate(delay: delay)
                            .fadeIn(duration: 300.ms)
                            .slideX(begin: selected.isEven ? .2 : -.2);
                      }).toList(),
                      const SizedBox(height: 12),
                      _HydrationCard(
                        hydration: _hydration,
                        goal: _hydrationGoal,
                        pulse: _pulseController,
                      ),
                      const SizedBox(height: 12),
                      const _CoachNotesCard(),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: texts.translate('start_plan'),
                        onPressed: () {
                          SystemSound.play(SystemSoundType.click);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(texts.translate('plan_ready'))),
                          );
                        },
                      ).animate().scale(duration: 400.ms),
                      const SizedBox(height: 32),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_PlanSlot> _buildPlanSlots(
    List<FoodItem> pool,
    AppLocalizations texts,
  ) {
    final slotLabels = [
      texts.translate('breakfast'),
      texts.translate('lunch'),
      texts.translate('dinner'),
      texts.translate('snacks'),
    ];
    return List<_PlanSlot>.generate(
      slotLabels.length,
      (index) => _PlanSlot(
        label: slotLabels[index],
        time: '${6 + index * 3}:00',
        item: pool[index % pool.length],
      ),
    );
  }
}

class _DaySelector extends StatelessWidget {
  const _DaySelector({required this.days, required this.notifier});

  final List<DateTime> days;
  final ValueNotifier<int> notifier;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat.E(Localizations.localeOf(context).languageCode);
    return ValueListenableBuilder<int>(
      valueListenable: notifier,
      builder: (context, value, _) {
        return SizedBox(
          height: 76,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final selected = value == index;
              return GestureDetector(
                onTap: () => notifier.value = index,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: selected
                        ? Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(.85)
                        : Theme.of(context)
                            .colorScheme
                            .surfaceVariant
                            .withOpacity(.35),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(formatter.format(days[index])),
                      Text('${days[index].day}'),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _PlanSlot {
  _PlanSlot({required this.label, required this.time, required this.item});

  final String label;
  final String time;
  final FoodItem item;
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.slot,
    required this.expanded,
    required this.pulse,
  });

  final _PlanSlot slot;
  final bool expanded;
  final AnimationController pulse;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    return AnimatedBuilder(
      animation: pulse,
      builder: (context, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withOpacity(.25 + pulse.value * .1),
                theme.colorScheme.surface.withOpacity(.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(.15),
                blurRadius: 12 + pulse.value * 10,
                spreadRadius: pulse.value,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(slot.label,
                          style: theme.textTheme.titleMedium),
                      subtitle: Text(slot.time),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Hero(
                      tag: 'plan-${slot.item.id}',
                      child: Image.network(
                        slot.item.imageUrl,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: expanded
                    ? Padding(
                        key: ValueKey(slot.item.id),
                        padding: const EdgeInsets.only(top: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(slot.item.shortDescription(lang)),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _MacroBar(
                                    label: 'P',
                                    value: slot.item.protein / 40,
                                    color: Colors.pinkAccent,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _MacroBar(
                                    label: 'C',
                                    value: slot.item.carbs / 80,
                                    color: Colors.amber,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _MacroBar(
                                    label: 'F',
                                    value: slot.item.fats / 30,
                                    color: Colors.lightBlueAccent,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              )
            ],
          ),
        );
      },
    );
  }
}

class _MacroBar extends StatelessWidget {
  const _MacroBar({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(label),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: value.clamp(0, 1),
            minHeight: 8,
            backgroundColor: color.withOpacity(.2),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

class _HydrationCard extends StatelessWidget {
  const _HydrationCard({
    required this.hydration,
    required this.goal,
    required this.pulse,
  });

  final ValueNotifier<int> hydration;
  final int goal;
  final AnimationController pulse;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return ValueListenableBuilder<int>(
      valueListenable: hydration,
      builder: (context, value, _) {
        final ratio = value / goal;
        return AnimatedBuilder(
          animation: pulse,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: Theme.of(context).colorScheme.primary.withOpacity(.15),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(texts.translate('hydration'),
                            style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          '${texts.translate('hydration_goal')}: $goal ${texts.translate('glasses')}',
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: ratio.clamp(0, 1),
                          minHeight: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    children: [
                      Container(
                        width: 58 + pulse.value * 4,
                        height: 58 + pulse.value * 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(.4),
                        ),
                        alignment: Alignment.center,
                        child: Text('$value/$goal'),
                      ),
                      const SizedBox(height: 8),
                      PrimaryButton(
                        label: texts.translate('hydrate_now'),
                        onPressed: () {
                          SystemSound.play(SystemSoundType.click);
                          if (value < goal) {
                            hydration.value = value + 1;
                            if (value + 1 == goal) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(texts.translate('plan_ready')),
                                ),
                              );
                            }
                          }
                        },
                      )
                    ],
                  )
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideX(begin: .1);
          },
        );
      },
    );
  }
}

class _CoachNotesCard extends StatelessWidget {
  const _CoachNotesCard();

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.secondary.withOpacity(.2),
            Theme.of(context).colorScheme.surface.withOpacity(.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(texts.translate('coach_notes'),
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(texts.translate('breathing_prompt')),
          const SizedBox(height: 12),
          Text(texts.translate('mindful_break')),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: .2);
  }
}
