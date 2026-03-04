import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String? TicketId;
String? PaymentKey;
String? UserName;
int? PaymentId;
String? Date;
String? BillRefrance;
String? Iframe_Url;

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


    try {

      if (PaymentMethod == null) {
        emit(PaymentErorrState(Error: "Choose a payment method"));
        return;
      }



    } catch (e) {
      emit(PaymentErorrState(Error: e.toString()));
    }
  }

  Future<void> setToken() async {
    SharedPreferences shard = await SharedPreferences.getInstance();
    await shard.setInt('totalPrice', totalPrice! );
    await shard.setString('TicketId', TicketId!);



  }
  Future<void> setPaymentKey() async {
    SharedPreferences shard = await SharedPreferences.getInstance();

    await shard.setString("PaymentKey", PaymentKey!);

  }

  Future<void> setTokenConfermation() async {
    SharedPreferences shard = await SharedPreferences.getInstance();
    await shard.setInt('totalPrice', totalPrice! );
    await shard.setString('PaymentMethod', PaymentMethod!);
    await shard.setInt("PaymentId", PaymentId!);
    await shard.setString("Date", Date!);
    await shard.setString("UserName", UserName!);

  }
  Future<void> setBillRefrance() async {
    SharedPreferences shard = await SharedPreferences.getInstance();

    await shard.setString("BillRefrance", BillRefrance!);

  }
  Future<void> setUrl() async {
    SharedPreferences shard = await SharedPreferences.getInstance();

    await shard.setString("Iframe_Url", Iframe_Url!);

  }


  getStations()async{
  try {

  } on DioException catch (e) {
    print(e.response?.statusCode);
    print(e.response?.data);
    print(e.requestOptions.data);
  }

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


  getTicketIdByPrice()async{

    try{
      SharedPreferences shard = await SharedPreferences.getInstance();
      String? token = shard.getString('Token');

        emit(PaymentLodingState());
      final response=await Dio().post('https://metrodb-production.up.railway.app/api/v1/tickets/getTicketIdByPrice',
        data: {
        "ticketPrice": price,
        "numberOfTickets": ticket
      },
        options: Options(
          validateStatus: (status) => true,
          headers: {
            "Authorization":  "Bearer $token",
          },

        ),
      );

       final Status=response.statusCode as int  ;
      totalPrice = response.data["data"]["totalPrice"];
      TicketId   = response.data["data"]["ticketId"].toString();
      await setToken();
      print('************************************Ticket Id ************************************');
      print("Status: ${Status}");
      print("Token= $token");
      print("Ticket= $ticket");
      print("Price= $price");
      print("total Price=$totalPrice");
      print("Ticket Id = $TicketId");

      print("Response Data: ${response.data}");


      emit(PaymentSucessState());

    } catch (e) {
      emit(PaymentErorrState(Error: e.toString()));
      print("Dio Error: $e");
    }

  }


  ticketpaymentkey()async{

    try{
      SharedPreferences shard = await SharedPreferences.getInstance();
      String? token = shard.getString('Token');

      emit(SelectPaymentMethodLodingState());
      final response=await Dio().post('https://metrodb-production.up.railway.app/api/v1/ticketpay/ticketpaymentkey',
        data: {

            "ticketId": TicketId,
            "totalPrice": totalPrice ,
            "paymentmethod": PaymentMethod

        },
        options: Options(
          validateStatus: (status) => true,
          headers: {
            "Authorization":  "Bearer $token",
          },

        ),
      );

      final Status=response.statusCode as int  ;
      PaymentKey=response.data['paymentKey'];
      setPaymentKey();
      print('************************************Payment Key ************************************');

      print("Status: ${Status}");
      print("Token= $token");

      print("total Price=$totalPrice");
      print("Ticket Id = $TicketId");
      print("Paymen Method=$PaymentMethod");
      print("Paymen Key=$PaymentKey");

      print("Response Data: ${response.data}");


      emit(SelectPaymentMethodSucessState());


    } catch (e) {
      emit(SelectPaymentMethodErorrState(Error: e.toString()));
      print("Dio Error: $e");
    }

  }

  paymentconfirmation()async{

    try{
      SharedPreferences shard = await SharedPreferences.getInstance();
      String? token = shard.getString('Token');

      emit(PaymentLodingState());
      final response=await Dio().get('https://metrodb-production.up.railway.app/api/v1/ticketpay/paymentconfirmation',

        options: Options(
          validateStatus: (status) => true,
          headers: {
            "Authorization":  "Bearer $token",
          },

        ),
      );

      final Status=response.statusCode as int  ;
      UserName=response.data["data"]["userName"];
      PaymentId=response.data["data"]["payment"]["invoice_number"];
      PaymentMethod=response.data["data"]["payment"]["payment_method"];
      Date=response.data["data"]["payment"]["issuing_date"];
      totalPrice=response.data["data"]["payment"]["amount_paid"];

      setTokenConfermation();
      print("Status: ${Status}");
      print("Token= $token");
      print('************************************User Information ************************************');
      print('User Name= $UserName');
      print('Payment Id= $PaymentId');
      print(' Payment Method= $PaymentMethod');
      print('Date= $Date');
      print('Total Price = $totalPrice');


      print("Response Data: ${response.data}");


      emit(PaymentSucessState());

    } catch (e) {
      emit(PaymentErorrState(Error: e.toString()));
      print("Dio Error: $e");
    }

  }

  ticketfawrypayment()async{

    try{
      SharedPreferences shard = await SharedPreferences.getInstance();
      String? token = shard.getString('Token');

      emit(FawryPaymentLodingState());
      final response=await Dio().post('https://metrodb-production.up.railway.app/api/v1/ticketpay/ticketfawrypayment',
        data: {


          "paymentkey": PaymentKey,
          "paymentmethod": PaymentMethod

        },
        options: Options(
          validateStatus: (status) => true,
          headers: {
            "Authorization":  "Bearer $token",
          },

        ),
      );

      final Status=response.statusCode as int  ;
      BillRefrance=response.data["bill_reference"].toString();
      setBillRefrance();

      print('************************************Fawry Code ************************************');

      print("Status: ${Status}");

      print("Paymen Key=$PaymentKey");

      print("Response Data: ${response.data}");


      emit(FawryPaymentSucessState());


    } catch (e) {
      emit(FawryPaymentErorrState(Error: e.toString()));
      print("Dio Error: $e");
    }

  }

  ticketvisapayment()async{

    try{
      SharedPreferences shard = await SharedPreferences.getInstance();
      String? token = shard.getString('Token');

      emit(VisaCardPaymentLodingState());
      final response=await Dio().post('https://metrodb-production.up.railway.app/api/v1/ticketpay/ticketvisapayment',
        data: {


          "paymentkey": PaymentKey,
          "paymentmethod": PaymentMethod

        },
        options: Options(
          validateStatus: (status) => true,
          headers: {
            "Authorization":  "Bearer $token",
          },

        ),
      );

      final Status=response.statusCode as int  ;
      Iframe_Url=response.data["iframe_url"];
     setUrl();

      print('************************************  Visa Card  Code  ************************************');

      print("Status: ${Status}");

      print("Paymen Key=$PaymentKey");

      print("Response Data: ${response.data}");

      print(" Iframe = $Iframe_Url");

      emit(VisaCardPaymentSucessState());


    } catch (e) {
      emit(VisaCardPaymentErorrState(Error: e.toString()));
      print("Dio Error: $e");
    }

  }
}