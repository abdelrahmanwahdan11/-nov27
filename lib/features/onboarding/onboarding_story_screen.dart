import 'dart:async';

import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/primary_button.dart';

class OnboardingStoryScreen extends StatefulWidget {
  const OnboardingStoryScreen({
    super.key,
    required this.appController,
  });

  final AppController appController;

  @override
  State<OnboardingStoryScreen> createState() => _OnboardingStoryScreenState();
}

class _OnboardingStoryScreenState extends State<OnboardingStoryScreen> {
  final PageController controller = PageController();
  late Timer timer;
  int index = 0;

  final List<String> images = [
    'https://images.unsplash.com/photo-1470337458703-46ad1756a187?auto=format&fit=crop&w=900&q=80',
    'https://images.unsplash.com/photo-1514996937319-344454492b37?auto=format&fit=crop&w=900&q=80',
    'https://images.unsplash.com/photo-1506089676908-3592f7389d4d?auto=format&fit=crop&w=900&q=80',
  ];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      index = (index + 1) % images.length;
      controller.animateToPage(
        index,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    timer.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final pages = [
      (
        title: texts.translate('onboarding_title_1'),
        subtitle: texts.translate('onboarding_subtitle_1'),
      ),
      (
        title: texts.translate('onboarding_title_2'),
        subtitle: texts.translate('onboarding_subtitle_2'),
      ),
      (
        title: texts.translate('onboarding_title_3'),
        subtitle: texts.translate('onboarding_subtitle_3'),
      ),
    ];
    return Scaffold(
      body: Container(
        decoration: gradientBackground(widget.appController.primaryColor),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  itemCount: pages.length,
                  onPageChanged: (value) => setState(() => index = value),
                  itemBuilder: (context, i) {
                    final page = pages[i];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: 'hero-image-$i',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: Image.network(
                              images[i],
                              height: 280,
                              width: 280,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            page.subtitle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.all(4),
                    width: i == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(i == index ? .8 : .3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: _finish,
                        child: Text(texts.translate('skip')),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: PrimaryButton(
                        label: texts.translate('get_started'),
                        onPressed: _finish,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _finish() {
    widget.appController.setOnboarded();
    setState(() {});
  }
}
