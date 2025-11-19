import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/section_title.dart';
import '../../models/wellness_models.dart';
import '../plan/macro_forge_screen.dart';

class PulseObservatoryScreen extends StatelessWidget {
  const PulseObservatoryScreen({super.key, required this.controller});

  final DietController controller;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(texts.translate('pulse_observatory')),
        backgroundColor: Colors.transparent,
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final wave = controller.currentPulseWave;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(.3),
                      Theme.of(context).colorScheme.secondary.withOpacity(.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wave.localizedTitle(locale),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(texts.translate('pulse_hint')),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _PulseStat(
                            label: texts.translate('pulse_charge'),
                            value: wave.charge,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _PulseStat(
                            label: texts.translate('pulse_calm'),
                            value: wave.calm,
                            color: Colors.cyanAccent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 140,
                      child: _PulseChart(points: wave.graph)
                          .animate(key: ValueKey(wave.id))
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: .2),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            label: texts.translate('pulse_cycle'),
                            onPressed: () => controller.shiftPulseWave(1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () => controller.randomizePulseWave(wave.id),
                          icon: const Icon(Icons.auto_awesome),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 500.ms).slideY(begin: .2),
              const SizedBox(height: 24),
              SectionTitle(title: texts.translate('pulse_library')),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: controller.pulseWaves
                    .map(
                      (item) {
                        final targetIndex =
                            controller.pulseWaves.indexOf(item);
                        final currentIndex =
                            controller.pulseWaves.indexOf(wave);
                        return ChoiceChip(
                          label: Text(item.localizedTitle(locale)),
                          selected: item.id == wave.id,
                          onSelected: (_) => controller
                              .shiftPulseWave(targetIndex - currentIndex),
                        );
                      },
                    )
                    .toList(),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 24),
              SectionTitle(title: texts.translate('macro_forge')),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(.4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.highlightedBlueprint.localizedTitle(locale),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(controller.highlightedBlueprint
                        .localizedDescription(locale)),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      label: texts.translate('macro_adjust'),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MacroForgeScreen(
                              controller: controller,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: .1),
            ],
          );
        },
      ),
    );
  }
}

class _PulseStat extends StatelessWidget {
  const _PulseStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: value),
          duration: const Duration(milliseconds: 500),
          builder: (context, val, _) => LinearProgressIndicator(
            value: val,
            color: color,
            backgroundColor: color.withOpacity(.2),
          ),
        ),
        const SizedBox(height: 4),
        Text('${(value * 100).round()}%'),
      ],
    );
  }
}

class _PulseChart extends StatelessWidget {
  const _PulseChart({required this.points});

  final List<double> points;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PulseWavePainter(points: points),
    );
  }
}

class _PulseWavePainter extends CustomPainter {
  _PulseWavePainter({required this.points});

  final List<double> points;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final paint = Paint()
      ..color = Colors.amberAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    for (var i = 0; i < points.length; i++) {
      final x = i / (points.length - 1) * size.width;
      final y = size.height - (points[i] * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
    final glow = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.amberAccent, Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill
      ..color = Colors.amberAccent.withOpacity(.2);
    final fill = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(fill, glow);
  }

  @override
  bool shouldRepaint(covariant _PulseWavePainter oldDelegate) => true;
}
