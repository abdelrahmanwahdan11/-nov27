import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../core/localization/app_localizations.dart';
import '../data/mock_food_items.dart';
import '../data/mock_stats.dart';
import '../models/food_item.dart';
import '../models/weekly_stats.dart';

class DietController extends ChangeNotifier {
  DietController();

  final List<FoodItem> _items = List.of(mockFoodItems);
  final List<FoodItem> _visibleItems = [];
  final List<WeeklyStats> _weekly = mockWeeklyStats;
  final Set<String> _comparisonIds = {};
  double _maxCalories = 600;
  String _search = '';
  String? _category;
  bool _ascending = true;
  Timer? _debounce;
  int _page = 0;
  final int _pageSize = 6;
  bool _loading = false;
  final double _hydrationTarget = 2400;
  double _hydrationConsumed = 1200;
  int _moodLevel = 3;
  final List<String> _reflections = [
    'Feeling lighter after sticking to greens today.',
    'Focused breathing helped reduce afternoon cravings.',
  ];
  final List<String> _mindfulStories = [
    'Imagine a neon sunrise as you sip your smoothie; match your breath to its glow.',
    'Stretch your spine before logging meals — create space for mindful bites.',
    'Pick one color for today\'s plate and celebrate it in every dish.',
    'Slow down the first sip, notice texture, temperature, scent.',
  ];

  List<FoodItem> get visibleItems => List.unmodifiable(_visibleItems);
  Set<String> get comparisonIds => _comparisonIds;
  double get maxCalories => _maxCalories;
  String? get category => _category;
  bool get loading => _loading;
  WeeklyStats get currentWeek => _weekly[_currentWeekIndex];
  int _currentWeekIndex = 0;
  double get hydrationProgress =>
      (_hydrationConsumed / _hydrationTarget).clamp(0, 1);
  double get hydrationConsumed => _hydrationConsumed;
  double get hydrationTarget => _hydrationTarget;
  int get moodLevel => _moodLevel;
  List<String> get reflections => List.unmodifiable(_reflections);
  List<String> get mindfulStories => List.unmodifiable(_mindfulStories);

  void init() {
    _applyFilters(reset: true);
  }

  void disposeDebounce() {
    _debounce?.cancel();
  }

  void changeWeek(int direction) {
    _currentWeekIndex = (_currentWeekIndex + direction) % _weekly.length;
    if (_currentWeekIndex < 0) {
      _currentWeekIndex = _weekly.length - 1;
    }
    notifyListeners();
  }

  void setSearch(String value) {
    _search = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _applyFilters(reset: true);
    });
  }

  void setCategory(String? value) {
    _category = value;
    _applyFilters(reset: true);
  }

  void setMaxCalories(double value) {
    _maxCalories = value;
    _applyFilters(reset: true);
  }

  void toggleSortOrder() {
    _ascending = !_ascending;
    _applyFilters(reset: true);
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
    _applyFilters(reset: true);
  }

  Future<void> loadMore() async {
    if (_loading) return;
    _loading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 400));
    _page++;
    _applyFilters();
    _loading = false;
    notifyListeners();
  }

  void toggleComparison(FoodItem item, BuildContext context) {
    if (_comparisonIds.contains(item.id)) {
      _comparisonIds.remove(item.id);
    } else {
      if (_comparisonIds.length >= 3) {
        final texts = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(texts.translate('comparison_limit'))),
        );
        return;
      }
      _comparisonIds.add(item.id);
    }
    notifyListeners();
  }

  List<FoodItem> get comparisonItems =>
      _items.where((item) => _comparisonIds.contains(item.id)).toList();

  void removeComparison(String id) {
    _comparisonIds.remove(id);
    notifyListeners();
  }

  void clearComparison() {
    _comparisonIds.clear();
    notifyListeners();
  }

  void logHydration(double ml) {
    _hydrationConsumed = min(_hydrationConsumed + ml, _hydrationTarget);
    notifyListeners();
  }

  void resetHydration() {
    _hydrationConsumed = 0;
    notifyListeners();
  }

  void updateMood(int level) {
    _moodLevel = level.clamp(1, 5);
    notifyListeners();
  }

  void addReflection(String text) {
    final cleaned = text.trim();
    if (cleaned.isEmpty) return;
    _reflections.insert(0, cleaned);
    if (_reflections.length > 10) {
      _reflections.removeLast();
    }
    notifyListeners();
  }

  void refreshMindfulStories() {
    _mindfulStories.shuffle(Random());
    notifyListeners();
  }

  void _applyFilters({bool reset = false}) {
    if (reset) {
      _page = 0;
      _visibleItems.clear();
    }
    Iterable<FoodItem> filtered = _items;
    if (_category != null) {
      filtered = filtered.where((item) => item.category == _category);
    }
    filtered = filtered.where((item) => item.calories <= _maxCalories);
    if (_search.isNotEmpty) {
      filtered = filtered.where((item) {
        final query = _search.toLowerCase();
        return item.nameEn.toLowerCase().contains(query) ||
            item.nameAr.contains(_search) ||
            item.category.toLowerCase().contains(query) ||
            item.tags.any((t) => t.toLowerCase().contains(query));
      });
    }
    final sorted = filtered.toList()
      ..sort((a, b) => _ascending
          ? a.calories.compareTo(b.calories)
          : b.calories.compareTo(a.calories));
    final end = ((_page + 1) * _pageSize).clamp(0, sorted.length);
    _visibleItems
      ..clear()
      ..addAll(sorted.take(end));
    notifyListeners();
  }
}
