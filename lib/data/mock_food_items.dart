import '../models/food_item.dart';

final List<FoodItem> mockFoodItems = [
  FoodItem(
    id: 'smoothie-1',
    nameEn: 'Citrus Glow Smoothie',
    nameAr: 'سموثي التوهج الحمضي',
    imageUrl:
        'https://images.unsplash.com/photo-1497534446932-c925b458314e?auto=format&fit=crop&w=800&q=80',
    calories: 210,
    protein: 6,
    carbs: 36,
    fats: 4,
    category: 'Juice',
    tags: ['fresh', 'morning'],
    shortDescriptionEn: 'Orange, pineapple and ginger hit of freshness.',
    shortDescriptionAr: 'برتقال وأناناس وزنجبيل منعش.',
    longDescriptionEn:
        'Hydrate your morning with citrus, ginger and coconut water. Light bubbles and mint keep the finish clean.',
    longDescriptionAr:
        'أروِ صباحك بالحمضيات والزنجبيل وماء جوز الهند مع نعناع منعش.',
  ),
  FoodItem(
    id: 'bowl-1',
    nameEn: 'Matcha Energy Bowl',
    nameAr: 'وعاء ماتشا للطاقة',
    imageUrl:
        'https://images.unsplash.com/photo-1481391032119-d89fee407e44?auto=format&fit=crop&w=800&q=80',
    calories: 420,
    protein: 18,
    carbs: 58,
    fats: 12,
    category: 'Bowl',
    tags: ['green', 'power'],
    shortDescriptionEn: 'Avocado, matcha granola and seeds.',
    shortDescriptionAr: 'أفوكادو وجرانولا ماتشا وبذور.',
    longDescriptionEn:
        'Creamy avocado pairs with crunchy matcha granola. Spirulina yogurt gives protein boost for training days.',
    longDescriptionAr:
        'أفوكادو كريمي مع جرانولا ماتشا مقرمشة وزبادي سبيرولينا غني بالبروتين.',
  ),
  FoodItem(
    id: 'salad-1',
    nameEn: 'Neon Quinoa Salad',
    nameAr: 'سلطة كينوا نيون',
    imageUrl:
        'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=800&q=80',
    calories: 330,
    protein: 14,
    carbs: 44,
    fats: 11,
    category: 'Salad',
    tags: ['fiber', 'vegan'],
    shortDescriptionEn: 'Bright quinoa, mango, kale and chili lime.',
    shortDescriptionAr: 'كينوا مع مانجو وكرنب وتتبيلة حارة.',
    longDescriptionEn:
        'Mango ribbons, blistered kale and quinoa pearls tossed with chili-lime vinaigrette keep hunger calm.',
    longDescriptionAr:
        'شرائط المانجو والكرنب المشوي مع حبوب الكينوا وتتبيلة الفلفل والليمون.',
  ),
];
