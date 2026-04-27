import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/subsciption_services.dart';
import 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionService _service = SubscriptionService();

  SubscriptionCubit() : super(SubscriptionInitial());

  Future<void> loadCategories() async {
    emit(SubscriptionCategoriesLoading());
    try {
      final categories = await _service.getSubscriptionPlans();
      emit(SubscriptionCategoriesLoaded(categories));
    } catch (e) {
      emit(SubscriptionCategoriesError(e.toString()));
    }
  }

  Future<void> loadPlansByCategory(String categoryKey) async {
    emit(SubscriptionPlansLoading());
    try {
      final result = await _service.getPlansByCategory(categoryKey);
      emit(SubscriptionPlansLoaded(result));
    } catch (e) {
      emit(SubscriptionPlansError(e.toString()));
    }
  }
}