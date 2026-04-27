class SubscriptionCategory {
  final String en;
  final String ar;

  SubscriptionCategory({required this.en, required this.ar});

  factory SubscriptionCategory.fromJson(Map<String, dynamic> json) {
    return SubscriptionCategory(
      en: json['en'] ?? '',
      ar: json['ar'] ?? '',
    );
  }
}

class SubscriptionPlan {
  final String id;
  final String durationEn;
  final String durationAr;
  final int? zones;
  final num prices;

  SubscriptionPlan({
    required this.id,
    required this.durationEn,
    required this.durationAr,
    this.zones,
    required this.prices,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['_id'] ?? '',
      durationEn: json['duration']?['en'] ?? '',
      durationAr: json['duration']?['ar'] ?? '',
      zones: json['zones'] as int?,
      prices: json['prices'] ?? 0,
    );
  }
}

class CategoryPlansResult {
  final SubscriptionCategory category;
  final List<SubscriptionPlan> plans;

  CategoryPlansResult({required this.category, required this.plans});
}