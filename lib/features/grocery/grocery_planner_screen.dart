import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';

class GroceryPlannerScreen extends StatefulWidget {
  const GroceryPlannerScreen({super.key, required this.controller});

  final DietController controller;

  @override
  State<GroceryPlannerScreen> createState() => _GroceryPlannerScreenState();
}

class _GroceryPlannerScreenState extends State<GroceryPlannerScreen> {
  Future<void> _showAddSheet() async {
    final texts = AppLocalizations.of(context);
    final nameController = TextEditingController();
    final categoryController = TextEditingController(text: texts.translate('category'));
    final quantityController = TextEditingController(text: '1');
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(texts.translate('add_item'),
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: texts.translate('item_name'),
                  hintText: texts.translate('grocery_add_hint'),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: texts.translate('category')),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: texts.translate('quantity')),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  if (name.isEmpty) return;
                  widget.controller.addGroceryItem(
                    nameEn: name,
                    nameAr: name,
                    category: categoryController.text.trim().isEmpty
                        ? texts.translate('category')
                        : categoryController.text.trim(),
                    quantity: int.tryParse(quantityController.text) ?? 1,
                  );
                  Navigator.of(ctx).pop();
                  SystemSound.play(SystemSoundType.click);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(texts.translate('grocery_added'))),
                  );
                },
                child: Text(texts.translate('add_item')),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final locale = Localizations.localeOf(context);
        final items = widget.controller.groceryItems;
        return Scaffold(
          appBar: AppBar(title: Text(texts.translate('grocery_planner'))),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddSheet,
            child: const Icon(Icons.add),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 500));
              setState(() {});
            },
            child: items.isEmpty
                ? ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(48.0),
                        child: Column(
                          children: [
                            Icon(Icons.shopping_bag,
                                size: 72,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(.5)),
                            const SizedBox(height: 16),
                            Text(
                              texts.translate('grocery_empty'),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .scale(begin: .95, end: 1),
                      )
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Dismissible(
                        key: ValueKey(item.id),
                        onDismissed: (_) => widget.controller.removeGroceryItem(item.id),
                        background: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20),
                          child: const Icon(Icons.delete),
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceVariant
                                .withOpacity(.5),
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: item.purchased,
                                onChanged: (_) =>
                                    widget.controller.toggleGroceryPurchased(item.id),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AnimatedDefaultTextStyle(
                                      duration: const Duration(milliseconds: 250),
                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                            decoration: item.purchased
                                                ? TextDecoration.lineThrough
                                                : null,
                                          ),
                                      child: Text(item.localizedName(locale)),
                                    ),
                                    Text(item.category),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        widget.controller.updateGroceryQuantity(item.id, -1),
                                    icon: const Icon(Icons.remove_circle_outline),
                                  ),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: Text(
                                      '${item.quantity}',
                                      key: ValueKey(item.quantity),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        widget.controller.updateGroceryQuantity(item.id, 1),
                                    icon: const Icon(Icons.add_circle_outline),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ).animate(delay: (index * 60).ms).fadeIn().slideX(begin: .1),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: items.length,
                  ),
          ),
        );
      },
    );
  }
}
