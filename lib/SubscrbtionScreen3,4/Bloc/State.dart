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

class SubscriptionmanualRenew extends SubscriptionState {
  const SubscriptionmanualRenew();
}

/// Emitted when the backend has no subscription for this user
/// (404, null data, or any status that doesn't match a known value
/// AND the details endpoint confirms no active subscription).
/// The app should clear the local subscription_id and send the user
/// back to Screen 1 / Screen 2 to create a new subscription.
class SubscriptionNotFound extends SubscriptionState {
  const SubscriptionNotFound();
}