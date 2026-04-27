import 'package:equatable/equatable.dart';
import '../../models/subscribtion_model.dart';

abstract class SubscriptionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionCategoriesLoading extends SubscriptionState {}

class SubscriptionCategoriesLoaded extends SubscriptionState {
  final List<SubscriptionCategory> categories;

  SubscriptionCategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class SubscriptionCategoriesError extends SubscriptionState {
  final String message;

  SubscriptionCategoriesError(this.message);

  @override
  List<Object?> get props => [message];
}

class SubscriptionPlansLoading extends SubscriptionState {}

class SubscriptionPlansLoaded extends SubscriptionState {
  final CategoryPlansResult result;

  SubscriptionPlansLoaded(this.result);

  @override
  List<Object?> get props => [result];
}

class SubscriptionPlansError extends SubscriptionState {
  final String message;

  SubscriptionPlansError(this.message);

  @override
  List<Object?> get props => [message];
}