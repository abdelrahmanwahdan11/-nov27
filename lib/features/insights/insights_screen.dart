import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key, required this.controller});

  final DietController controller;

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final PageController _pageController = PageController(viewportFraction: .85);
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final locale = Localizations.localeOf(context);
        final cards = widget.controller.insightCards;
        final highlights = widget.controller.insightHighlights;
        return Scaffold(
          appBar: AppBar(title: Text(texts.translate('insights'))),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                texts.translate('insights_intro'),
                style: Theme.of(context).textTheme.bodyLarge,
              ).animate().fadeIn(duration: 400.ms).slideY(begin: .2),
              const SizedBox(height: 24),
              SizedBox(
                height: 280,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (value) => setState(() => _page = value),
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary.withOpacity(.65),
                              Theme.of(context).colorScheme.secondary.withOpacity(.25),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              card.localizedTitle(locale),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: Colors.black),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              card.localizedBody(locale),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.black87),
                            ),
                            const Spacer(),
                            Text(card.localizedMetricLabel(locale)),
                            const SizedBox(height: 4),
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: card.metric),
                              duration: const Duration(milliseconds: 600),
                              builder: (context, value, _) => ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: LinearProgressIndicator(
                                  value: value,
                                  minHeight: 10,
                                  backgroundColor: Colors.white24,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  card.trend >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 4),
                                Text('${(card.trend * 100).toStringAsFixed(1)}%'),
                              ],
                            )
                          ],
                        ),
                      ),
                    ).animate().fadeIn(duration: 400.ms).slideX(begin: index == _page ? 0 : .1);
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  cards.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _page == index ? 18 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _page == index
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline.withOpacity(.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: texts.translate('refresh_insights'),
                onPressed: widget.controller.refreshInsights,
              ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 24),
              Text(texts.translate('insight_highlights'),
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              ...highlights.asMap().entries.map(
                (entry) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(.2),
                    child: Text('#${entry.key + 1}'),
                  ),
                  title: Text(entry.value),
                )
                    .animate(delay: (entry.key * 80).ms)
                    .slideX(begin: .1)
                    .fadeIn(duration: 350.ms),
              ),
            ],
          ),
        );
      },
    );
  }
}
