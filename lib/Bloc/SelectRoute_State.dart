abstract class RouteState {}

class IntialState extends RouteState {}

class SucessState extends RouteState {}

class LodingState extends RouteState {}

class ErorrState extends RouteState {
  final String Error;
  ErorrState({required this.Error});
}

class InfoSucessState extends RouteState {}

class InfoLodingState extends RouteState {}

class InfoErorrState extends RouteState {
  final String Error;
  InfoErorrState({required this.Error});
}

class InfoBusSuccessState extends RouteState {}

class InfoBusLoadingState extends RouteState {}

class InfoBusErrorState extends RouteState {
  final String Error;
  InfoBusErrorState({required this.Error});
}

class PaymentSucessState extends RouteState {}

class PaymentLodingState extends RouteState {}

class PaymentErorrState extends RouteState {
  final String Error;
  PaymentErorrState({required this.Error});
}

class AddTicket extends RouteState {
  final int ticket;
  AddTicket({required this.ticket});
}

class AbstractTicket extends RouteState {
  final int ticket;
  AbstractTicket({required this.ticket});
}

class ChooseMethod extends RouteState {
  final String Payment;
  ChooseMethod({required this.Payment});
}

class ShowPrice extends RouteState {
  final bool isVisble;
  ShowPrice({required this.isVisble});
}

class ClearState extends RouteState {}

class SelectPaymentMethodSucessState extends RouteState {}

class SelectPaymentMethodLodingState extends RouteState {}

class SelectPaymentMethodErorrState extends RouteState {
  final String Error;
  SelectPaymentMethodErorrState({required this.Error});
}

class SelectPaymentSubscriptionMethodSucessState extends RouteState {}

class SelectPaymentSubscriptionMethodLodingState extends RouteState {}

class SelectPaymentSubscriptionMethodErorrState extends RouteState {
  final String Error;
  SelectPaymentSubscriptionMethodErorrState({required this.Error});
}

class FawryPaymentSucessState extends RouteState {}

class FawryPaymentLodingState extends RouteState {}

class FawryPaymentErorrState extends RouteState {
  final String Error;
  FawryPaymentErorrState({required this.Error});
}

class VisaCardPaymentSucessState extends RouteState {}

class VisaCardPaymentLodingState extends RouteState {}

class VisaCardPaymentErorrState extends RouteState {
  final String Error;
  VisaCardPaymentErorrState({required this.Error});
}

class SubscriptionVisaLoadingState extends RouteState {}

class SubscriptionVisaSuccessState extends RouteState {}

class SubscriptionVisaErrorState extends RouteState {
  final String Error;
  SubscriptionVisaErrorState({required this.Error});
}
