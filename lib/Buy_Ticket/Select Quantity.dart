import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import '../Bloc/SelectRoute_State.dart';
import '../Bloc/selectRoute_Cubit.dart';
class SelectQuantity extends StatelessWidget {
  const SelectQuantity({super.key});

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
                          Navigator.pushNamed(context, 'detalis');
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
                          color: Colors.grey.shade400,
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Select Quantity",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                                Container(
                                  width: 90,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color(0xff5A72A0),
                                    
                                  ),
                                  child: Center(child: Text("EGP ${cubit.price} each",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.white),)),
                                )
                              ],
                            ),
                              SizedBox(height: 30,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               children: [
                                 MaterialButton(onPressed: (){
                                   cubit.Abstract();
                                 },
                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
                                       side: BorderSide(color: Color(0xff5A72A0),)) ,
                                   minWidth: 60,
                                   height: 60,

                                   hoverColor: Colors.grey,
                                   child: Text("-",style: TextStyle(color: Color(0xff5A72A0),fontSize: 40),),
                                 ),
                                Container(
                                  width: 80,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color(0xffFBFCFD)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text("${cubit.ticket}",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Color(0xff5A72A0)),),
                                      Text("ticket",style: TextStyle(color: Colors.grey),)
                                    
                                    ],
                                  ),
                                ),
                                 MaterialButton(onPressed: (){
                                   cubit.Add();
                                 },
                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
                                       side: BorderSide(color: Color(0xff5A72A0),)) ,
                                   minWidth: 60,
                                   height: 60,

                                   hoverColor: Colors.grey,
                                   child: Text("+",style: TextStyle(color: Color(0xff5A72A0),fontSize: 25),),
                                 )
                               ],
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
                                    Text('Total Amount',style: TextStyle(color: Colors.grey.shade600,fontWeight: FontWeight.bold,fontSize: 15),),
                                    Text("EGP ${(cubit.price)!*(cubit.ticket)}",style: TextStyle(color: Color(0xff5A72A0),fontSize: 25),)
                                  ],

                                ),
                              )
                            ],
                          ),
                        ),

                      ),
                      SizedBox(height: 15,),
                      Container(
                        width: 200,
                        height: 150,
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
                                "Route Summary",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Color(0xff5A72A0),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${cubit.ShowStation1} → ${cubit.ShowStation2}',
                                          style: TextStyle(fontSize: 13),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                "${cubit.time} min • ${cubit.distance} km",
                                                style: TextStyle(color: Colors.grey, fontSize: 15),
                                                overflow: TextOverflow.ellipsis, // لمنع overflow
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
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
                      Navigator.pushNamed(context,"Chosepaymentmethod");
                    },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)) ,
                      minWidth: 320,
                      color: Color(0xff5A72A0),
                      hoverColor: Colors.blue.shade900,
                      child: Text(" Continue To Payment",style: TextStyle(color: Colors.white),),
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
