import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/section_title.dart';
import '../../data/mock_food_items.dart';
import '../../models/food_item.dart';
import '../catalog/food_detail_screen.dart';
import '../plan/meal_plan_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.dietController});

  final DietController dietController;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: dietController,
      builder: (context, _) {
        final week = dietController.currentWeek;
        return SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                title: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(texts.translate('home')),
                  subtitle: Text('${texts.translate('calories_this_week')}: '
                      '${week.totalCalories}'),
                  trailing: const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80'),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _WeekChart(week.caloriesPerDay)
                          .animate(key: ValueKey(dietController.currentWeek.weekStart))
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: .2),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => dietController.changeWeek(-1),
                            icon: const Icon(Icons.chevron_left),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            child: Text(
                              '${texts.translate('week')} ${dietController.currentWeek.weekStart.month}/${dietController.currentWeek.weekStart.day}',
                              key: ValueKey(dietController.currentWeek.weekStart),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          IconButton(
                            onPressed: () => dietController.changeWeek(1),
                            icon: const Icon(Icons.chevron_right),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: Text(
                            '${week.totalCalories} kcal',
                            key: ValueKey(week.totalCalories),
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(letterSpacing: -2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary.withOpacity(.35),
                              Theme.of(context).colorScheme.secondary.withOpacity(.15),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(texts.translate('today_focus'),
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text(texts.translate('breathing_prompt')),
                            const SizedBox(height: 12),
                            PrimaryButton(
                              label: texts.translate('start_plan'),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => MealPlanScreen(
                                      controller: dietController,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 500.ms).slideY(begin: .2),
                      const SizedBox(height: 24),
                      SectionTitle(title: texts.translate('catalog')),
                      SizedBox(
                        height: 220,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: mockFoodItems.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final item = mockFoodItems[index];
                            return _FoodCard(item: item)
                                .animate(delay: (index * 120).ms)
                                .fadeIn()
                                .slideX(begin: .3);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _FoodCard extends StatelessWidget {
  const _FoodCard({required this.item});

  final FoodItem item;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => FoodDetailScreen(item: item),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
      ),
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Theme.of(context).colorScheme.surface.withOpacity(.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: item.id,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Image.network(
                    item.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.nameEn,
                      style: Theme.of(context).textTheme.titleMedium),
                  Text('${item.calories} kcal'),
                  Text(texts.translate('add_to_diet')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _WeekChart extends StatelessWidget {
  const _WeekChart(this.values);
  final List<int> values;

  @override
  Widget build(BuildContext context) {
    final maxValue = values.reduce((a, b) => a > b ? a : b).toDouble();
    return SizedBox(
      height: 160,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: values
            .map(
              (value) => Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  height: 40 + 120 * (value / maxValue),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(.6),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
