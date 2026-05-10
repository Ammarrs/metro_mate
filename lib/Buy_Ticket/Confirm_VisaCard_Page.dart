import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/generated/l10n.dart';

import '../Bloc/SelectRoute_State.dart';
import '../Bloc/selectRoute_Cubit.dart';
import 'VisaCard_Page.dart';

class ConfirmVisacardPage extends StatelessWidget {
  ConfirmVisacardPage();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SelectRoute>();
    return BlocConsumer<SelectRoute, RouteState>(listener: (context, state) {
      if (state is VisaCardPaymentSucessState) {
        if (cubit.Iframe_Url != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VisacardPage(iframeUrl: cubit.Iframe_Url!),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).iframeNullError),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
      if (state is VisaCardPaymentErorrState) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.Error),
            backgroundColor: Colors.red,
          ),
        );
      }
    }, builder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Center(
            child: Column(
              children: [
                Image.network(
                  "https://thumbs.dreamstime.com/b/web-183282979.jpg",
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(S.of(context).userName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.grey,
                                      )),
                                  SizedBox(height: 6),
                                  Text(S.of(context).paymentId,
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
                                        "${S.of(context).EGP}  ${(cubit.price)! * (cubit.ticket)}",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                cubit.ticketvisapayment();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              minWidth: 110,
                              color: Color(0xff5A72A0),
                              hoverColor: Colors.blue.shade900,
                              child: state is VisaCardPaymentLodingState
                                  ? Center(
                                      child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    ))
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
