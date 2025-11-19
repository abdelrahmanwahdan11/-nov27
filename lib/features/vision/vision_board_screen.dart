import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';

class VisionBoardScreen extends StatefulWidget {
  const VisionBoardScreen({super.key, required this.controller});

  final DietController controller;

  @override
  State<VisionBoardScreen> createState() => _VisionBoardScreenState();
}

class _VisionBoardScreenState extends State<VisionBoardScreen> {
  final _titleEn = TextEditingController();
  final _titleAr = TextEditingController();
  final _noteEn = TextEditingController();
  final _noteAr = TextEditingController();

  @override
  void dispose() {
    _titleEn.dispose();
    _titleAr.dispose();
    _noteEn.dispose();
    _noteAr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(texts.translate('vision_board_title')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openComposer(texts),
        icon: const Icon(Icons.add),
        label: Text(texts.translate('vision_add_button')),
      ),
      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          final entries = widget.controller.visionEntries;
          if (entries.isEmpty) {
            return Center(
              child: Text(texts.translate('vision_empty_state')),
            ).animate().fadeIn(duration: 400.ms);
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              final locale = Localizations.localeOf(context).languageCode;
              final title = locale == 'ar' ? entry.titleAr : entry.titleEn;
              final note = locale == 'ar' ? entry.noteAr : entry.noteEn;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: [
                      entry.moodColor.withOpacity(.85),
                      entry.moodColor.withOpacity(.35),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.black),
                          ),
                        ),
                        IconButton(
                          onPressed: () => widget.controller.toggleVisionPin(entry.id),
                          icon: Icon(entry.pinned
                              ? Icons.push_pin
                              : Icons.push_pin_outlined),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      note,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      children: [
                        Chip(
                          avatar: const Icon(Icons.calendar_today, size: 18),
                          label: Text(texts.translate('vision_today_tag')),
                        ),
                        Chip(
                          avatar: const Icon(Icons.auto_awesome, size: 18),
                          label: Text(texts.translate('vision_mood_tag')),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => widget.controller.cycleVisionColor(entry.id),
                            child: Text(texts.translate('vision_color_button')),
                          ),
                        ),
                        PrimaryButton(
                          label: entry.pinned
                              ? texts.translate('vision_pinned')
                              : texts.translate('vision_pin'),
                          onPressed: () =>
                              widget.controller.toggleVisionPin(entry.id),
                        )
                      ],
                    )
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms).slideY(begin: .1);
            },
          );
        },
      ),
    );
  }

  Future<void> _openComposer(AppLocalizations texts) async {
    _titleEn.clear();
    _titleAr.clear();
    _noteEn.clear();
    _noteAr.clear();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(texts.translate('vision_add_title'),
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              TextField(
                controller: _titleEn,
                decoration: InputDecoration(
                  labelText: texts.translate('title_en'),
                ),
              ),
              TextField(
                controller: _titleAr,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  labelText: texts.translate('title_ar'),
                ),
              ),
              TextField(
                controller: _noteEn,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: texts.translate('note_en'),
                ),
              ),
              TextField(
                controller: _noteAr,
                maxLines: 2,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  labelText: texts.translate('note_ar'),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: texts.translate('vision_add_button'),
                onPressed: () {
                  widget.controller.addVisionEntry(
                    titleEn: _titleEn.text,
                    titleAr: _titleAr.text,
                    noteEn: _noteEn.text,
                    noteAr: _noteAr.text,
                  );
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(content: Text(texts.translate('vision_success'))),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
