import 'package:flutter/material.dart';

class ChallengeRoutine {
  ChallengeRoutine({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.days,
    required this.reward,
    this.completedDays = 0,
    this.joined = false,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final int days;
  final String reward;
  int completedDays;
  bool joined;

  double get progress => (completedDays / days).clamp(0, 1);

  String localizedTitle(Locale locale) =>
      locale.languageCode == 'ar' ? titleAr : titleEn;

  String localizedDescription(Locale locale) =>
      locale.languageCode == 'ar' ? descriptionAr : descriptionEn;
}

class CoachMessage {
  CoachMessage({
    required this.id,
    required this.text,
    required this.fromCoach,
    required this.timestamp,
  });

  final String id;
  final String text;
  final bool fromCoach;
  final DateTime timestamp;
}

class RecipeIdea {
  RecipeIdea({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.image,
    required this.calories,
    this.favorite = false,
    this.sparkle = 0.6,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final String image;
  final int calories;
  bool favorite;
  double sparkle;

  String localizedTitle(Locale locale) =>
      locale.languageCode == 'ar' ? titleAr : titleEn;

  String localizedDescription(Locale locale) =>
      locale.languageCode == 'ar' ? descriptionAr : descriptionEn;
}
