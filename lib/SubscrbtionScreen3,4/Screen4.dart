import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/generated/l10n.dart';

import '../Bloc/SelectRoute_State.dart';
import '../Bloc/selectRoute_Cubit.dart';

class Screen4 extends StatelessWidget {
  const Screen4({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SelectRoute>();

    return BlocConsumer<SelectRoute, RouteState>(listener: (context, state) {
      if (state is SelectPaymentSubscriptionMethodSucessState) {
        if (cubit.PaymentSubscriptionMethod == "cash") {
          Navigator.pushReplacementNamed(context, "SubscrptionCashPage");
        } else if (cubit.PaymentSubscriptionMethod == "visa card") {
          Navigator.pushReplacementNamed(
              context, "SubscrptionConfirmVisacardPage");
        }
      }

      if (state is SelectPaymentSubscriptionMethodErorrState) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.Error)),
        );
      }
    }, builder: (context, state) {
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
                        Navigator.pushNamed(context, 'Screen3');
                      },
                      icon:
                          Icon(Icons.arrow_back, size: 22, color: Colors.white),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${S.of(context).subscriptionPayment}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                        ],
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
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: 350,
                height: 350,
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
                  padding: const EdgeInsets.only(left: 5.0, top: 15, right: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).choosePaymentMethod,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey.shade50),
                        child: Center(
                          child: RadioListTile(
                            value: "cash",
                            groupValue: cubit.PaymentSubscriptionMethod,
                            onChanged: (v) {
                              if (v != null) {
                                cubit.GetPaymenSubscriptionMethod(v);
                                print(cubit.PaymentSubscriptionMethod);
                              }
                            },
                            title: Row(
                              children: [
                                SizedBox(
                                  width: 8,
                                ),
                                Image.network(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1iMzxYlwpK6HVnMzAf1YjNrrNVEv0tLUFxIDt1X6Y5A&s",
                                  width: 110,
                                  height: 70,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey.shade50),
                        child: RadioListTile(
                          value: "visa card",
                          groupValue: cubit.PaymentSubscriptionMethod,
                          onChanged: (v) {
                            if (v != null) {
                              cubit.GetPaymenSubscriptionMethod(v);
                              print(cubit.PaymentSubscriptionMethod);
                            }
                          },
                          title: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Icon(
                                  Icons.credit_card,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    S.of(context).creditDebitCard,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    S.of(context).visaMastercardAccepted,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
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
                    onPressed:
                        state is SelectPaymentSubscriptionMethodLodingState
                            ? null
                            : () {
                                if (!cubit.CheckSubscriptionMethod()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(S
                                            .of(context)
                                            .choosePaymentMethodError)),
                                  );
                                  return;
                                }

                                cubit.ticketSubscriptionPaymentKey();
                              },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    minWidth: 320,
                    color: Color(0xff5A72A0),
                    hoverColor: Colors.blue.shade900,
                    child: state is SelectPaymentSubscriptionMethodLodingState
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            S.of(context).payEg,
                            style: TextStyle(color: Colors.white),
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
