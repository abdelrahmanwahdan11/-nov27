import 'package:flutter/material.dart';

class WellnessHabit {
  WellnessHabit({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.schedule,
    this.focus = .5,
    this.enabled = true,
    this.streak = 0,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final List<String> schedule;
  double focus;
  bool enabled;
  int streak;

  String localizedTitle(Locale locale) =>
      locale.languageCode == 'ar' ? titleAr : titleEn;

  String localizedDescription(Locale locale) =>
      locale.languageCode == 'ar' ? descriptionAr : descriptionEn;
}

class GroceryItem {
  GroceryItem({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.category,
    this.quantity = 1,
    this.purchased = false,
  });

  final String id;
  final String nameEn;
  final String nameAr;
  final String category;
  int quantity;
  bool purchased;

  String localizedName(Locale locale) =>
      locale.languageCode == 'ar' ? nameAr : nameEn;
}

class InsightCard {
  InsightCard({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.bodyEn,
    required this.bodyAr,
    required this.metricLabelEn,
    required this.metricLabelAr,
    this.metric = .6,
    this.trend = .1,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String bodyEn;
  final String bodyAr;
  final String metricLabelEn;
  final String metricLabelAr;
  double metric;
  double trend;

  String localizedTitle(Locale locale) =>
      locale.languageCode == 'ar' ? titleAr : titleEn;

  String localizedBody(Locale locale) =>
      locale.languageCode == 'ar' ? bodyAr : bodyEn;

  String localizedMetricLabel(Locale locale) =>
      locale.languageCode == 'ar' ? metricLabelAr : metricLabelEn;
}

class RecoverySession {
  RecoverySession({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.duration,
    required this.tags,
    this.energy = .5,
    this.completed = false,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final Duration duration;
  final List<String> tags;
  double energy;
  bool completed;

  String localizedTitle(Locale locale) =>
      locale.languageCode == 'ar' ? titleAr : titleEn;

  String localizedDescription(Locale locale) =>
      locale.languageCode == 'ar' ? descriptionAr : descriptionEn;
}

class RitualStep {
  RitualStep({
    required this.labelEn,
    required this.labelAr,
    this.completed = false,
  });

  final String labelEn;
  final String labelAr;
  bool completed;

  String localizedLabel(Locale locale) =>
      locale.languageCode == 'ar' ? labelAr : labelEn;
}

class RitualBlueprint {
  RitualBlueprint({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.steps,
    this.focus = .5,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final List<RitualStep> steps;
  double focus;

  String localizedTitle(Locale locale) =>
      locale.languageCode == 'ar' ? titleAr : titleEn;

  String localizedDescription(Locale locale) =>
      locale.languageCode == 'ar' ? descriptionAr : descriptionEn;
}

class RewardBadge {
  RewardBadge({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.points,
    this.unlocked = false,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final int points;
  bool unlocked;

  String localizedTitle(Locale locale) =>
      locale.languageCode == 'ar' ? titleAr : titleEn;

  String localizedDescription(Locale locale) =>
      locale.languageCode == 'ar' ? descriptionAr : descriptionEn;
}

class EnergyPattern {
  EnergyPattern({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.length,
    this.intensity = .5,
    this.active = false,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final Duration length;
  double intensity;
  bool active;

  String localizedTitle(Locale locale) =>
      locale.languageCode == 'ar' ? titleAr : titleEn;

  String localizedDescription(Locale locale) =>
      locale.languageCode == 'ar' ? descriptionAr : descriptionEn;
}

class FlowRoutine {
  FlowRoutine({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.tempo,
    required this.loops,
    this.intensity = .5,
    this.active = false,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final int tempo;
  final int loops;
  double intensity;
  bool active;

  String localizedTitle(Locale locale) =>
      locale.languageCode == 'ar' ? titleAr : titleEn;

  String localizedDescription(Locale locale) =>
      locale.languageCode == 'ar' ? descriptionAr : descriptionEn;
}

class FocusDrill {
  FocusDrill({
    required this.id,
    required this.cueEn,
    required this.cueAr,
    required this.durationSeconds,
    required this.breaths,
    this.progress = 0,
    this.completed = false,
  });

  final String id;
  final String cueEn;
  final String cueAr;
  final int durationSeconds;
  final int breaths;
  double progress;
  bool completed;

  String localizedCue(Locale locale) =>
      locale.languageCode == 'ar' ? cueAr : cueEn;
}

class JourneyMoment {
  JourneyMoment({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.detailEn,
    required this.detailAr,
    required this.moodColor,
    required this.timestamp,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String detailEn;
  final String detailAr;
  final Color moodColor;
  final DateTime timestamp;

  String localizedTitle(Locale locale) =>
      locale.languageCode == 'ar' ? titleAr : titleEn;

  String localizedDetail(Locale locale) =>
      locale.languageCode == 'ar' ? detailAr : detailEn;
}

class SleepCue {
  SleepCue({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.detailEn,
    required this.detailAr,
    required this.emoji,
    this.duration = const Duration(minutes: 5),
    this.completed = false,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String detailEn;
  final String detailAr;
  final String emoji;
  final Duration duration;
  bool completed;

  String localizedTitle(Locale locale) =>
      locale.languageCode == 'ar' ? titleAr : titleEn;

  String localizedDetail(Locale locale) =>
      locale.languageCode == 'ar' ? detailAr : detailEn;
}

class MomentumMoment {
  MomentumMoment({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.detailEn,
    required this.detailAr,
    required this.timestamp,
    this.energy = .6,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String detailEn;
  final String detailAr;
  final DateTime timestamp;
  double energy;

  String localizedTitle(Locale locale) =>
      locale.languageCode == 'ar' ? titleAr : titleEn;

  String localizedDetail(Locale locale) =>
      locale.languageCode == 'ar' ? detailAr : detailEn;
}

class PulseWave {
  PulseWave({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.charge,
    required this.calm,
    required this.graph,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  double charge;
  double calm;
  final List<double> graph;

  String localizedTitle(Locale locale) =>
      locale.languageCode == 'ar' ? titleAr : titleEn;
}

class MacroBlueprint {
  MacroBlueprint({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.micros,
    this.glow = .5,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  int protein;
  int carbs;
  int fats;
  int micros;
  double glow;

  String localizedTitle(Locale locale) =>
      locale.languageCode == 'ar' ? titleAr : titleEn;

  String localizedDescription(Locale locale) =>
      locale.languageCode == 'ar' ? descriptionAr : descriptionEn;
}

class LegacyCapsule {
  LegacyCapsule({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.noteEn,
    required this.noteAr,
    required this.timestamp,
    required this.moodColor,
    this.favorite = false,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String noteEn;
  final String noteAr;
  final DateTime timestamp;
  Color moodColor;
  bool favorite;

  String localizedTitle(Locale locale) =>
      locale.languageCode == 'ar' ? titleAr : titleEn;

  String localizedNote(Locale locale) =>
      locale.languageCode == 'ar' ? noteAr : noteEn;
}

class EclipseProgram {
  EclipseProgram({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.focusEn,
    required this.focusAr,
    required this.loops,
    required this.alignment,
    required this.wave,
    required this.accent,
    this.active = false,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String focusEn;
  final String focusAr;
  final int loops;
  final double alignment;
  final List<double> wave;
  final Color accent;
  bool active;

  String localizedTitle(Locale locale) =>
      locale.languageCode == 'ar' ? titleAr : titleEn;

  String localizedFocus(Locale locale) =>
      locale.languageCode == 'ar' ? focusAr : focusEn;
}

class ClaritySignal {
  ClaritySignal({
    required this.id,
    required this.labelEn,
    required this.labelAr,
    required this.descriptionEn,
    required this.descriptionAr,
    this.current = .4,
    this.target = .8,
    this.trend = .0,
  });

  final String id;
  final String labelEn;
  final String labelAr;
  final String descriptionEn;
  final String descriptionAr;
  double current;
  double target;
  double trend;

  String localizedLabel(Locale locale) =>
      locale.languageCode == 'ar' ? labelAr : labelEn;

  String localizedDescription(Locale locale) =>
      locale.languageCode == 'ar' ? descriptionAr : descriptionEn;
}

class SyncDrill {
  SyncDrill({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.cuesEn,
    required this.cuesAr,
    required this.rounds,
    this.completedRounds = 0,
    this.progress = .2,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final List<String> cuesEn;
  final List<String> cuesAr;
  final int rounds;
  int completedRounds;
  double progress;

  String localizedTitle(Locale locale) =>
      locale.languageCode == 'ar' ? titleAr : titleEn;

  List<String> localizedCues(Locale locale) =>
      locale.languageCode == 'ar' ? cuesAr : cuesEn;
}
