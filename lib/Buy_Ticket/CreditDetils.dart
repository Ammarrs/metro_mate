import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/SelectRoute_State.dart';
import '../Bloc/selectRoute_Cubit.dart';
class Creditdetils extends StatelessWidget {
  const Creditdetils({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit= context.read<SelectRoute>();
    return BlocConsumer <SelectRoute,RouteState>(
        listener: (context,state){},
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
                            Navigator.pushNamed(context, 'Chosepaymentmethod');
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
                            color: Colors.white,
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView(

                      children: [
                        Container(
                          width: 200,
                          height: 700,
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
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.credit_card,color: Color(0xff5A72A0),size: 30,),
                                    SizedBox(width: 10,),
                                    Text("Card Details",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),

                                  ],
                                ),

                                Form(child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Full Name" ,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),

                                    TextFormField(

                                      decoration: InputDecoration(
                                        fillColor: Colors.grey.shade100,
                                        filled: true,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                                        hint: Text("John Doe"),



                                      ),
                                    ),
                                    SizedBox(height: 15,),
                                    Text("Card Number" ,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),

                                    TextFormField(

                                      maxLength: 15,

                                      decoration: InputDecoration(
                                        fillColor: Colors.grey.shade100,
                                        filled: true,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                                        hint: Text("123456789012542"),



                                      ),
                                    ),
                                    SizedBox(height: 15,),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(" Expire Date" ,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                              TextFormField(
                                                maxLength: 5,

                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                                                  fillColor: Colors.grey.shade100,
                                                  filled: true,
                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                                                  hint: Text("MM/YY"),



                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("CVV" ,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),

                                              TextFormField(
                                                maxLength: 3,

                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),

                                                  fillColor: Colors.grey.shade100,
                                                  filled: true,
                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                                                  hint: Text("123"),




                                                ),
                                              ),

                                            ],
                                          ),
                                        ),

                                      ],
                                    ),





                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Switch(value: true, onChanged: (v){},
                                          activeTrackColor:Color(0xff5A72A0) ,
                                        inactiveThumbColor: Colors.white,
                                          inactiveTrackColor:Colors.grey.shade300 ,


                                        ),
                                        Text(" Save Card For Future Payment",style: TextStyle(fontSize: 14),),
                                      ],
                                    ),



                                  ],
                                )
                                ),




                                SizedBox(height: 20,),
                                Container(
                                  height: 80,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(0xffE2EBF0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(' Amount To Pay',style: TextStyle(color: Colors.grey.shade600,fontWeight: FontWeight.bold,fontSize: 15),),
                                      Text("EGP ${(cubit.price)!*(cubit.ticket)}",style: TextStyle(color: Color(0xff5A72A0),fontSize: 25),)
                                    ],

                                  ),
                                )
                              ],
                            ),
                          ),

                        ),
                        SizedBox(height: 15,),




                      ],

                    ),
                  ),
                ),
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
                        Navigator.pushNamed(context,"finish");
                      },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)) ,
                        minWidth: 320,
                        color: Color(0xff5A72A0),
                        hoverColor: Colors.blue.shade900,
                        child: Text("  Pay EG ${(cubit.price)!*(cubit.ticket)}",style: TextStyle(color: Colors.white),),
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
