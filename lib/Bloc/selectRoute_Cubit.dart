import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'SelectRoute_State.dart';


class SelectRoute extends Cubit<RouteState>{
  SelectRoute() :super(IntialState());


  List<String>MetroStations=[];
  List<String>BestRoute=[];
    List<String>NumberofPersons=['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20'];
  String? person;
int LineStation1=0;
  int LineStation2=0;
 String? Station1;
  String? Station2;
  String? ShowStation1;
  String? ShowStation2;
  int? time;
  int?  numStation;
  int?  price;
  num?distance;
  List<String>MetroLine1=[];
  List<String>MetroLine2=[];
  List<String>MetroLine3=[];
  int ticket=1;
  String PaymentMethod="";
  bool Selected=false;
  int? totalPrice;


  int StationLine(String Station){

    if(MetroLine1.contains(Station)){

      return 1;
    }
    else if(MetroLine2.contains(Station)){
      return 2;
    }
    else if(MetroLine3.contains(Station)){
      return 3;
    }
    return -1;
  }


  void ShowStations(){
  this.ShowStation1=this.Station1;
  this.ShowStation2=this.Station2;

}
  void ClearSelection(){
    Station1 = null;
    Station2 = null;
    person = null;
    emit(ClearState());

  }
  void TotalPrice(){
    totalPrice = (int.parse(person ?? "0")) * (price ?? 0);

  }

void Show(){
 this. Selected=true;
 emit(ShowPrice(isVisble: Selected));

}
  void Hide(){
  this.Selected=false;
  emit(ShowPrice(isVisble: Selected));

  }


  void setStation2(String Station){
    this.Station2=Station;
  }
void setStation1(String Station){
  this.Station1=Station;
}
void SetPerson(String p){
    this.person=p;
}

ValidateStation(){
if(Station1==null|| Station2==null){
return "Please select both stations";
}
else if(Station1==Station2){
return "Start and End Station cannot be the same";
}
return null;
}

  ValidateTicketPrice(){
    if(Station1==null|| Station2==null){
      return "Please select both stations And Number of Person ";
    }
    else if(Station1==Station2){
      return "Start and End Station cannot be the same";
    }
    else if (person==null){
      return 'Please Select Number of Person';
    }
    return null;
  }


 void Add(){
    ticket=ticket+1;
    emit(AddTicket( ticket: ticket));

}
  void Abstract(){
        if(ticket>1) {
          ticket = ticket - 1;

          emit(AbstractTicket(ticket: ticket));
        }
  }
void GetPaymentMethod(String method){
   this. PaymentMethod=method;
   emit(ChooseMethod(Payment: PaymentMethod));

}

bool CheckMethod(){
    return PaymentMethod.isNotEmpty;

}
  void MakePayment() {
    emit(PaymentLodingState());

    try {

      if (PaymentMethod == null) {
        emit(PaymentErorrState(Error: "Choose a payment method"));
        return;
      }

      Future.delayed(Duration(seconds: 2), () {
        emit(PaymentSucessState());
      });

    } catch (e) {
      emit(PaymentErorrState(Error: e.toString()));
    }
  }



getStations()async{
    final response=await Dio().get('https://metrodb-production.up.railway.app/api/v1/trips/station');
    Map<String,dynamic> data=response.data;
    List StationsName=data['data'];
    MetroStations.clear();
    for(var station in StationsName){
      MetroStations.add(station['name']);
    }


    print(' Stations =  $MetroStations');
    return MetroStations;
    
}
getInfoStation()async{
    try {
      emit(InfoLodingState());
      final response = await Dio().post(
          'https://metrodb-production.up.railway.app/api/v1/trips/info',
          data: {
            "startStation": Station1,
            "endStation": Station2
          }
      );
      Map<String,dynamic> data=response.data;
      List InfoStation=data['stations'];
      MetroLine1.clear();
      MetroLine2.clear();
      MetroLine3.clear();
      BestRoute.clear();

      for(var info in InfoStation){
        BestRoute.add(info["name"]);
        if(info['line_number']==1){
          MetroLine1.add(info["name"]);
        }
        else if(info['line_number']==2){
          MetroLine2.add(info["name"]);
        }
        else if (info['line_number'] == 3) {
          MetroLine3.add(info['name']);
        }
      }

      time=data['time'];
      numStation= data['count'];
      price=data['ticketPrice'];
      distance=data['distance'];

      print("Best Route = $BestRoute \n  Line 1=$MetroLine1 \n Line 2=$MetroLine2\n Line 3=$MetroLine3 ");
      print("time=$time\n number of Station=$numStation\n price=$price\n distance=$distance");


      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(InfoSucessState());
      } else {
        emit(InfoErorrState(Error: "Not Found Information"));
      }

    }catch(e){
      emit(InfoErorrState(Error: e.toString()));
      print("Dio Error: $e");

    }
}


}