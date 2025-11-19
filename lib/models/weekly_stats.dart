class WeeklyStats {
  WeeklyStats({
    required this.weekStart,
    required this.caloriesPerDay,
    required this.totalCalories,
    required this.completedDays,
  });

  final DateTime weekStart;
  final List<int> caloriesPerDay;
  final int totalCalories;
  final int completedDays;
}
