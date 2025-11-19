import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/skeleton.dart';
import '../../models/weekly_stats.dart';
import '../coach/coach_chat_screen.dart';
import '../community/community_challenges_screen.dart';
import 'journey_timeline_screen.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key, required this.controller});

  final DietController controller;

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() => loading = true);
          await Future.delayed(const Duration(milliseconds: 500));
          setState(() => loading = false);
        },
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(texts.translate('progress'),
                    style: Theme.of(context).textTheme.headlineMedium)
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: .2),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: loading
                  ? const Skeleton(height: 200)
                  : _ProgressChart(
                      key: ValueKey(widget.controller.currentWeek.weekStart),
                      values: widget.controller.currentWeek.caloriesPerDay,
                    )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: .2),
            ),
            const SizedBox(height: 16),
            _GoalRow(week: widget.controller.currentWeek, loading: loading),
            const SizedBox(height: 16),
            Text(texts.translate('achievements'),
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            if (loading)
              const Skeleton(height: 100)
            else
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(
                  4,
                  (index) => Chip(
                    label: Text('🔥 ${(index + 1) * 7} ${texts.translate('streak')}'),
                  )
                      .animate(delay: (index * 120).ms)
                      .scale(duration: 300.ms)
                      .fadeIn(),
                ),
              ),
            const SizedBox(height: 24),
            if (loading)
              const Skeleton(height: 120)
            else
              _MindfulCard(texts: texts)
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: .2),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(texts.translate('journey'),
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(texts.translate('journey_subtitle')),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label: texts.translate('journey_button'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => JourneyTimelineScreen(
                            controller: widget.controller,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: .2),
            const SizedBox(height: 24),
            if (!loading)
              Row(
                children: [
                  Expanded(
                    child: _ProgressShortcut(
                      icon: Icons.flag,
                      label: texts.translate('community_cta'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CommunityChallengesScreen(
                              controller: widget.controller,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ProgressShortcut(
                      icon: Icons.chat_bubble_outline,
                      label: texts.translate('coach_cta'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CoachChatScreen(
                              controller: widget.controller,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 500.ms).slideY(begin: .1),
          ],
        ),
      ),
    );
  }
}

class _ProgressShortcut extends StatelessWidget {
  const _ProgressShortcut({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(.4),
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Expanded(child: Text(label)),
          ],
        ),
      ),
    );
  }
}

class _GoalRow extends StatelessWidget {
  const _GoalRow({required this.week, required this.loading});

  final WeeklyStats week;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    if (loading) {
      return const Skeleton(height: 60);
    }
    final completion = (week.completedDays / 7).clamp(0.0, 1.0);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: completion),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${texts.translate('weekly_goal')} ${(value * 100).round()}%'),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: value),
          ],
        );
      },
    );
  }
}

class _MindfulCard extends StatelessWidget {
  const _MindfulCard({required this.texts});

  final AppLocalizations texts;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(.25),
            Theme.of(context).colorScheme.secondary.withOpacity(.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(texts.translate('mindful_break'),
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(texts.translate('breathing_prompt')),
        ],
      ),
    );
  }
}

class _ProgressChart extends StatelessWidget {
  const _ProgressChart({required this.values});
  final List<int> values;

  @override
  Widget build(BuildContext context) {
    final maxValue = values.reduce((a, b) => a > b ? a : b).toDouble();
    return SizedBox(
      height: 200,
      child: CustomPaint(
        painter: _LineChartPainter(values: values, maxValue: maxValue),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({required this.values, required this.maxValue});
  final List<int> values;
  final double maxValue;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    final path = Path();
    for (int i = 0; i < values.length; i++) {
      final x = i / (values.length - 1) * size.width;
      final y = size.height - (values[i] / maxValue) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) => true;
}
