import 'package:flutter/material.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';

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
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            if (loading)
              const Skeleton(height: 180)
            else
              _ProgressChart(values: widget.controller.currentWeek.caloriesPerDay),
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
                  (index) => AnimatedScale(
                    duration: Duration(milliseconds: 200 + index * 100),
                    scale: 1,
                    child: Chip(
                      label: Text('🔥 ${(index + 1) * 7} days'),
                    ),
                  ),
                ),
              ),
          ],
        ),
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
