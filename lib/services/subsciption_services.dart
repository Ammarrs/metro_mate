import '../config/api_config.dart';
import '../models/subscribtion_model.dart';
import 'api_client.dart';

// ─── Language note ─────────────────────────────────────────────────────────
// ApiClient should be initialised (or have an interceptor) that adds the
// Accept-Language header.  The easiest approach is to add a _LanguageInterceptor
// (see verify_identity_service.dart) to the Dio instance inside ApiClient, or
// to replace the static headers with:
//   final headers = await ApiConfig.headersWithLanguage();
// ──────────────────────────────────────────────────────────────────────────

class SubscriptionService {
  final ApiClient _apiClient = ApiClient();

  Future<List<SubscriptionCategory>> getSubscriptionPlans() async {
    final response = await _apiClient.get(ApiConfig.subscriptionPlansEndpoint);

    if (response.statusCode == 200) {
      final List<dynamic> raw = response.data['data'] ?? [];
      return raw
          .map((item) {
            if (item is Map<String, dynamic>) {
              return SubscriptionCategory.fromJson(item);
            } else if (item is String) {
              // API returns plain strings e.g. "Elderly", "military"
              return SubscriptionCategory(en: item, ar: item);
            }
            return null;
          })
          .whereType<SubscriptionCategory>()
          .toList();
    }
    throw Exception(
        'Failed to load subscription plans: ${response.statusCode}');
  }

  Future<CategoryPlansResult> getPlansByCategory(String categoryKey) async {
    final endpoint = '${ApiConfig.subscriptionPlansEndpoint}/$categoryKey';
    final response = await _apiClient.get(endpoint);

    if (response.statusCode == 200) {
      final List<dynamic> rawPlans = response.data['data'] ?? [];
      final plans = rawPlans
          .whereType<Map<String, dynamic>>()
          .map((json) => SubscriptionPlan.fromJson(json))
          .toList();
      final category = SubscriptionCategory(en: categoryKey, ar: categoryKey);
      return CategoryPlansResult(category: category, plans: plans);
    }
    throw Exception(
        'Failed to load plans for $categoryKey: ${response.statusCode}');
  }
}