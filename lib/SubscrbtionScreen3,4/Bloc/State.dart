abstract class SubscriptionState {
  const SubscriptionState();
}

class SubscriptionInitial extends SubscriptionState {
  const SubscriptionInitial();
}

class SubscriptionLoading extends SubscriptionState {
  const SubscriptionLoading();
}

class SubscriptionPending extends SubscriptionState {
  const SubscriptionPending();
}

class SubscriptionAccepted extends SubscriptionState {
  const SubscriptionAccepted();
}

class SubscriptionRejected extends SubscriptionState {
  const SubscriptionRejected();
}

class SubscriptionError extends SubscriptionState {
  final String message;

  const SubscriptionError(this.message);
}

/// Active State
class SubscriptionActive extends SubscriptionState {
  final Map<String, dynamic> data;

  const SubscriptionActive(this.data);
}

/// Renew State
class SubscriptionRenew extends SubscriptionState {
  final Map<String, dynamic> data;

  const SubscriptionRenew(this.data);
}

class SubscriptionExpired extends SubscriptionState {
  const SubscriptionExpired();
}