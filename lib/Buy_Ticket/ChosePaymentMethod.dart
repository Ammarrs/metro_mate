import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/SelectRoute_State.dart';
import '../Bloc/selectRoute_Cubit.dart';
class Chosepaymentmethod extends StatelessWidget {
  const Chosepaymentmethod({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit= context.read<SelectRoute>();
    return BlocConsumer <SelectRoute,RouteState>(
        listener: (context,state){
          if (state is PaymentErorrState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.Error),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is PaymentSucessState) {
            if(cubit.PaymentMethod=="MetroWallet") {
              Navigator.pushNamed(context, "finish");
            }
            else if(cubit.PaymentMethod=="Credit") {
              Navigator.pushNamed(context, "Creditdetils");
            }
          }

        },
        builder: (context,state) {
          return Scaffold(
            backgroundColor: Color(0xffFCFCFD),
            appBar: AppBar(
              toolbarHeight: 150,
              automaticallyImplyLeading: false,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4A6BAA),
                      Color(0xFF47C7E0),
                    ],
                  ),
                ),
              ),

              title: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [


                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'SelectQuantity');
                          },
                          icon: Icon(Icons.arrow_back, size: 22, color: Colors.white),
                        ),

                        SizedBox(width: 8),


                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Buy Tickets',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${cubit.ShowStation1} → ${cubit.ShowStation2}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xffC1DFEF),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 100,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            body: Column(

              children: [
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset:Offset(1, 2),
                        )],
                        color: Colors.white
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0,top: 15 ,right: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Choose Payment Method",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                          SizedBox(height: 30,),
                          Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),

                                color: Colors.grey.shade50

                            ),
                            child: Center(
                              child: RadioListTile(value: "MetroWallet", groupValue: cubit.PaymentMethod, onChanged: (v){

                                if (v!=null){
                                  cubit.GetPaymentMethod(v);
                                  print(cubit.PaymentMethod);
                                }
                              },
                              title: Row(
                                children: [
                                 Container(
                                   width: 50,
                                   height: 50,
                                   decoration: BoxDecoration(

                                     gradient: LinearGradient(
                                       begin: Alignment.topLeft,
                                       end: Alignment.bottomRight,
                                       colors: [
                                         Color(0xFF4A6BAA),
                                         Color(0xFF47C7E0),
                                       ],
                                     ),

                                     borderRadius: BorderRadius.circular(18),
                                   ),
                                   child: Icon(Icons.account_balance_wallet,color: Colors.white,size: 30,),
                                 ),
                                  SizedBox(width: 8,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Metro Mate \nWallet",
                                        textAlign: TextAlign.start,
                                          style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                      ),
                                      Text("Balance EGP \n 150",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(fontSize: 13,color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  Container(
                                      width: 60,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Center(child: Text("Available",style: TextStyle(fontSize: 10,color: Colors.white),)))

                                ],
                              ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),

                                color: Colors.grey.shade50
                            ),
                            child:RadioListTile(value: "Credit", groupValue: cubit.PaymentMethod, onChanged: (v){
                              if (v!=null){
                                cubit.GetPaymentMethod(v);
                                print(cubit.PaymentMethod);
                              }

                            },
                              title:  Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(

                                      color: Colors.blue,

                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Icon(Icons.credit_card,color: Colors.white,size: 30,),
                                  ),
                                  SizedBox(width: 2,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Credit / Debit Card",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),
                                      ),
                                      Text("Visa,Mastercard accepted",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(fontSize: 12,color: Colors.grey),
                                      )
                                    ],
                                  ),


                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                  ),
                ),
                Expanded(child: SizedBox()),
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(

                      boxShadow: [BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset:Offset(1, 2),
                      )],
                      color: Colors.white
                  ),

                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Center(
                      child: MaterialButton(onPressed: (){

                        if (!cubit.CheckMethod()){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" Choose Type Of Payment Method")));
                          return;
                        }
                        cubit.MakePayment();


                        
                       

                      },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)) ,
                        minWidth: 320,
                        color: Color(0xff5A72A0),
                        hoverColor: Colors.blue.shade900,
                        child:state is PaymentLodingState
                            ? CircularProgressIndicator(color: Colors.white)
                            :  Text(" Pay EG ${(cubit.price)!*(cubit.ticket)}",style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ),
                ),
              ],
            ),

          );
        }
    );
  }
}
