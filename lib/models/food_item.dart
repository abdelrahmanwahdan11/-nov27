class FoodItem {
  FoodItem({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.imageUrl,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.category,
    required this.tags,
    required this.shortDescriptionEn,
    required this.shortDescriptionAr,
    required this.longDescriptionEn,
    required this.longDescriptionAr,
  });

  final String id;
  final String nameEn;
  final String nameAr;
  final String imageUrl;
  final int calories;
  final double protein;
  final double carbs;
  final double fats;
  final String category;
  final List<String> tags;
  final String shortDescriptionEn;
  final String shortDescriptionAr;
  final String longDescriptionEn;
  final String longDescriptionAr;

  String name(String languageCode) =>
      languageCode == 'ar' ? nameAr : nameEn;

  String shortDescription(String languageCode) =>
      languageCode == 'ar' ? shortDescriptionAr : shortDescriptionEn;

  String longDescription(String languageCode) =>
      languageCode == 'ar' ? longDescriptionAr : longDescriptionEn;
}
