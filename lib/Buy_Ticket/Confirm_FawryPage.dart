import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/generated/l10n.dart';

import '../Bloc/SelectRoute_State.dart';
import '../Bloc/selectRoute_Cubit.dart';

class ConfirmFawrypage extends StatelessWidget {
  ConfirmFawrypage();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SelectRoute>();
    return BlocConsumer<SelectRoute, RouteState>(listener: (context, state) {
      if (state is FawryPaymentSucessState) {
        Navigator.pushNamed(context, "Fawry");
      }
      if (state is FawryPaymentErorrState) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.Error),
            backgroundColor: Colors.red,
          ),
        );
      }
    }, builder: (context, state) {
      return Scaffold(
        backgroundColor: Color(0xff33BCC6),
        body: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Center(
            child: Column(
              children: [
                Image.network(
                  "https://images.alborsaanews.com/2025/01/%D8%A3%D9%85%D8%A7%D9%86.jpg",
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
                          S.current.paymentSummary,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(S.current.userName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.grey,
                                      )),
                                  SizedBox(height: 6),
                                  Text(S.current.paymentId,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.grey,
                                      )),
                                  SizedBox(height: 6),
                                  Text(S.current.paymentMethod,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.grey,
                                      )),
                                  SizedBox(height: 6),
                                  Text(S.current.totalPaid,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.grey,
                                      )),
                                  SizedBox(height: 6),
                                  Text(S.current.date,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${cubit.UserName}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color(0xff5A72A0))),
                                    SizedBox(height: 6),
                                    Text("${cubit.PaymentId}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color(0xff5A72A0))),
                                    SizedBox(height: 6),
                                    Text("${cubit.PaymentMethod}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color(0xff5A72A0))),
                                    SizedBox(height: 6),
                                    Text(
                                        "${S.current.EGP}  ${(cubit.price)! * (cubit.ticket)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color(0xff5A72A0))),
                                    SizedBox(height: 6),
                                    Text("${cubit.Date}",
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
                        /*Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('User Name', style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),),
                                Text("Abdelrahman",
                                  style: TextStyle(
                                      color: Color(0xff5A72A0), fontSize: 17),)
                              ],

                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Payment ID', style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),),
                                Text("458712559",
                                  style: TextStyle(
                                      color: Color(0xff5A72A0), fontSize: 17),)
                              ],

                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Payment Method', style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),),
                                Text("Fawry",
                                  style: TextStyle(
                                      color: Color(0xff5A72A0), fontSize: 17),)
                              ],

                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Date', style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),),
                                Text("2026-2-16",
                                  style: TextStyle(
                                      color: Color(0xff5A72A0), fontSize: 17),)
                              ],

                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Total Amount', style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),),
                                Text("EGP ${(cubit.price)! * (cubit.ticket)}",
                                  style: TextStyle(
                                      color: Color(0xff5A72A0), fontSize: 17),)
                              ],

                            ),*/

                        /*Container(
                              height: 80,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xffE2EBF0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('Total Amount', style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),),
                                  Text("EGP ${(cubit.price)! * (cubit.ticket)}",
                                    style: TextStyle(
                                        color: Color(0xff5A72A0), fontSize: 25),)
                                ],

                              ),
                            ),*/
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                cubit.ticketfawrypayment();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              minWidth: 110,
                              color: Color(0xff5A72A0),
                              hoverColor: Colors.blue.shade900,
                              child: state is FawryPaymentLodingState
                                  ? CircularProgressIndicator(
                                      color: Colors.white)
                                  : Text(
                                      S.current.payButton,
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
                                Navigator.pushNamed(
                                    context, "Chosepaymentmethod");
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(
                                    color: Color(0xff5A72A0),
                                  )),
                              minWidth: 110,
                              hoverColor: Colors.blue.shade900,
                              child: Text(
                                S.current.back,
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
