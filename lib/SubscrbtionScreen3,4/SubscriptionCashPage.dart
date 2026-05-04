import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/generated/l10n.dart';

import '../Bloc/SelectRoute_State.dart';
import '../Bloc/selectRoute_Cubit.dart';
import 'SubscrptionPayMob.dart';

class SubscrptionCashPage extends StatelessWidget {
  SubscrptionCashPage();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SelectRoute>();
    return BlocConsumer<SelectRoute, RouteState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Center(
                child: Column(
                  children: [
                    Image.network(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1iMzxYlwpK6HVnMzAf1YjNrrNVEv0tLUFxIDt1X6Y5A&s",
                      width: 250,
                      height: 200,
                    ),
                    Container(
                      width: 300,
                      height: 450,
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
                              S.of(context).paymentSummary,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(S.of(context).userName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.grey,
                                          )),
                                      SizedBox(height: 6),
                                      Text(S.of(context).subscriptionType,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.grey,
                                          )),
                                      SizedBox(height: 6),
                                      Text(S.of(context).subscriptionDuration,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.grey,
                                          )),
                                      SizedBox(height: 6),
                                      Text(S.of(context).paymentMethod,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.grey,
                                          )),
                                      SizedBox(height: 6),
                                      Text(S.of(context).totalPaid,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.grey,
                                          )),
                                      SizedBox(height: 6),
                                      Text(S.of(context).date,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.grey,
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("${cubit.SubscriptionUserName}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Color(0xff5A72A0))),
                                        SizedBox(height: 6),
                                        Text("${cubit.SubscriptionCategory}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Color(0xff5A72A0))),
                                        SizedBox(height: 6),
                                        Text("${cubit.SubscriptionDuration}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Color(0xff5A72A0))),
                                        SizedBox(height: 6),
                                        Text(
                                            "${cubit.PaymentSubscriptionMethod}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Color(0xff5A72A0))),
                                        SizedBox(height: 6),
                                        Text(
                                            "${S.of(context).EGP} ${cubit.SubscriptionTotalPrice}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Color(0xff5A72A0))),
                                        SizedBox(height: 6),
                                        Text("${cubit.SubscriptionDate}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Color(0xff5A72A0))),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, "test_page");
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  minWidth: 110,
                                  color: Color(0xff5A72A0),
                                  hoverColor: Colors.blue.shade900,
                                  child: state is SubscriptionVisaLoadingState
                                      ? CircularProgressIndicator(
                                          color: Colors.white)
                                      : Text(
                                          S.of(context).payButton,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, "Screen4");
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: BorderSide(
                                        color: Color(0xff5A72A0),
                                      )),
                                  minWidth: 110,
                                  hoverColor: Colors.blue.shade900,
                                  child: Text(
                                    S.of(context).back,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff5A72A0)),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
