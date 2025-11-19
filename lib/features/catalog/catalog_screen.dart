import 'package:flutter/material.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../models/food_item.dart';
import 'comparison_screen.dart';
import 'food_detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key, required this.controller});

  final DietController controller;

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 120) {
        widget.controller.loadMore();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    widget.controller.disposeDebounce();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final items = widget.controller.visibleItems;
        return Scaffold(
          floatingActionButton: widget.controller.comparisonIds.length >= 2
              ? FloatingActionButton.extended(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ComparisonScreen(
                        controller: widget.controller,
                      ),
                    ),
                  ),
                  label: Text(texts.translate('compare')),
                )
              : null,
          body: RefreshIndicator(
            onRefresh: widget.controller.refresh,
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              children: [
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    labelText: texts.translate('search'),
                  ),
                  onChanged: widget.controller.setSearch,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('All'),
                      selected: widget.controller.category == null,
                      onSelected: (_) => widget.controller.setCategory(null),
                    ),
                    for (final category in {'Juice', 'Bowl', 'Salad'})
                      ChoiceChip(
                        label: Text(category),
                        selected: widget.controller.category == category,
                        onSelected: (_) => widget.controller.setCategory(category),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        min: 200,
                        max: 800,
                        value: widget.controller.maxCalories,
                        onChanged: widget.controller.setMaxCalories,
                      ),
                    ),
                    Text('${widget.controller.maxCalories.round()} kcal'),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: widget.controller.toggleSortOrder,
                    child: const Text('Sort kcal'),
                  ),
                ),
                const SizedBox(height: 16),
                if (items.isEmpty && widget.controller.loading)
                  Column(
                    children: List.generate(
                      4,
                      (index) => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Skeleton(height: 120),
                      ),
                    ),
                  )
                else
                  ...items.map((item) => _CatalogCard(
                        item: item,
                        selected: widget.controller.comparisonIds.contains(item.id),
                        onCompare: () => widget.controller.toggleComparison(item, context),
                      )),
                if (widget.controller.loading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Skeleton(height: 100),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CatalogCard extends StatelessWidget {
  const _CatalogCard({
    required this.item,
    required this.selected,
    required this.onCompare,
  });

  final FoodItem item;
  final bool selected;
  final VoidCallback onCompare;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(item.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
        ),
        title: Text(item.nameEn),
        subtitle: Text(item.shortDescription(Localizations.localeOf(context).languageCode)),
        trailing: Column(
          children: [
            Text('${item.calories} kcal'),
            IconButton(
              icon: Icon(selected ? Icons.balance : Icons.balance_outlined),
              onPressed: onCompare,
            )
          ],
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => FoodDetailScreen(item: item)),
        ),
      ),
    );
  }
}
