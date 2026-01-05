import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import 'Bloc/SelectRoute_State.dart';
import 'Bloc/selectRoute_Cubit.dart';
import 'VerticalStepsLine.dart';
class Routedeatils extends StatelessWidget {
  const Routedeatils({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<SelectRoute,RouteState>(
        builder: (context,state) {
          final cubit= context.read<SelectRoute>();

          final int LineNumberForStation1 = cubit.StationLine(cubit.ShowStation1!);
          final int LineNumberForStation2 = cubit.StationLine(cubit.ShowStation2!);
          Widget buildLine(int line) {
            switch (line) {
              case 1:
                return VerticalStepsLine(
                  values: cubit.MetroLine1,
                  color: Colors.blue,
                );
              case 2:
                return VerticalStepsLine(
                  values: cubit.MetroLine2,
                  color: Colors.redAccent,
                );
              case 3:
                return VerticalStepsLine(
                  values: cubit.MetroLine3,
                  color: Colors.greenAccent,
                );
              default:
                return const SizedBox();
            }
          }


          return Scaffold(
            backgroundColor: Color(0xffFCFCFD),
            appBar: AppBar(
              toolbarHeight: 150,
              leading: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'test_page');
                },
                icon: Icon(Icons.arrow_back, size: 25),
                color: Colors.white,
              ),

              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Route Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
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

              flexibleSpace: Container(
                decoration: BoxDecoration(
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
                          height: 250,
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
                              children: [Text("Trip Information",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                SizedBox(height: 30,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CircleAvatar(
                                      child:
                                      Icon(Icons.access_time,
                                        color: Color(0xff5A72A0),),
                                      backgroundColor: Colors.grey.shade100,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      children: [
                                        Text("Duration",style: TextStyle(color: Colors.grey),),
                                        Text("${cubit.time} Minutes")
                                      ],
                                    ),
                                    SizedBox(width: 10,),
                                    CircleAvatar(
                                      child:
                                      Icon(Icons.location_on_outlined,
                                        color: Color(0xff5A72A0),),
                                      backgroundColor: Colors.grey.shade100,
                                    ),
                                    Column(
                                      children: [
                                        Text("Distance",style: TextStyle(color: Colors.grey),),
                                        Text("${cubit.distance} KM")
                                      ],
                                    ),

                                  ],
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CircleAvatar(
                                      child:
                                      Icon(Icons.arrow_forward,
                                        color: Color(0xff5A72A0),),
                                      backgroundColor: Colors.grey.shade100,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Transfer",style: TextStyle(color: Colors.grey),),
                                        Text("${cubit.numStation}")
                                      ],
                                    ),
                                    SizedBox(width: 10,),
                                    CircleAvatar(
                                      child:
                                      Icon(FontAwesomeIcons.ticket,
                                        color: Color(0xff5A72A0),),
                                      backgroundColor: Colors.grey.shade100,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Ticket Price",style: TextStyle(color: Colors.grey),),
                                        Text("EGP ${cubit.price}")
                                      ],
                                    ),

                                  ],
                                )
                              ],
                            ),
                          ),

                        ),
                        SizedBox(height: 15,),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(1, 2),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [


                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blue.shade300,
                                      child: Icon(
                                        FontAwesomeIcons.locationArrow,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "Best Route",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          "Fastest option available",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      children: [
                                        Text(
                                          "${cubit.time}\nmin",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 21,
                                            color: Color(0xff5A72A0),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${cubit.distance} KM",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),




                            if (LineNumberForStation1 == LineNumberForStation2)
                      buildLine(LineNumberForStation1)
                    else ...[
                    buildLine(LineNumberForStation1),
                const SizedBox(height: 20),
                buildLine(LineNumberForStation2),






                              ],
                              ]
                            ),
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
                        Navigator.pushNamed(context, "SelectQuantity");

                      },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)) ,
                        minWidth: 320,
                        color: Color(0xff5A72A0),
                        hoverColor: Colors.blue.shade900,
                        child: Row(mainAxisSize: MainAxisSize.min,
                          children: [Icon(FontAwesomeIcons.ticket,color: Colors.white,),
                            Text(" \t\t \t Buy Ticket For This Route",style: TextStyle(color: Colors.white),),
                          ],
                        ),
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

