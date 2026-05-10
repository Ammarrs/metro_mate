import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:second/SubscrbtionScreen3,4/Notfications/Notfication_Cubit.dart';
import 'package:second/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Bloc/SelectRoute_State.dart';
import 'Bloc/selectRoute_Cubit.dart';
import 'VerticalStepsLine.dart';

class Routedeatils extends StatelessWidget {
  const Routedeatils({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectRoute, RouteState>(builder: (context, state) {
      final cubit = context.read<SelectRoute>();

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
                S.current.routeDetails,
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
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "Screen3");
                  },
                  icon: Icon(Icons.info)),
              BlocBuilder<NotificationCubit, int>(
                builder: (context, count) {
                  return Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "NotificationScreen");
                        },
                        icon: Icon(Icons.notifications),
                      ),
                      if (count > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              count.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              )
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
                                        "${cubit.time} ${S.of(context).minutes}")
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
                                        "${cubit.distance} ${S.of(context).KM}")
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
                                    Text("${cubit.numStation}")
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
                                    Text("${S.of(context).EGP} ${cubit.price} ")
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
                                  Column(
                                    children: [
                                      Text(
                                        "${cubit.time}\n${S.of(context).minutes}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 21,
                                          color: Color(0xff5A72A0),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${cubit.distance} ${S.of(context).KM} ",
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    radius: 10,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(S.current.Line1),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.redAccent,
                                    radius: 10,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(S.current.Line2),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.greenAccent,
                                    radius: 10,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(S.current.Line3),
                                ],
                              ),
                              const SizedBox(height: 20),
                              if (LineNumberForStation1 ==
                                  LineNumberForStation2)
                                buildLine(LineNumberForStation1)
                              else ...[
                                buildLine(LineNumberForStation1),
                                const SizedBox(height: 20),
                                buildLine(LineNumberForStation2),
                              ],
                            ]),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(1, 2),
                )
              ], color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Center(
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "SelectQuantity");
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    minWidth: 320,
                    color: Color(0xff5A72A0),
                    hoverColor: Colors.blue.shade900,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FontAwesomeIcons.ticket,
                          color: Colors.white,
                        ),
                        Text("      "),
                        Text(
                          S.current.buyTicketRoute,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
