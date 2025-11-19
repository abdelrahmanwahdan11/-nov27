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
