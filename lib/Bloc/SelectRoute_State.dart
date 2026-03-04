abstract class  RouteState{}
class IntialState extends RouteState{}
class SucessState extends RouteState{}
class LodingState extends RouteState{}
class ErorrState extends RouteState{
  final String Error;
  ErorrState({required this.Error});
}

class InfoSucessState extends RouteState{}
class InfoLodingState extends RouteState{}
class InfoErorrState extends RouteState{
  final String Error;
  InfoErorrState({required this.Error});
}


class PaymentSucessState extends RouteState{}
class PaymentLodingState extends RouteState{}
class PaymentErorrState extends RouteState{
  final String Error;
  PaymentErorrState({required this.Error});
}

class AddTicket extends RouteState{
  final int ticket;
  AddTicket({required this.ticket});

}
class AbstractTicket extends RouteState{
  final int ticket;
  AbstractTicket({required this.ticket});

}
class ChooseMethod extends RouteState {
  final String Payment;
  ChooseMethod({required this.Payment});
}
class ShowPrice extends RouteState{
  final bool isVisble;
  ShowPrice({required this.isVisble });

}
class ClearState extends RouteState {}

