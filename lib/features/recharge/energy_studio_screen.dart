import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';
import '../../models/wellness_models.dart';

class EnergyStudioScreen extends StatelessWidget {
  const EnergyStudioScreen({super.key, required this.controller});

  final DietController controller;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(texts.translate('energy_studio'))),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final charge = controller.energyCharge;
          final sparkline = controller.energySparkline;
          final patterns = controller.energyPatterns;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(texts.translate('energy_wave_hint'),
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: charge),
                duration: const Duration(milliseconds: 600),
                builder: (context, value, _) {
                  return SizedBox(
                    height: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(.35),
                                Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(.05),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          height: 160,
                          child: CircularProgressIndicator(
                            value: value,
                            strokeWidth: 12,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(.1),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(texts.translate('energy_charge')),
                            Text(
                              '${(value * 100).round()}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(letterSpacing: -2),
                            ),
                          ],
                        )
                      ],
                    ),
                  ).animate().fadeIn(duration: 500.ms).scale();
                },
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(.4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(texts.translate('energy_trend'),
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    _EnergySparkline(values: sparkline)
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideX(begin: -.05),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      label: texts.translate('boost_energy'),
                      onPressed: () => controller.boostEnergy(.08),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(texts.translate('energy_patterns'),
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  IconButton(
                    onPressed: controller.shuffleEnergyPatterns,
                    icon: const Icon(Icons.shuffle),
                    tooltip: texts.translate('energy_shuffle'),
                  )
                ],
              ),
              const SizedBox(height: 12),
              ...patterns.map(
                (pattern) => _EnergyPatternCard(
                  pattern: pattern,
                  onTap: () => controller.toggleEnergyPattern(pattern.id),
                )
                    .animate()
                    .fadeIn(duration: 350.ms)
                    .slideY(begin: .1),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: texts.translate('momentum_cta'),
                onPressed: controller.addRandomMomentum,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EnergySparkline extends StatelessWidget {
  const _EnergySparkline({required this.values});
  final List<double> values;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: CustomPaint(
        painter: _SparklinePainter(values: values),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({required this.values});
  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    for (int i = 0; i < values.length; i++) {
      final x = i / (values.length - 1) * size.width;
      final y = size.height - values[i] * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final paint = Paint()
      ..color = Colors.amberAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) => true;
}

class _EnergyPatternCard extends StatelessWidget {
  const _EnergyPatternCard({required this.pattern, required this.onTap});

  final EnergyPattern pattern;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              Theme.of(context)
                  .colorScheme
                  .primary
                  .withOpacity(pattern.active ? .4 : .15),
              Theme.of(context)
                  .colorScheme
                  .secondary
                  .withOpacity(pattern.active ? .25 : .05),
            ],
          ),
          border: Border.all(
            color: pattern.active
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pattern.localizedTitle(locale),
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(pattern.localizedDescription(locale)),
                  const SizedBox(height: 8),
                  Text('${pattern.length.inMinutes} min • '
                      '${(pattern.intensity * 10).round()}/10'),
                ],
              ),
            ),
            Icon(pattern.active ? Icons.pause_circle : Icons.play_arrow, size: 32),
          ],
        ),
      ),
    );
  }
}
