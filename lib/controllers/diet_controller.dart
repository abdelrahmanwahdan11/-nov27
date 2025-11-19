import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../core/localization/app_localizations.dart';
import '../data/mock_food_items.dart';
import '../data/mock_stats.dart';
import '../models/community_models.dart';
import '../models/food_item.dart';
import '../models/growth_models.dart';
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
  final List<SerenityModule> _serenityModules = [
    SerenityModule(
      id: 'lunar_drift',
      titleEn: 'Lunar drift',
      titleAr: 'انجراف قمري',
      mantraEn: 'Lengthen exhale, float with the glow.',
      mantraAr: 'أطل الزفير وتمايل مع التوهج.',
      depth: .45,
      breaths: 8,
      cues: const ['4s inhale', '2s hold', '6s exhale'],
    ),
    SerenityModule(
      id: 'glow_anchor',
      titleEn: 'Glow anchor',
      titleAr: 'مرساة التوهج',
      mantraEn: 'Sip slow, root the shoulders, melt the jaw.',
      mantraAr: 'ارتشف ببطء، ثبّت الكتفين، وأذب الفك.',
      depth: .6,
      breaths: 10,
      cues: const ['Sip', 'Roll shoulders', 'Smile'],
    ),
    SerenityModule(
      id: 'horizon_wave',
      titleEn: 'Horizon wave',
      titleAr: 'موجة الأفق',
      mantraEn: 'Trace skyline lights with a soft gaze.',
      mantraAr: 'اتبع أضواء الأفق بنظرة هادئة.',
      depth: .7,
      breaths: 12,
      cues: const ['Reach', 'Breathe', 'Release'],
    ),
  ];
  int _activeSerenityIndex = 0;
  final List<MomentumPulse> _momentumPulses = [
    MomentumPulse(
      id: 'sip_reset',
      titleEn: 'Sip reset',
      titleAr: 'إعادة رشفة',
      descriptionEn: 'Mini hydration burst after meetings.',
      descriptionAr: 'اندفاع ترطيب صغير بعد الاجتماعات.',
      goal: .9,
      progress: .4,
    ),
    MomentumPulse(
      id: 'stairs_glow',
      titleEn: 'Stairs glow',
      titleAr: 'توهج الدرج',
      descriptionEn: 'Climb two flights with breath counts.',
      descriptionAr: 'اصعد طابقين مع عدّ الأنفاس.',
      goal: .8,
      progress: .3,
    ),
    MomentumPulse(
      id: 'gratitude_ping',
      titleEn: 'Gratitude ping',
      titleAr: 'إشارة الامتنان',
      descriptionEn: 'Send a thank-you note before dinner.',
      descriptionAr: 'أرسل رسالة شكر قبل العشاء.',
      goal: 1,
      progress: .5,
    ),
  ];
  final List<GratitudeMoment> _gratitudeMoments = [
    GratitudeMoment(
      id: 'spark_morning',
      messageEn: 'Sunrise walk felt like a soft neon curtain.',
      messageAr: 'نزهة الشروق بدت كستارة نيون ناعمة.',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      moodColor: Colors.amberAccent,
    ),
    GratitudeMoment(
      id: 'spark_midday',
      messageEn: 'Shared smoothie recipes with the team.',
      messageAr: 'شاركت وصفات العصير مع الفريق.',
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      moodColor: Colors.tealAccent,
    ),
    GratitudeMoment(
      id: 'spark_evening',
      messageEn: 'Called mom while brewing mint tea.',
      messageAr: 'اتصلت بوالدتي أثناء إعداد شاي النعناع.',
      createdAt: DateTime.now().subtract(const Duration(hours: 15)),
      moodColor: Colors.pinkAccent,
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
  final List<PulseWave> _pulseWaves = [
    PulseWave(
      id: 'aurora_sync',
      titleEn: 'Aurora sync',
      titleAr: 'تزامن الشفق',
      charge: .68,
      calm: .52,
      graph: [.32, .54, .7, .58, .64, .72, .67],
    ),
    PulseWave(
      id: 'city_still',
      titleEn: 'City stillness',
      titleAr: 'سكون المدينة',
      charge: .46,
      calm: .8,
      graph: [.22, .3, .42, .6, .74, .62, .51],
    ),
    PulseWave(
      id: 'pulse_dash',
      titleEn: 'Pulse dash',
      titleAr: 'اندفاع النبض',
      charge: .82,
      calm: .4,
      graph: [.4, .58, .8, .72, .9, .78, .7],
    ),
  ];
  int _pulseIndex = 0;
  final List<MacroBlueprint> _macroBlueprints = [
    MacroBlueprint(
      id: 'radiant_reset',
      titleEn: 'Radiant reset',
      titleAr: 'إعادة الإشراق',
      descriptionEn: 'Greens, ginger shots, and coconut water balance.',
      descriptionAr: 'خضار ولقطات زنجبيل وماء جوز الهند للتوازن.',
      protein: 32,
      carbs: 48,
      fats: 18,
      micros: 12,
      glow: .62,
    ),
    MacroBlueprint(
      id: 'glow_forge',
      titleEn: 'Glow forge',
      titleAr: 'مصنع التوهج',
      descriptionEn: 'Vibrant smoothie bowls with chia crunch.',
      descriptionAr: 'أوعية سموذي نابضة مع قرمشة الشيا.',
      protein: 28,
      carbs: 56,
      fats: 16,
      micros: 15,
      glow: .5,
    ),
    MacroBlueprint(
      id: 'lunar_sustain',
      titleEn: 'Lunar sustain',
      titleAr: 'استدامة قمرية',
      descriptionEn: 'Evening soups, oats, and calming cacao.',
      descriptionAr: 'شوربات مسائية وشوفان وكاكاو مهدئ.',
      protein: 24,
      carbs: 40,
      fats: 22,
      micros: 18,
      glow: .74,
    ),
  ];
  int _macroIndex = 0;
  final List<LegacyCapsule> _legacyCapsules = [
    LegacyCapsule(
      id: 'capsule_morning',
      titleEn: 'Morning promise',
      titleAr: 'وعد الصباح',
      noteEn: 'Future me drinks water before any glow latte.',
      noteAr: 'ذاتي المستقبلية تشرب الماء قبل أي لاتيه متوهج.',
      timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      moodColor: Colors.amberAccent,
    ),
    LegacyCapsule(
      id: 'capsule_stars',
      titleEn: 'Under the stars',
      titleAr: 'تحت النجوم',
      noteEn: 'Night walks keep lungs light and thoughts gentle.',
      noteAr: 'نزهات الليل تبقي الرئتين خفيفتين والأفكار ناعمة.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      moodColor: Colors.purpleAccent,
    ),
    LegacyCapsule(
      id: 'capsule_future',
      titleEn: 'Future broadcast',
      titleAr: 'رسالة المستقبل',
      noteEn: 'Remember the neon goal: nourish, breathe, repeat.',
      noteAr: 'تذكر هدف النيون: تغذية وتنفس وتكرار.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      moodColor: Colors.tealAccent,
    ),
  ];
  final List<EclipseProgram> _eclipsePrograms = [
    EclipseProgram(
      id: 'orbit_focus',
      titleEn: 'Orbit focus',
      titleAr: 'تركيز المدار',
      focusEn: 'Align posture with citrus breathing.',
      focusAr: 'اضبط الوقفة مع تنفس الحمضيات.',
      loops: 3,
      alignment: .72,
      wave: [.12, .42, .74, .68, .8, .62, .7],
      accent: Colors.amberAccent,
      active: true,
    ),
    EclipseProgram(
      id: 'lunar_hum',
      titleEn: 'Lunar hum',
      titleAr: 'همهمة قمرية',
      focusEn: 'Evening sip cadence with hum-backed exhales.',
      focusAr: 'إيقاع رشفات مسائي مع زفير هامس.',
      loops: 4,
      alignment: .64,
      wave: [.2, .38, .5, .62, .58, .7, .54],
      accent: Colors.deepPurpleAccent,
    ),
    EclipseProgram(
      id: 'solar_stride',
      titleEn: 'Solar stride',
      titleAr: 'خطوة شمسية',
      focusEn: 'Stride, sip, and hold with sunrise playlists.',
      focusAr: 'خطوة ورشفة وتوقف مع قوائم شروق.',
      loops: 5,
      alignment: .78,
      wave: [.3, .52, .74, .82, .76, .84, .72],
      accent: Colors.tealAccent,
    ),
  ];
  double _clarityFocus = .66;
  final List<ClaritySignal> _claritySignals = [
    ClaritySignal(
      id: 'lens_reset',
      labelEn: 'Lens reset',
      labelAr: 'إعادة العدسة',
      descriptionEn: 'Blink slow, sip mint, relax the jaw.',
      descriptionAr: 'أغمض ببطء واشرب النعناع وأرخ الفك.',
      current: .48,
      target: .76,
      trend: .18,
    ),
    ClaritySignal(
      id: 'focus_arc',
      labelEn: 'Focus arc',
      labelAr: 'قوس التركيز',
      descriptionEn: '20-second gaze ladder plus breath ladder.',
      descriptionAr: 'سلم نظرات 20 ثانية مع سلم أنفاس.',
      current: .6,
      target: .82,
      trend: .1,
    ),
    ClaritySignal(
      id: 'calm_scan',
      labelEn: 'Calm scan',
      labelAr: 'مسح الهدوء',
      descriptionEn: 'Neck roll, straw sip, shoulder soften.',
      descriptionAr: 'لف الرقبة، رشفة بالقصبة، أكتاف لينة.',
      current: .55,
      target: .78,
      trend: .04,
    ),
  ];
  final List<SyncDrill> _syncDrills = [
    SyncDrill(
      id: 'triad_flow',
      titleEn: 'Triad flow',
      titleAr: 'تدفق ثلاثي',
      cuesEn: ['Inhale count', 'Hold + sip', 'Side tilt reset'],
      cuesAr: ['عد الشهيق', 'توقف مع رشفة', 'ميل جانبي لإعادة الضبط'],
      rounds: 3,
      progress: .4,
      completedRounds: 1,
    ),
    SyncDrill(
      id: 'pulse_circle',
      titleEn: 'Pulse circle',
      titleAr: 'دائرة النبض',
      cuesEn: ['Tap shoulders', 'Rotate wrists', 'Sip + smile'],
      cuesAr: ['طرق على الكتفين', 'لف المعصمين', 'رشفة وابتسامة'],
      rounds: 4,
      progress: .25,
    ),
    SyncDrill(
      id: 'glow_chain',
      titleEn: 'Glow chain',
      titleAr: 'سلسلة التوهج',
      cuesEn: ['Count steps', 'Share gratitude', 'Hydration cheer'],
      cuesAr: ['عد الخطوات', 'شارك الامتنان', 'تحية الترطيب'],
      rounds: 5,
      progress: .2,
    ),
  ];
  final List<GrowthMission> _growthMissions = [
    GrowthMission(
      id: 'macro_focus',
      titleEn: 'Macro focus sprints',
      titleAr: 'سباقات تركيز المغذيات',
      descriptionEn: 'Log three balanced plates with bold veggie tones.',
      descriptionAr: 'سجل ثلاث وجبات متوازنة مع ألوان خضار بارزة.',
      target: 3,
      progress: 1,
      highlighted: true,
    ),
    GrowthMission(
      id: 'breath_walks',
      titleEn: 'Breath-synced walks',
      titleAr: 'نزهات متزامنة مع التنفس',
      descriptionEn: 'Pair 10-minute walks with inhale-exhale counts.',
      descriptionAr: 'اربط نزهات عشر دقائق بعدّات الشهيق والزفير.',
      target: 5,
      progress: 2,
    ),
    GrowthMission(
      id: 'gratitude_bursts',
      titleEn: 'Gratitude bursts',
      titleAr: 'ومضات الامتنان',
      descriptionEn: 'Capture micro journal sparks after meals.',
      descriptionAr: 'دوّن شرارات الامتنان الصغيرة بعد الوجبات.',
      target: 7,
      progress: 4,
    ),
  ];
  final List<RhythmCard> _rhythmCards = [
    RhythmCard(
      id: 'pulse_wave',
      titleEn: 'Pulse wave',
      titleAr: 'موجة النبض',
      subtitleEn: 'Guide exhale to neon pulses.',
      subtitleAr: 'وجّه الزفير مع نبضات النيون.',
      bpm: 62,
      waves: 3,
      focus: .45,
    ),
    RhythmCard(
      id: 'city_flow',
      titleEn: 'City flow',
      titleAr: 'تدفق المدينة',
      subtitleEn: 'Match stride to skyline lights.',
      subtitleAr: 'زامن الخطوات مع أضواء الأفق.',
      bpm: 78,
      waves: 4,
      focus: .6,
    ),
    RhythmCard(
      id: 'slow_bloom',
      titleEn: 'Slow bloom',
      titleAr: 'تفتح بطيء',
      subtitleEn: 'Hold space between sips.',
      subtitleAr: 'اصنع مساحة بين الرشفات.',
      bpm: 54,
      waves: 2,
      focus: .35,
    ),
  ];
  final List<VisionEntry> _visionEntries = [
    VisionEntry(
      id: 'neon_table',
      titleEn: 'Neon table',
      titleAr: 'طاولة نيون',
      noteEn: 'Host a brunch with glowing citrus boards.',
      noteAr: 'استضف فطوراً بلوحات حمضيات متوهجة.',
      moodColor: Colors.amberAccent,
      pinned: true,
    ),
    VisionEntry(
      id: 'skyline_run',
      titleEn: 'Skyline run',
      titleAr: 'ركض الأفق',
      noteEn: 'Track a sunrise jog with breathing beats.',
      noteAr: 'تتبع ركض شروق الشمس بنبضات التنفس.',
      moodColor: Colors.lightBlueAccent,
    ),
    VisionEntry(
      id: 'desert_reset',
      titleEn: 'Desert reset',
      titleAr: 'إعادة الصحراء',
      noteEn: 'Weekend retreat with sand meditations.',
      noteAr: 'استراحة أسبوعية مع تأملات الرمال.',
      moodColor: Colors.pinkAccent,
    ),
  ];
  final List<Color> _visionPalette = [
    Colors.amberAccent,
    Colors.lightBlueAccent,
    Colors.pinkAccent,
    Colors.tealAccent,
    Colors.deepPurpleAccent,
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
  List<PulseWave> get pulseWaves => List.unmodifiable(_pulseWaves);
  PulseWave get currentPulseWave => _pulseWaves[_pulseIndex];
  List<MacroBlueprint> get macroBlueprints =>
      List.unmodifiable(_macroBlueprints);
  MacroBlueprint get highlightedBlueprint =>
      _macroBlueprints[_macroIndex];
  List<LegacyCapsule> get legacyCapsules =>
      List.unmodifiable(_legacyCapsules);
  List<LegacyCapsule> get recentLegacyCapsules =>
      _legacyCapsules.take(3).toList();
  List<EclipseProgram> get eclipsePrograms =>
      List.unmodifiable(_eclipsePrograms);
  double get clarityFocus => _clarityFocus;
  List<ClaritySignal> get claritySignals =>
      List.unmodifiable(_claritySignals);
  List<SyncDrill> get syncDrills => List.unmodifiable(_syncDrills);
  List<RecipeIdea> get recipeIdeas => List.unmodifiable(_recipes);
  List<WellnessHabit> get habits => List.unmodifiable(_habits);
  List<GroceryItem> get groceryItems => List.unmodifiable(_groceries);
  List<InsightCard> get insightCards => List.unmodifiable(_insights);
  List<GrowthMission> get growthMissions => List.unmodifiable(_growthMissions);
  List<RhythmCard> get rhythmCards => List.unmodifiable(_rhythmCards);
  List<VisionEntry> get visionEntries => List.unmodifiable(_visionEntries);
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
  List<SerenityModule> get serenityModules => List.unmodifiable(_serenityModules);
  SerenityModule get activeSerenityModule =>
      _serenityModules[_activeSerenityIndex];
  int get activeSerenityIndex => _activeSerenityIndex;
  List<MomentumPulse> get momentumPulses =>
      List.unmodifiable(_momentumPulses);
  List<GratitudeMoment> get gratitudeMoments =>
      List.unmodifiable(_gratitudeMoments);

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

  void shiftPulseWave(int delta) {
    if (_pulseWaves.isEmpty) return;
    _pulseIndex = (_pulseIndex + delta) % _pulseWaves.length;
    if (_pulseIndex < 0) {
      _pulseIndex = _pulseWaves.length - 1;
    }
    notifyListeners();
  }

  void randomizePulseWave(String id) {
    final wave = _pulseWaves.firstWhere((element) => element.id == id);
    wave.charge = (wave.charge + (_random.nextDouble() * .2 - .1)).clamp(.2, .95);
    wave.calm = (wave.calm + (_random.nextDouble() * .2 - .1)).clamp(.2, .95);
    for (var i = 0; i < wave.graph.length; i++) {
      wave.graph[i] =
          (wave.graph[i] + (_random.nextDouble() * .3 - .15)).clamp(.1, .95);
    }
    notifyListeners();
  }

  void cycleMacroBlueprint([int delta = 1]) {
    if (_macroBlueprints.isEmpty) return;
    _macroIndex = (_macroIndex + delta) % _macroBlueprints.length;
    if (_macroIndex < 0) {
      _macroIndex = _macroBlueprints.length - 1;
    }
    notifyListeners();
  }

  void updateMacroGlow(String id, double glow) {
    final blueprint = _macroBlueprints.firstWhere((element) => element.id == id);
    blueprint.glow = glow.clamp(0, 1);
    notifyListeners();
  }

  void updateMacroTargets(
    String id, {
    int? protein,
    int? carbs,
    int? fats,
    int? micros,
  }) {
    final blueprint = _macroBlueprints.firstWhere((element) => element.id == id);
    if (protein != null) blueprint.protein = protein;
    if (carbs != null) blueprint.carbs = carbs;
    if (fats != null) blueprint.fats = fats;
    if (micros != null) blueprint.micros = micros;
    notifyListeners();
  }

  void addLegacyCapsule(String title, String note) {
    final trimmedTitle = title.trim();
    final trimmedNote = note.trim();
    if (trimmedTitle.isEmpty && trimmedNote.isEmpty) return;
    final color = _visionPalette[_random.nextInt(_visionPalette.length)];
    _legacyCapsules.insert(
      0,
      LegacyCapsule(
        id: 'capsule_${DateTime.now().millisecondsSinceEpoch}',
        titleEn: trimmedTitle.isEmpty ? 'Neon note' : trimmedTitle,
        titleAr: trimmedTitle.isEmpty ? 'ملاحظة نيون' : trimmedTitle,
        noteEn: trimmedNote.isEmpty ? trimmedTitle : trimmedNote,
        noteAr: trimmedNote.isEmpty ? trimmedTitle : trimmedNote,
        timestamp: DateTime.now(),
        moodColor: color,
      ),
    );
    notifyListeners();
  }

  void toggleLegacyFavorite(String id) {
    final capsule = _legacyCapsules.firstWhere((element) => element.id == id);
    capsule.favorite = !capsule.favorite;
    notifyListeners();
  }

  void toggleEclipseProgram(String id) {
    final program = _eclipsePrograms.firstWhere((element) => element.id == id);
    program.active = !program.active;
    notifyListeners();
  }

  void setClarityFocus(double value) {
    _clarityFocus = value.clamp(0, 1);
    notifyListeners();
  }

  void pulseClaritySignal(String id, [double delta = .08]) {
    final signal = _claritySignals.firstWhere((element) => element.id == id);
    signal.current = (signal.current + delta).clamp(0, 1);
    signal.trend = (signal.current - signal.target).clamp(-1, 1);
    notifyListeners();
  }

  void advanceSyncDrill(String id) {
    final drill = _syncDrills.firstWhere((element) => element.id == id);
    drill.completedRounds =
        (drill.completedRounds + 1).clamp(0, drill.rounds).toInt();
    drill.progress = (drill.completedRounds / drill.rounds).clamp(0, 1);
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

  void advanceGrowthMission(String id, {double delta = 1}) {
    final mission = _growthMissions.firstWhere((element) => element.id == id);
    mission.progress = (mission.progress + delta).clamp(0, mission.target.toDouble());
    notifyListeners();
  }

  void toggleMissionHighlight(String id) {
    final mission = _growthMissions.firstWhere((element) => element.id == id);
    mission.highlighted = !mission.highlighted;
    notifyListeners();
  }

  void resetGrowthMissions() {
    for (final mission in _growthMissions) {
      mission.progress = 0;
      mission.highlighted = false;
    }
    if (_growthMissions.isNotEmpty) {
      _growthMissions.first.highlighted = true;
    }
    notifyListeners();
  }

  void tuneRhythm(String id, {int bpmDelta = 4, double focusDelta = .05}) {
    final rhythm = _rhythmCards.firstWhere((element) => element.id == id);
    rhythm.bpm = (rhythm.bpm + bpmDelta).clamp(40, 120);
    rhythm.focus = (rhythm.focus + focusDelta).clamp(0, 1);
    notifyListeners();
  }

  void toggleRhythmExpansion(String id) {
    final rhythm = _rhythmCards.firstWhere((element) => element.id == id);
    rhythm.expanded = !rhythm.expanded;
    notifyListeners();
  }

  void setRhythmBpm(String id, int bpm) {
    final rhythm = _rhythmCards.firstWhere((element) => element.id == id);
    rhythm.bpm = bpm.clamp(40, 120);
    notifyListeners();
  }

  void setRhythmFocus(String id, double focus) {
    final rhythm = _rhythmCards.firstWhere((element) => element.id == id);
    rhythm.focus = focus.clamp(0, 1);
    notifyListeners();
  }

  void shuffleRhythms() {
    final rng = Random();
    for (final rhythm in _rhythmCards) {
      rhythm.bpm = 50 + rng.nextInt(40);
      rhythm.waves = 2 + rng.nextInt(4);
      rhythm.focus = rng.nextDouble();
    }
    notifyListeners();
  }

  void addVisionEntry({
    required String titleEn,
    required String titleAr,
    required String noteEn,
    required String noteAr,
  }) {
    final trimmedTitleEn = titleEn.trim();
    final trimmedTitleAr = titleAr.trim();
    if (trimmedTitleEn.isEmpty && trimmedTitleAr.isEmpty) return;
    final color = _visionPalette[Random().nextInt(_visionPalette.length)];
    _visionEntries.insert(
      0,
      VisionEntry(
        id: UniqueKey().toString(),
        titleEn: trimmedTitleEn.isEmpty ? trimmedTitleAr : trimmedTitleEn,
        titleAr: trimmedTitleAr.isEmpty ? trimmedTitleEn : trimmedTitleAr,
        noteEn: noteEn.trim().isEmpty ? trimmedTitleEn : noteEn.trim(),
        noteAr: noteAr.trim().isEmpty ? trimmedTitleAr : noteAr.trim(),
        moodColor: color,
        pinned: true,
      ),
    );
    notifyListeners();
  }

  void toggleVisionPin(String id) {
    final entry = _visionEntries.firstWhere((element) => element.id == id);
    entry.pinned = !entry.pinned;
    notifyListeners();
  }

  void cycleVisionColor(String id) {
    final entry = _visionEntries.firstWhere((element) => element.id == id);
    final currentIndex = _visionPalette.indexOf(entry.moodColor);
    final nextIndex = (currentIndex + 1) % _visionPalette.length;
    entry.moodColor = _visionPalette[nextIndex];
    notifyListeners();
  }

  void setActiveSerenityIndex(int index) {
    if (_serenityModules.isEmpty) return;
    _activeSerenityIndex = index % _serenityModules.length;
    if (_activeSerenityIndex < 0) {
      _activeSerenityIndex = _serenityModules.length - 1;
    }
    notifyListeners();
  }

  void cycleSerenityModule() {
    setActiveSerenityIndex(_activeSerenityIndex + 1);
  }

  void updateSerenityDepth(String id, double value) {
    final module = _serenityModules.firstWhere((element) => element.id == id);
    module.depth = value.clamp(0, 1);
    notifyListeners();
  }

  void adjustSerenityBreaths(String id, int delta) {
    final module = _serenityModules.firstWhere((element) => element.id == id);
    module.breaths = max(4, module.breaths + delta);
    notifyListeners();
  }

  void toggleMomentumPulse(String id) {
    final pulse = _momentumPulses.firstWhere((element) => element.id == id);
    pulse.completed = !pulse.completed;
    pulse.progress = pulse.completed ? pulse.goal : pulse.progress * .7;
    notifyListeners();
  }

  void setMomentumPulseProgress(String id, double progress) {
    final pulse = _momentumPulses.firstWhere((element) => element.id == id);
    pulse.progress = progress.clamp(0, 1);
    if (pulse.progress >= pulse.goal) {
      pulse.completed = true;
      pulse.progress = pulse.goal;
    } else {
      pulse.completed = false;
    }
    notifyListeners();
  }

  void addGratitudeMoment(String message, Locale locale) {
    final trimmed = message.trim();
    if (trimmed.isEmpty) return;
    final color = _visionPalette[_random.nextInt(_visionPalette.length)];
    _gratitudeMoments.insert(
      0,
      GratitudeMoment(
        id: 'gratitude_${DateTime.now().millisecondsSinceEpoch}',
        messageEn: locale.languageCode == 'ar' ? trimmed : trimmed,
        messageAr: locale.languageCode == 'ar' ? trimmed : trimmed,
        createdAt: DateTime.now(),
        moodColor: color,
      ),
    );
    if (_gratitudeMoments.length > 24) {
      _gratitudeMoments.removeLast();
    }
    notifyListeners();
  }

  void cycleGratitudeColor(String id) {
    final entry = _gratitudeMoments.firstWhere((element) => element.id == id);
    final currentIndex = _visionPalette.indexOf(entry.moodColor);
    final nextIndex = (currentIndex + 1) % _visionPalette.length;
    entry.moodColor = _visionPalette[nextIndex];
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
