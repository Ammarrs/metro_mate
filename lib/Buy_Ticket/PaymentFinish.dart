import 'package:dotted_border/dotted_border.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/SelectRoute_State.dart';
import '../Bloc/selectRoute_Cubit.dart';
class Paymentfinish extends StatelessWidget {
  const Paymentfinish({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit= context.read<SelectRoute>();
    return BlocConsumer <SelectRoute,RouteState>(
        listener: (context,state){},
        builder: (context,state) {
          return Scaffold(
            backgroundColor: Color(0xffFCFCFD),
            appBar: AppBar(
              toolbarHeight: 200,

              automaticallyImplyLeading: false,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff00C750),
                      Color(0xFF00A83F),
                    ],
                  ),
                ),
              ),

              title: Padding(
                padding: const EdgeInsets.only(left: 70.0),
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 90,
                        width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xff33C76D),
                      ),
                      child: Icon(Icons.task_alt,color: Colors.white,size: 60,),

                    ),
                    SizedBox(height: 15,),
                    Text("Payment Successful!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                    SizedBox(height: 10,),
                    Text("Your tickets are ready",style: TextStyle(fontSize: 18,color: Color(0xffE2EBF0)),)

                    ],
                ),
              ),
            ),



            body: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView(

                      children: [
                        Container(
                          width: 200,
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
                            padding: const EdgeInsets.all(15.0),
                            child:Column(
                              children: [
                            DottedBorder(
                            color: Colors.blue.shade300,
                              strokeWidth: 2,
                              dashPattern: [6, 4],
                              borderType: BorderType.RRect,
                              radius: Radius.circular(18),
                              child: Container(
                                width: 200,
                                height: 220,
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.qr_code_2, size: 80, color: Color(0xff5A72A0)),
                                    SizedBox(height: 20),
                                    Text(
                                      "Ticket QR Code",
                                      style: TextStyle(color: Colors.grey.shade600),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "QR6NKZOHFAE6P",
                                      style: TextStyle(
                                          color: Color(0xff5A72A0),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                                SizedBox(height: 20,),
                                Container(
                                  width: 150,
                                  child: MaterialButton(onPressed: (){},
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(color: Color(0xff5A72A0),)
                                    ) ,
                                    minWidth: 70,

                                    hoverColor: Colors.blue.shade900,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [Expanded(child: Icon(Icons.save_alt_outlined,color: Color(0xff5A72A0))),
                                        Text(" Save To Photos",style: TextStyle(color: Color(0xff5A72A0),fontSize: 13),),
                                      ],
                                    ),
                                  ),
                                ),



                              ],
                            ),
                          ),

                        ),
                        SizedBox(height: 15,),
                        Container(
                          width: 200,
                          height: 340,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(1, 2),
                                )
                              ],
                              color: Colors.white),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0, left: 20),
                                child: Text(
                                  "Trip Summary",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [


                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Ticket Id ", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                                          SizedBox(height: 6),
                                          Text("Route ", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                                          SizedBox(height: 6),
                                          Text("Quantity ", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                                          SizedBox(height: 6),
                                          Text("Total Paid ", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                                          SizedBox(height: 6),
                                          Text("Valid Until ", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),

                                    SizedBox(width: 10),


                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("TKTLAIERNYF"),
                                          SizedBox(height: 6),
                                          Text(
                                            '${cubit.ShowStation1} → ${cubit.ShowStation2}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 6),
                                          Text('${cubit.ticket} tickets'),
                                          SizedBox(height: 6),
                                          Text("EGP  ${(cubit.price)!*(cubit.ticket)}", style: TextStyle(color: Color(0xff5A72A0))),
                                          SizedBox(height: 6),
                                          Text("12/10/2025")
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              )

                            ],
                          ),
                        ),
                        SizedBox(height: 15,),
                        Container(
                          width: 200,
                          height: 250,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(1, 2),
                                )
                              ],
                              color: Color(0xffE2EBF0)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0, left: 20),
                                child: Text(
                                  "How to use your ticket:",
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("1. Show this QR code at the metro station gate",style: TextStyle(color: Colors.grey),),
                                    SizedBox(height: 10,),
                                    Text("2. Place your phone over the scanner",style: TextStyle(color: Colors.grey),),
                                    SizedBox(height: 10,),
                                    Text("3. Wait for the green light and gate to open",style: TextStyle(color: Colors.grey),),
                                    SizedBox(height: 10,),
                                    Text("4. Each ticket is valid for 24 hours from purchase",style: TextStyle(color: Colors.grey),),


                                 
                                  ],
                                ),
                              )
                            ],
                          ),
                        )



                      ],

                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 150,
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
                      child: Column(
                        children: [
                          MaterialButton(onPressed: (){
                            Navigator.pushNamed(context,"test_page");
                          },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)) ,
                            minWidth: 320,
                            color: Color(0xff5A72A0),
                            hoverColor: Colors.blue.shade900,
                            child: Text(" Back To Home",style: TextStyle(color: Colors.white),),
                          ),
                          SizedBox(height: 10,),
                          MaterialButton(onPressed: (){
                            Navigator.pushNamed(context,"SelectQuantity");
                          },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Color(0xff5A72A0),)
                            ) ,
                            minWidth: 320,

                            hoverColor: Colors.blue.shade900,
                            child: Text(" Buy More Tickets",style: TextStyle(color: Color(0xff5A72A0)),),
                          ),
                        ],
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
