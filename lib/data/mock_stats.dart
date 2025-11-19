import '../models/weekly_stats.dart';

final List<WeeklyStats> mockWeeklyStats = List.generate(
  4,
  (index) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: index * 7));
    final calories = List<int>.generate(
      7,
      (i) => 1800 + (i * 120) + index * 40,
    );
    return WeeklyStats(
      weekStart: weekStart,
      caloriesPerDay: calories,
      totalCalories: calories.reduce((a, b) => a + b),
      completedDays: 4 + index,
    );
  },
);
