import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';

class MindfulStoriesScreen extends StatefulWidget {
  const MindfulStoriesScreen({super.key, required this.controller});

  final DietController controller;

  @override
  State<MindfulStoriesScreen> createState() => _MindfulStoriesScreenState();
}

class _MindfulStoriesScreenState extends State<MindfulStoriesScreen> {
  final PageController _pageController = PageController(viewportFraction: .85);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(texts.translate('mindful_stories')),
        actions: [
          IconButton(
            onPressed: () {
              widget.controller.refreshMindfulStories();
              _pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
              );
            },
            icon: const Icon(Icons.refresh),
            tooltip: texts.translate('refresh_stories'),
          )
        ],
      ),
      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          final stories = widget.controller.mindfulStories;
          return Column(
            children: [
              const SizedBox(height: 16),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: stories.length,
                  itemBuilder: (context, index) {
                    final text = stories[index];
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double page = 0;
                        if (_pageController.hasClients &&
                            _pageController.position.haveDimensions) {
                          page = _pageController.page ?? _pageController.initialPage.toDouble();
                        }
                        final delta = (index - page);
                        final scale = (1 - delta.abs() * 0.1).clamp(.9, 1.0);
                        return Transform.scale(scale: scale, child: child);
                      },
                      child: _StoryCard(index: index, text: text),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  texts.translate('story_hint'),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary ?? theme.colorScheme.primary,
    ];
    final color = colors[index % colors.length];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [color.withOpacity(.85), color.withOpacity(.35)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.35),
            blurRadius: 25,
            offset: const Offset(0, 20),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '#${index + 1}',
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.black,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: .2);
  }
}
