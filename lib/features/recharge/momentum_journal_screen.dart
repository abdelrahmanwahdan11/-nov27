import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';
import '../../models/wellness_models.dart';

class MomentumJournalScreen extends StatefulWidget {
  const MomentumJournalScreen({super.key, required this.controller});

  final DietController controller;

  @override
  State<MomentumJournalScreen> createState() => _MomentumJournalScreenState();
}

class _MomentumJournalScreenState extends State<MomentumJournalScreen> {
  final TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(texts.translate('momentum_journal')),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            tooltip: texts.translate('momentum_shuffle'),
            onPressed: widget.controller.shuffleMoments,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.controller.addRandomMomentum,
        label: Text(texts.translate('momentum_shuffle')),
        icon: const Icon(Icons.auto_awesome),
      ),
      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          final moments = widget.controller.momentumMoments;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(texts.translate('momentum_intro')),
              const SizedBox(height: 16),
              TextField(
                controller: noteController,
                decoration: InputDecoration(
                  hintText: texts.translate('momentum_placeholder'),
                  filled: true,
                  fillColor:
                      Theme.of(context).colorScheme.surfaceVariant.withOpacity(.4),
                ),
                maxLines: 2,
              )
                  .animate()
                  .fadeIn(duration: 350.ms)
                  .slideY(begin: .1),
              const SizedBox(height: 12),
              PrimaryButton(
                label: texts.translate('momentum_add'),
                onPressed: () {
                  final value = noteController.text.trim();
                  if (value.isEmpty) return;
                  widget.controller.addManualMomentum(value);
                  noteController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(texts.translate('momentum_saved'))),
                  );
                },
              ),
              const SizedBox(height: 24),
              if (moments.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Center(child: Text(texts.translate('momentum_empty'))),
                )
              else
                ...moments.map(
                  (moment) => _MomentTile(moment: moment)
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: .1),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _MomentTile extends StatelessWidget {
  const _MomentTile({required this.moment});

  final MomentumMoment moment;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final date = DateFormat('MMM d, HH:mm').format(moment.timestamp);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(.35),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(moment.localizedTitle(locale),
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              Chip(label: Text('${(moment.energy * 100).round()}%')),
            ],
          ),
          const SizedBox(height: 6),
          Text(moment.localizedDetail(locale)),
          const SizedBox(height: 8),
          Text(date, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
