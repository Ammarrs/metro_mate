import '../config/api_config.dart';
import '../models/subscribtion_model.dart';
import 'api_client.dart';

class SubscriptionService {
  final ApiClient _apiClient = ApiClient();

  Future<List<SubscriptionCategory>> getSubscriptionPlans() async {
    final response = await _apiClient.get(ApiConfig.subscriptionPlansEndpoint);

    if (response.statusCode == 200) {
      final List<dynamic> raw = response.data['data'] ?? [];
      return raw
          .whereType<Map<String, dynamic>>()
          .map((json) => SubscriptionCategory.fromJson(json))
          .toList();
    }
    throw Exception('Failed to load subscription plans: ${response.statusCode}');
  }

  Future<CategoryPlansResult> getPlansByCategory(String categoryKey) async {
    final endpoint = '${ApiConfig.subscriptionPlansEndpoint}/$categoryKey';
    final response = await _apiClient.get(endpoint);

    if (response.statusCode == 200) {
      final data = response.data['data'];
      final category = SubscriptionCategory.fromJson(data['category']);
      final List<dynamic> rawPlans = data['plans'] ?? [];
      final plans = rawPlans
          .whereType<Map<String, dynamic>>()
          .map((json) => SubscriptionPlan.fromJson(json))
          .toList();
      return CategoryPlansResult(category: category, plans: plans);
    }
    throw Exception('Failed to load plans for $categoryKey: ${response.statusCode}');
  }
}