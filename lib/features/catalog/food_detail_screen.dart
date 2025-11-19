import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';
import '../../models/food_item.dart';

class FoodDetailScreen extends StatefulWidget {
  const FoodDetailScreen({super.key, required this.item});

  final FoodItem item;

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  bool flipped = false;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Hero(
              tag: widget.item.id,
              child: Image.network(
                widget.item.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(.8), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.bookmark_border, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: flipped
                      ? _DetailCard(
                          key: const ValueKey('detail'),
                          item: widget.item,
                          texts: texts,
                          language: language,
                        )
                      : _SummaryCard(
                          key: const ValueKey('summary'),
                          item: widget.item,
                          texts: texts,
                          language: language,
                        ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryButton(
                      label: texts.translate('done'),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () => setState(() => flipped = !flipped),
                      child: Text(texts.translate('add_to_plan')),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (_) => Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(texts.translate('ai_placeholder')),
                    ),
                  ),
                  child: Text(texts.translate('ai_info')),
                ),
                const SizedBox(height: 24),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({super.key, required this.item, required this.texts, required this.language});
  final FoodItem item;
  final AppLocalizations texts;
  final String language;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => SystemSound.play(SystemSoundType.click),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white.withOpacity(.85),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.name(language),
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.black),
            ),
            Text('${item.calories} kcal'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MacroInfo(label: 'P', value: item.protein),
                _MacroInfo(label: 'C', value: item.carbs),
                _MacroInfo(label: 'F', value: item.fats),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.shortDescription(language),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({super.key, required this.item, required this.texts, required this.language});
  final FoodItem item;
  final AppLocalizations texts;
  final String language;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.black.withOpacity(.7),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.longDescription(language),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: item.tags.map((tag) => Chip(label: Text(tag))).toList(),
          )
        ],
      ),
    );
  }
}

class _MacroInfo extends StatelessWidget {
  const _MacroInfo({required this.label, required this.value});
  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('${value.toStringAsFixed(1)}g'),
      ],
    );
  }
}
