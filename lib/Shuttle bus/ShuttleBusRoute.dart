import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:second/Bloc/SelectRoute_State.dart';
import 'package:second/Bloc/selectRoute_Cubit.dart';
import 'package:second/VerticalStepsLine.dart';
import 'package:second/generated/l10n.dart';

class Shuttlebusroute extends StatelessWidget {
  const Shuttlebusroute({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectRoute, RouteState>(builder: (context, state) {
      final cubit = context.read<SelectRoute>();

      final int LineNumberForStation1 =
          cubit.StationLine(cubit.ShowBusStation1!);
      final int LineNumberForStation2 =
          cubit.StationLine(cubit.ShowBusStation2!);

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
                S.current.routeDetails,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${cubit.ShowBusStation1} → ${cubit.ShowBusStation2}',
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(1, 2),
                            )
                          ],
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${S.of(context).tripInformation}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                  child: Icon(
                                    Icons.access_time,
                                    color: Color(0xff5A72A0),
                                  ),
                                  backgroundColor: Colors.grey.shade100,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "${S.of(context).duration}",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                        "${cubit.BustravelTime} ${S.of(context).minutes}")
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                CircleAvatar(
                                  child: Icon(
                                    Icons.location_on_outlined,
                                    color: Color(0xff5A72A0),
                                  ),
                                  backgroundColor: Colors.grey.shade100,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "${S.of(context).distance}",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                        "${cubit.Busdistance} ${S.of(context).KM}")
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xff5A72A0),
                                  ),
                                  backgroundColor: Colors.grey.shade100,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${S.of(context).transfer}",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text("${cubit.Busstops}")
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                CircleAvatar(
                                  child: Icon(
                                    FontAwesomeIcons.ticket,
                                    color: Color(0xff5A72A0),
                                  ),
                                  backgroundColor: Colors.grey.shade100,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${S.of(context).ticketPrice}",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                        "${S.of(context).EGP} ${cubit.Busprice} ")
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        S.current.FastestRoute,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        S.of(context).BestRoute,
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const SizedBox(height: 20),
                              VerticalStepsLine(
                                values: cubit.BusLine,
                                color: Colors.blue,
                              )
                            ]),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
