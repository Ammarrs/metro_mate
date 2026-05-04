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

class SubscriptionActive extends SubscriptionState {
  const SubscriptionActive();
}

class SubscriptionExpired extends SubscriptionState {
  const SubscriptionExpired();
}

class SubscriptionError extends SubscriptionState {
  final String message;

  const SubscriptionError(this.message);
}
