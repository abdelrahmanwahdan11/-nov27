import 'package:flutter/material.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../models/food_item.dart';

class ComparisonScreen extends StatelessWidget {
  const ComparisonScreen({super.key, required this.controller});

  final DietController controller;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final items = controller.comparisonItems;
    return Scaffold(
      appBar: AppBar(title: Text(texts.translate('comparison'))),
      body: items.length < 2
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(texts.translate('empty_comparison')),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(texts.translate('back_to_catalog')),
                  )
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: items
                      .map(
                        (item) => Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.1),
                            ),
                            child: Column(
                              children: [
                                Text(item.nameEn,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                Text('${item.calories} kcal'),
                                TextButton(
                                  onPressed: () => controller.removeComparison(item.id),
                                  child: Text(texts.translate('remove')),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
                _ComparisonTable(items: items),
              ],
            ),
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  const _ComparisonTable({required this.items});

  final List<FoodItem> items;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      children: [
        _row('kcal', (item) => '${item.calories}'),
        _row('protein', (item) => '${item.protein}g'),
        _row('carbs', (item) => '${item.carbs}g'),
        _row('fats', (item) => '${item.fats}g'),
        _row('category', (item) => item.category),
      ],
    );
  }

  TableRow _row(String label, String Function(FoodItem) builder) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(builder(item)),
          ),
        )
      ],
    );
  }
}
