import 'package:flutter/material.dart';

class GrowthMission {
  GrowthMission({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.target,
    this.progress = 0,
    this.highlighted = false,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final int target;
  double progress;
  bool highlighted;
}

class RhythmCard {
  RhythmCard({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.subtitleEn,
    required this.subtitleAr,
    required this.bpm,
    required this.waves,
    required this.focus,
    this.expanded = false,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String subtitleEn;
  final String subtitleAr;
  int bpm;
  int waves;
  double focus;
  bool expanded;
}

class VisionEntry {
  VisionEntry({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.noteEn,
    required this.noteAr,
    required this.moodColor,
    this.pinned = false,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String noteEn;
  final String noteAr;
  Color moodColor;
  bool pinned;
}
