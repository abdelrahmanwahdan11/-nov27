import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../core/localization/app_localizations.dart';
import '../data/mock_food_items.dart';
import '../data/mock_stats.dart';
import '../models/community_models.dart';
import '../models/food_item.dart';
import '../models/weekly_stats.dart';
import '../models/wellness_models.dart';

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
  final List<FlowRoutine> _flowRoutines = [
    FlowRoutine(
      id: 'neon_wave',
      titleEn: 'Neon wave',
      titleAr: 'موجة نيون',
      descriptionEn: 'Alternating lunges, breath holds, and hydration cues.',
      descriptionAr: 'اندفاعات متناوبة مع حبس النفس وتلميحات الترطيب.',
      tempo: 126,
      loops: 3,
      intensity: .65,
      active: true,
    ),
    FlowRoutine(
      id: 'glow_core',
      titleEn: 'Glow core',
      titleAr: 'نواة التوهج',
      descriptionEn: 'Core pulses synced with straw sips and box breathing.',
      descriptionAr: 'نبضات للعضلات الأساسية متزامنة مع رشفات قصيرة وتنفس مربع.',
      tempo: 110,
      loops: 4,
      intensity: .5,
    ),
    FlowRoutine(
      id: 'skyline_dash',
      titleEn: 'Skyline dash',
      titleAr: 'اندفاع الأفق',
      descriptionEn: 'Low-impact jumps paired with mindful glances outdoors.',
      descriptionAr: 'قفزات خفيفة مع نظرات واعية نحو الأفق.',
      tempo: 140,
      loops: 5,
      intensity: .55,
    ),
  ];
  final List<FocusDrill> _focusDrills = [
    FocusDrill(
      id: 'blink_reset',
      cueEn: 'Blink reset',
      cueAr: 'إعادة ضبط الوميض',
      durationSeconds: 60,
      breaths: 6,
      progress: .3,
    ),
    FocusDrill(
      id: 'color_track',
      cueEn: 'Color tracking',
      cueAr: 'تتبع اللون',
      durationSeconds: 90,
      breaths: 8,
      progress: .5,
    ),
    FocusDrill(
      id: 'stillness_bell',
      cueEn: 'Stillness bell',
      cueAr: 'جرس السكون',
      durationSeconds: 120,
      breaths: 10,
      progress: .2,
    ),
  ];
  final List<JourneyMoment> _journeyMoments = [
    JourneyMoment(
      id: 'morning_glow',
      titleEn: 'Morning glow',
      titleAr: 'توهج الصباح',
      detailEn: 'Logged smoothies before sunrise and felt light.',
      detailAr: 'سجلت العصائر قبل الشروق وشعرت بالخفة.',
      moodColor: Colors.amber,
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    JourneyMoment(
      id: 'city_walk',
      titleEn: 'City walk',
      titleAr: 'نزهة المدينة',
      detailEn: 'Tracked slow breathing with the skyline lights.',
      detailAr: 'تابعت تنفساً بطيئاً مع أضواء المدينة.',
      moodColor: Colors.tealAccent,
      timestamp: DateTime.now().subtract(const Duration(hours: 18)),
    ),
    JourneyMoment(
      id: 'midnight_reset',
      titleEn: 'Midnight reset',
      titleAr: 'إعادة منتصف الليل',
      detailEn: 'Skipped scrolling, journaled three gratitude sparks.',
      detailAr: 'تركت التصفح وكتبت ثلاث ومضات امتنان.',
      moodColor: Colors.deepPurpleAccent,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
  final List<ChallengeRoutine> _challenges = [
    ChallengeRoutine(
      id: 'rise_glow',
      titleEn: 'Rise & Glow Hydration',
      titleAr: 'ترطيب الصباح المضيء',
      descriptionEn: 'Drink 3 neon glasses before noon and log mindful breaths.',
      descriptionAr: 'اشرب ثلاث أكواب قبل الظهر وسجل أنفاساً هادئة.',
      days: 5,
      reward: 'Glow badge',
      completedDays: 2,
    ),
    ChallengeRoutine(
      id: 'fiber_flow',
      titleEn: 'Fiber Flow Bowls',
      titleAr: 'أوعية الألياف',
      descriptionEn: 'Pack veggies in two meals each day and track satiety.',
      descriptionAr: 'أضف الخضار لوجبتين يومياً وتابع الشبع.',
      days: 7,
      reward: 'Fiber aura',
      completedDays: 4,
    ),
    ChallengeRoutine(
      id: 'moon_walk',
      titleEn: 'Moon Walk Evenings',
      titleAr: 'مساء القمر الهادىء',
      descriptionEn: 'Evening walks + smoothie cool-down before 9 pm.',
      descriptionAr: 'نزهة مسائية ومشروب منعش قبل التاسعة.',
      days: 10,
      reward: 'Calm streak',
      completedDays: 6,
    ),
  ];
  final List<CoachMessage> _coachMessages = [
    CoachMessage(
      id: 'welcome',
      text: 'Your neon coach is here — ready when you are.',
      fromCoach: true,
      timestamp: DateTime.now(),
    ),
  ];
  final List<String> _coachReplies = [
    'Add color to dinner with crunchy greens.',
    'Great streak! Sip water before coffee to stay balanced.',
    'Slow chewing keeps cravings quiet — try a 5-count bite.',
    'Celebrate rest as much as hustle. Breathe between tasks.',
  ];
  int _coachReplyIndex = 0;
  Timer? _coachReplyTimer;
  final List<RecipeIdea> _recipes = [
    RecipeIdea(
      id: 'citrus_flash',
      titleEn: 'Citrus Flash',
      titleAr: 'وميض الحمضيات',
      descriptionEn: 'Grapefruit, mint, coconut water sparkle.',
      descriptionAr: 'جريب فروت ونعناع وماء جوز الهند متلألئ.',
      image:
          'https://images.unsplash.com/photo-1464305795204-6f5bbfc7fb81?auto=format&fit=crop&w=800&q=80',
      calories: 180,
      sparkle: .7,
    ),
    RecipeIdea(
      id: 'neon_matcha',
      titleEn: 'Neon Matcha Float',
      titleAr: 'ماتشا نيون',
      descriptionEn: 'Matcha, oat milk foam, chia crunch.',
      descriptionAr: 'ماتشا مع حليب الشوفان ورشة شيا.',
      image:
          'https://images.unsplash.com/photo-1481391032119-d89fee407e44?auto=format&fit=crop&w=800&q=80',
      calories: 210,
      sparkle: .5,
    ),
    RecipeIdea(
      id: 'sunset_shake',
      titleEn: 'Sunset Shake',
      titleAr: 'ميلك شيك الغروب',
      descriptionEn: 'Mango, carrot, ginger, glowing turmeric.',
      descriptionAr: 'مانجو وجزر وزنجبيل وكركم لامع.',
      image:
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=800&q=80',
      calories: 195,
      sparkle: .65,
    ),
  ];
  final List<WellnessHabit> _habits = [
    WellnessHabit(
      id: 'sun_sip',
      titleEn: 'Sunrise sip',
      titleAr: 'جرعة الشروق',
      descriptionEn: 'Drink 400 ml before checking notifications.',
      descriptionAr: 'اشرب 400 مل قبل فتح الهاتف.',
      schedule: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
      focus: .7,
      streak: 6,
    ),
    WellnessHabit(
      id: 'walk_wrap',
      titleEn: 'Walk wrap-up',
      titleAr: 'ختام بالمشي',
      descriptionEn: '5-minute stroll after dinner to calm cravings.',
      descriptionAr: 'تمشى لخمس دقائق بعد العشاء لتهدئة الشهية.',
      schedule: const ['Daily'],
      focus: .5,
      streak: 12,
    ),
    WellnessHabit(
      id: 'color_plate',
      titleEn: 'Color plate',
      titleAr: 'طبق الألوان',
      descriptionEn: 'Add a neon color veggie to every plate.',
      descriptionAr: 'أضف خضاراً بلون لامع لكل طبق.',
      schedule: const ['Mon', 'Wed', 'Fri'],
      focus: .6,
      streak: 4,
    ),
  ];
  final List<GroceryItem> _groceries = [
    GroceryItem(
      id: 'spinach',
      nameEn: 'Baby spinach',
      nameAr: 'سبانخ طازجة',
      category: 'Fresh',
      quantity: 2,
    ),
    GroceryItem(
      id: 'chia',
      nameEn: 'Chia seeds',
      nameAr: 'بذور الشيا',
      category: 'Pantry',
      quantity: 1,
    ),
    GroceryItem(
      id: 'coconut',
      nameEn: 'Coconut water',
      nameAr: 'ماء جوز الهند',
      category: 'Drinks',
      quantity: 3,
    ),
  ];
  final List<InsightCard> _insights = [
    InsightCard(
      id: 'macro_balance',
      titleEn: 'Macro balance',
      titleAr: 'توازن المغذيات',
      bodyEn: 'Protein is holding 32% of today\'s energy. Keep colors in plates.',
      bodyAr: 'البروتين يشكل 32٪ من طاقتك اليوم. استمر في الألوان.',
      metricLabelEn: 'Balanced plates',
      metricLabelAr: 'أطباق متوازنة',
      metric: .72,
      trend: .12,
    ),
    InsightCard(
      id: 'hydration_wave',
      titleEn: 'Hydration wave',
      titleAr: 'موجة الترطيب',
      bodyEn: 'Night hydration improved 2 evenings in a row.',
      bodyAr: 'ترطيب المساء تحسن لليلتين متتاليتين.',
      metricLabelEn: 'Glow glasses',
      metricLabelAr: 'أكواب اللمعان',
      metric: .58,
      trend: .08,
    ),
    InsightCard(
      id: 'mindful_energy',
      titleEn: 'Mindful energy',
      titleAr: 'طاقة يقظة',
      bodyEn: 'Breathing pauses trimmed stress spikes this week.',
      bodyAr: 'فترات التنفس خففت التوتر هذا الأسبوع.',
      metricLabelEn: 'Calm minutes',
      metricLabelAr: 'دقائق الهدوء',
      metric: .64,
      trend: .05,
    ),
  ];
  final List<EnergyPattern> _energyPatterns = [
    EnergyPattern(
      id: 'pulse_focus',
      titleEn: 'Pulse focus',
      titleAr: 'نبض التركيز',
      descriptionEn: 'Four-count box breathing with gentle holds.',
      descriptionAr: 'تنفس صندوقي لأربع عدات مع ثبات هادئ.',
      length: const Duration(minutes: 4),
      intensity: .6,
    ),
    EnergyPattern(
      id: 'wave_stride',
      titleEn: 'Wave stride',
      titleAr: 'موجة الخطى',
      descriptionEn: 'Alternate nostril breathing plus shoulder rolls.',
      descriptionAr: 'تنفس تناوبي مع تدوير للكتفين.',
      length: const Duration(minutes: 6),
      intensity: .7,
    ),
    EnergyPattern(
      id: 'neon_flow',
      titleEn: 'Neon flow',
      titleAr: 'تدفق نيون',
      descriptionEn: '1-4-2 breath ladder synced with arm sweeps.',
      descriptionAr: 'سلم تنفس 1-4-2 متزامن مع حركة الذراع.',
      length: const Duration(minutes: 5),
      intensity: .8,
    ),
  ];
  final List<double> _energySparkline = [.32, .48, .58, .62, .66, .72, .68];
  double _energyCharge = .64;
  final List<SleepCue> _sleepCues = [
    SleepCue(
      id: 'dim',
      titleEn: 'Dim the room',
      titleAr: 'تعتيم الغرفة',
      detailEn: 'Switch to amber lights and silence notifications.',
      detailAr: 'أضئ أنواراً دافئة وأغلق الإشعارات.',
      emoji: '🕯️',
      duration: const Duration(minutes: 3),
    ),
    SleepCue(
      id: 'stretch',
      titleEn: 'Neck stretch',
      titleAr: 'تمدد الرقبة',
      detailEn: 'Slow neck rolls, inhale up and exhale down.',
      detailAr: 'حركات دائرية بطيئة للرقبة مع تنفس عميق.',
      emoji: '🌀',
      duration: const Duration(minutes: 4),
    ),
    SleepCue(
      id: 'journal',
      titleEn: 'Mini journal',
      titleAr: 'مذكرات قصيرة',
      detailEn: 'Write one gratitude line, park tomorrow’s tasks.',
      detailAr: 'اكتب سطر امتنان وصف مهام الغد.',
      emoji: '📓',
      duration: const Duration(minutes: 5),
    ),
    SleepCue(
      id: 'breath',
      titleEn: 'Cooling breath',
      titleAr: 'تنفس مبرد',
      detailEn: 'Sip air through teeth, exhale warm calm.',
      detailAr: 'اسحب الهواء عبر الأسنان وأخرج دفئاً هادئاً.',
      emoji: '🌙',
      duration: const Duration(minutes: 2),
    ),
  ];
  double _windDownProgress = .58;
  final List<MomentumMoment> _moments = [
    MomentumMoment(
      id: 'morning_glow',
      titleEn: 'Morning glow logged',
      titleAr: 'إشراقة الصباح مسجلة',
      detailEn: 'Added citrus shake and stretched wrists.',
      detailAr: 'أضفت عصير الحمضيات ومددت المعصمين.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      energy: .74,
    ),
    MomentumMoment(
      id: 'hydration_wave',
      titleEn: 'Hydration wave held',
      titleAr: 'موجة الترطيب ثابتة',
      detailEn: 'Finished 400 ml before noon meeting.',
      detailAr: 'أنهيت 400 مل قبل اجتماع الظهر.',
      timestamp: DateTime.now().subtract(const Duration(hours: 26)),
      energy: .66,
    ),
    MomentumMoment(
      id: 'night_walk',
      titleEn: 'Night walk synced',
      titleAr: 'مشى ليلي متناغم',
      detailEn: 'Logged 900 steps while calling a friend.',
      detailAr: 'سجلت 900 خطوة أثناء الاتصال بصديق.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      energy: .61,
    ),
  ];
  final List<MomentumMoment> _momentSeeds = [
    MomentumMoment(
      id: 'seed_focus',
      titleEn: 'Focus snack crafted',
      titleAr: 'وجبة تركيز مصنوعة',
      detailEn: 'Matcha, chia, and neon notes prepped for tomorrow.',
      detailAr: 'ماتشا وشيا ولمسات نيون جاهزة للغد.',
      timestamp: DateTime.now(),
      energy: .7,
    ),
    MomentumMoment(
      id: 'seed_breath',
      titleEn: 'Breath ladder completed',
      titleAr: 'سلم التنفس مكتمل',
      detailEn: 'Held 5 rounds of 4-4 breathing before lunch.',
      detailAr: 'أتممت 5 جولات من تنفس 4-4 قبل الغداء.',
      timestamp: DateTime.now(),
      energy: .73,
    ),
    MomentumMoment(
      id: 'seed_colors',
      titleEn: 'Color plate remixed',
      titleAr: 'طبق الألوان متجدد',
      detailEn: 'Added purple cabbage to evening bowl.',
      detailAr: 'أضفت الكرنب البنفسجي لطبق المساء.',
      timestamp: DateTime.now(),
      energy: .69,
    ),
  ];
  final Random _random = Random();
  final List<RecoverySession> _recoverySessions = [
    RecoverySession(
      id: 'lunar_rest',
      titleEn: 'Lunar rest',
      titleAr: 'استراحة قمرية',
      descriptionEn: 'Slow inhale, sip chamomile, journal a neon thought.',
      descriptionAr: 'تنفس ببطء واشرب البابونج وسجل فكرة متوهجة.',
      duration: const Duration(minutes: 8),
      energy: .35,
      tags: const ['breath', 'tea', 'journal'],
    ),
    RecoverySession(
      id: 'glow_walk',
      titleEn: 'Glow walk reset',
      titleAr: 'تنشيط مشي متوهج',
      descriptionEn: 'Step outside for 6 minutes and match breath with pace.',
      descriptionAr: 'اخرج لست دقائق وطابق التنفس مع الخطوات.',
      duration: const Duration(minutes: 6),
      energy: .5,
      tags: const ['movement', 'focus'],
    ),
    RecoverySession(
      id: 'orbit_nap',
      titleEn: 'Orbit nap',
      titleAr: 'غفوة المدار',
      descriptionEn: 'Close eyes, inhale for 4, hold 2, exhale 6.',
      descriptionAr: 'أغمض عينيك، شهيق 4، احتفاظ 2، زفير 6.',
      duration: const Duration(minutes: 12),
      energy: .62,
      tags: const ['breath', 'calm'],
    ),
  ];
  final List<RitualBlueprint> _rituals = [
    RitualBlueprint(
      id: 'dawn_flow',
      titleEn: 'Dawn flow',
      titleAr: 'تدفق الفجر',
      descriptionEn: 'Hydrate, stretch and visualize the neon day.',
      descriptionAr: 'ترطيب وتمدد وتخيل يومك المتوهج.',
      focus: .6,
      steps: [
        RitualStep(
          labelEn: '400 ml glow water',
          labelAr: '400 مل من ماء التوهج',
        ),
        RitualStep(
          labelEn: 'Two shoulder rolls',
          labelAr: 'دورتان للكتفين',
        ),
        RitualStep(
          labelEn: 'Set intention mantra',
          labelAr: 'ضع تعويذة النية',
        ),
      ],
    ),
    RitualBlueprint(
      id: 'noon_focus',
      titleEn: 'Noon focus',
      titleAr: 'تركيز الظهيرة',
      descriptionEn: 'Micro walk + mindful bite to avoid energy crash.',
      descriptionAr: 'مشي قصير ولقمة واعية لتجنب هبوط الطاقة.',
      focus: .45,
      steps: [
        RitualStep(
          labelEn: 'Stand up + stretch',
          labelAr: 'قف وتمدد',
        ),
        RitualStep(
          labelEn: 'Breathe 4-4-4',
          labelAr: 'تنفس 4-4-4',
        ),
        RitualStep(
          labelEn: 'Crunchy veggie snack',
          labelAr: 'وجبة خضار مقرمشة',
        ),
      ],
    ),
  ];
  final List<RewardBadge> _rewards = [
    RewardBadge(
      id: 'hydration_wave',
      titleEn: 'Hydration wave',
      titleAr: 'موجة الترطيب',
      descriptionEn: 'Log hydration 3 days in a row.',
      descriptionAr: 'سجل الترطيب لثلاثة أيام متتالية.',
      points: 120,
      unlocked: true,
    ),
    RewardBadge(
      id: 'macro_artist',
      titleEn: 'Macro artist',
      titleAr: 'فنان المغذيات',
      descriptionEn: 'Balance macros for five meals.',
      descriptionAr: 'وازن المغذيات لخمسة وجبات.',
      points: 180,
    ),
    RewardBadge(
      id: 'calm_commander',
      titleEn: 'Calm commander',
      titleAr: 'قائد الهدوء',
      descriptionEn: 'Finish two recovery sessions in a day.',
      descriptionAr: 'أكمل جلستي استرخاء في يوم واحد.',
      points: 160,
    ),
    RewardBadge(
      id: 'sharing_star',
      titleEn: 'Sharing star',
      titleAr: 'نجم المشاركة',
      descriptionEn: 'Add three reflections.',
      descriptionAr: 'أضف ثلاث مذكرات.',
      points: 90,
    ),
  ];
  int _customRecoveryCounter = 0;
  final List<String> _insightHighlights = [
    'Macros held steady for 4 dinners.',
    'Hydration streak unlocked neon clarity.',
    'Mindful walks kept cravings below target.',
    'Fiber bowls added an extra 9g yesterday.',
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
  List<ChallengeRoutine> get challenges => List.unmodifiable(_challenges);
  List<CoachMessage> get coachMessages => List.unmodifiable(_coachMessages);
  List<RecipeIdea> get recipeIdeas => List.unmodifiable(_recipes);
  List<WellnessHabit> get habits => List.unmodifiable(_habits);
  List<GroceryItem> get groceryItems => List.unmodifiable(_groceries);
  List<InsightCard> get insightCards => List.unmodifiable(_insights);
  List<EnergyPattern> get energyPatterns => List.unmodifiable(_energyPatterns);
  List<double> get energySparkline => List.unmodifiable(_energySparkline);
  double get energyCharge => _energyCharge;
  List<SleepCue> get sleepCues => List.unmodifiable(_sleepCues);
  double get windDownProgress => _windDownProgress;
  List<MomentumMoment> get momentumMoments => List.unmodifiable(_moments);
  List<RecoverySession> get recoverySessions =>
      List.unmodifiable(_recoverySessions);
  List<RitualBlueprint> get ritualBlueprints => List.unmodifiable(_rituals);
  List<RewardBadge> get rewardBadges => List.unmodifiable(_rewards);
  List<String> get insightHighlights => List.unmodifiable(_insightHighlights);

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

  List<FlowRoutine> get flowRoutines => List.unmodifiable(_flowRoutines);

  void toggleFlowRoutine(String id) {
    final routine = _flowRoutines.firstWhere((element) => element.id == id);
    routine.active = !routine.active;
    notifyListeners();
  }

  void updateFlowRoutineIntensity(String id, double value) {
    final routine = _flowRoutines.firstWhere((element) => element.id == id);
    routine.intensity = value;
    notifyListeners();
  }

  void shuffleFlowRoutines() {
    for (final routine in _flowRoutines) {
      routine.intensity = Random().nextDouble().clamp(.2, .95);
      routine.active = Random().nextBool();
    }
    notifyListeners();
  }

  List<FocusDrill> get focusDrills => List.unmodifiable(_focusDrills);

  void nudgeFocusDrill(String id, [double delta = .1]) {
    final drill = _focusDrills.firstWhere((element) => element.id == id);
    drill.progress = (drill.progress + delta).clamp(0, 1);
    notifyListeners();
  }

  void completeFocusDrill(String id) {
    final drill = _focusDrills.firstWhere((element) => element.id == id);
    drill.completed = true;
    drill.progress = 1;
    _moodLevel = (_moodLevel + 1).clamp(1, 5);
    notifyListeners();
  }

  void resetFocusDrills() {
    for (final drill in _focusDrills) {
      drill.completed = false;
      drill.progress = 0;
    }
    notifyListeners();
  }

  List<JourneyMoment> get journeyMoments => List.unmodifiable(_journeyMoments);

  void addJourneyMoment({
    required String titleEn,
    required String titleAr,
    required String detailEn,
    required String detailAr,
    Color? moodColor,
  }) {
    final now = DateTime.now();
    _journeyMoments.insert(
      0,
      JourneyMoment(
        id: now.millisecondsSinceEpoch.toString(),
        titleEn: titleEn,
        titleAr: titleAr,
        detailEn: detailEn,
        detailAr: detailAr,
        moodColor: moodColor ?? Colors.amberAccent,
        timestamp: now,
      ),
    );
    notifyListeners();
  }

  void boostEnergy(double delta) {
    _energyCharge = (_energyCharge + delta).clamp(0.0, 1.0);
    _pulseSparkline();
    notifyListeners();
  }

  void toggleEnergyPattern(String id) {
    for (final pattern in _energyPatterns) {
      if (pattern.id == id) {
        pattern.active = !pattern.active;
        pattern.intensity =
            (pattern.intensity + (_random.nextDouble() * .2 - .1)).clamp(.3, 1);
      } else {
        pattern.active = false;
      }
    }
    notifyListeners();
  }

  void shuffleEnergyPatterns() {
    _energyPatterns.shuffle();
    notifyListeners();
  }

  void toggleSleepCue(String id) {
    final cue = _sleepCues.firstWhere((element) => element.id == id);
    cue.completed = !cue.completed;
    final completed = _sleepCues.where((c) => c.completed).length;
    _windDownProgress = (completed / _sleepCues.length).clamp(0, 1);
    notifyListeners();
  }

  void updateWindDownProgress(double value) {
    _windDownProgress = value.clamp(0, 1);
    notifyListeners();
  }

  void addRandomMomentum() {
    final template = _momentSeeds[_random.nextInt(_momentSeeds.length)];
    _moments.insert(
      0,
      MomentumMoment(
        id: 'moment_${DateTime.now().millisecondsSinceEpoch}',
        titleEn: template.titleEn,
        titleAr: template.titleAr,
        detailEn: template.detailEn,
        detailAr: template.detailAr,
        timestamp: DateTime.now(),
        energy: (template.energy + (_random.nextDouble() * .12 - .06))
            .clamp(.4, .95),
      ),
    );
    notifyListeners();
  }

  void addManualMomentum(String detail) {
    if (detail.trim().isEmpty) return;
    _moments.insert(
      0,
      MomentumMoment(
        id: 'note_${DateTime.now().millisecondsSinceEpoch}',
        titleEn: 'Manual reflection',
        titleAr: 'ملاحظة ذاتية',
        detailEn: detail,
        detailAr: detail,
        timestamp: DateTime.now(),
        energy: (.55 + _random.nextDouble() * .25).clamp(.4, .95),
      ),
    );
    if (_reflections.length > 8) {
      _reflections.removeLast();
    }
    _reflections.insert(0, detail);
    notifyListeners();
  }

  void shuffleMoments() {
    _moments.shuffle();
    notifyListeners();
  }

  void _pulseSparkline() {
    final next = (_energySparkline.last + (_random.nextDouble() * .14 - .07))
        .clamp(.2, .95);
    _energySparkline
      ..removeAt(0)
      ..add(next);
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

  void toggleRecovery(String id) {
    final session = _recoverySessions.firstWhere((element) => element.id == id);
    session.completed = !session.completed;
    notifyListeners();
  }

  void updateRecoveryEnergy(String id, double value) {
    final session = _recoverySessions.firstWhere((element) => element.id == id);
    session.energy = value.clamp(0, 1);
    notifyListeners();
  }

  void shuffleRecoverySessions() {
    _recoverySessions.shuffle(Random());
    notifyListeners();
  }

  void addCustomRecoverySession() {
    _customRecoveryCounter++;
    _recoverySessions.add(
      RecoverySession(
        id: 'custom_$_customRecoveryCounter',
        titleEn: 'Glow pause $_customRecoveryCounter',
        titleAr: 'وقفة متوهجة $_customRecoveryCounter',
        descriptionEn: 'Sip water, breathe, jot one gratitude.',
        descriptionAr: 'اشرب ماء وتنفس ودون امتناناً واحداً.',
        duration: Duration(minutes: 5 + _customRecoveryCounter),
        energy: .4 + ((_customRecoveryCounter % 4) * .1),
        tags: const ['gratitude', 'calm'],
      ),
    );
    notifyListeners();
  }

  void updateRitualFocus(String id, double focus) {
    final ritual = _rituals.firstWhere((element) => element.id == id);
    ritual.focus = focus.clamp(0, 1);
    notifyListeners();
  }

  void toggleRitualStep(String id, int index) {
    final ritual = _rituals.firstWhere((element) => element.id == id);
    if (index < 0 || index >= ritual.steps.length) return;
    ritual.steps[index].completed = !ritual.steps[index].completed;
    notifyListeners();
  }

  void addRitualStep(String id, String label) {
    final trimmed = label.trim();
    if (trimmed.isEmpty) return;
    final ritual = _rituals.firstWhere((element) => element.id == id);
    ritual.steps.add(
      RitualStep(
        labelEn: trimmed,
        labelAr: trimmed,
      ),
    );
    notifyListeners();
  }

  void unlockReward(String id) {
    final reward = _rewards.firstWhere((element) => element.id == id);
    if (reward.unlocked) return;
    reward.unlocked = true;
    notifyListeners();
  }

  int get unlockedRewards =>
      _rewards.where((element) => element.unlocked).length;

  int get totalVaultPoints => _rewards.fold(
      0,
      (previousValue, element) =>
          previousValue + (element.unlocked ? element.points : 0));

  void refreshMindfulStories() {
    _mindfulStories.shuffle(Random());
    notifyListeners();
  }

  void toggleChallenge(String id) {
    final challenge = _challenges.firstWhere((c) => c.id == id);
    challenge.joined = !challenge.joined;
    if (!challenge.joined) {
      challenge.completedDays = 0;
    }
    notifyListeners();
  }

  void incrementChallengeDay(String id) {
    final challenge = _challenges.firstWhere((c) => c.id == id);
    if (!challenge.joined) return;
    if (challenge.completedDays < challenge.days) {
      challenge.completedDays++;
      notifyListeners();
    }
  }

  void sendCoachMessage(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    _coachMessages.add(
      CoachMessage(
        id: UniqueKey().toString(),
        text: trimmed,
        fromCoach: false,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
    _coachReplyTimer?.cancel();
    _coachReplyTimer = Timer(const Duration(milliseconds: 600), () {
      final reply = _coachReplies[_coachReplyIndex % _coachReplies.length];
      _coachReplyIndex++;
      _coachMessages.add(
        CoachMessage(
          id: UniqueKey().toString(),
          text: reply,
          fromCoach: true,
          timestamp: DateTime.now(),
        ),
      );
      notifyListeners();
    });
  }

  void toggleRecipeFavorite(String id) {
    final recipe = _recipes.firstWhere((r) => r.id == id);
    recipe.favorite = !recipe.favorite;
    notifyListeners();
  }

  void updateRecipeSparkle(String id, double sparkle) {
    final recipe = _recipes.firstWhere((r) => r.id == id);
    recipe.sparkle = sparkle.clamp(0, 1);
    notifyListeners();
  }

  void toggleHabit(String id) {
    final habit = _habits.firstWhere((h) => h.id == id);
    habit.enabled = !habit.enabled;
    notifyListeners();
  }

  void setHabitFocus(String id, double focus) {
    final habit = _habits.firstWhere((h) => h.id == id);
    habit.focus = focus;
    notifyListeners();
  }

  void boostHabitStreak(String id) {
    final habit = _habits.firstWhere((h) => h.id == id);
    habit.streak++;
    notifyListeners();
  }

  void toggleGroceryPurchased(String id) {
    final item = _groceries.firstWhere((g) => g.id == id);
    item.purchased = !item.purchased;
    notifyListeners();
  }

  void updateGroceryQuantity(String id, int delta) {
    final item = _groceries.firstWhere((g) => g.id == id);
    item.quantity = (item.quantity + delta).clamp(1, 12);
    notifyListeners();
  }

  void addGroceryItem({
    required String nameEn,
    required String nameAr,
    String category = 'Fresh',
    int quantity = 1,
  }) {
    final newItem = GroceryItem(
      id: UniqueKey().toString(),
      nameEn: nameEn,
      nameAr: nameAr,
      category: category,
      quantity: quantity,
    );
    _groceries.insert(0, newItem);
    notifyListeners();
  }

  void removeGroceryItem(String id) {
    _groceries.removeWhere((g) => g.id == id);
    notifyListeners();
  }

  void refreshInsights() {
    final rng = Random();
    for (final card in _insights) {
      card.trend = (card.trend + rng.nextDouble() * .2 - .1).clamp(-1, 1);
      card.metric = (card.metric + rng.nextDouble() * .2 - .1).clamp(0, 1);
    }
    _insights.shuffle(rng);
    _insightHighlights.shuffle(rng);
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

  @override
  void dispose() {
    _debounce?.cancel();
    _coachReplyTimer?.cancel();
    super.dispose();
  }
}
