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
  final int zones;

  SubscriptionPlan({
    required this.id,
    required this.durationEn,
    required this.durationAr,
    required this.zones,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['_id'] ?? '',
      durationEn: json['duration']?['en'] ?? '',
      durationAr: json['duration']?['ar'] ?? '',
      zones: json['zones'] ?? 1,
    );
  }
}

class CategoryPlansResult {
  final SubscriptionCategory category;
  final List<SubscriptionPlan> plans;

  CategoryPlansResult({required this.category, required this.plans});
}