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
                      width: double.infinity,
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              S.of(context).paymentSummary,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          /// 🔥 البيانات
                          buildItem(S.of(context).userName,
                              cubit.SubscriptionUserName ?? ""),
                          buildItem(S.of(context).subscriptionType,
                              cubit.SubscriptionCategory ?? ""),
                          buildItem(S.of(context).subscriptionDuration,
                              cubit.SubscriptionDuration ?? ""),
                          buildItem(S.of(context).paymentMethod,
                              cubit.PaymentSubscriptionMethod ?? ""),
                          buildItem(S.of(context).totalPaid,
                              "${S.of(context).EGP} ${cubit.SubscriptionTotalPrice}"),
                          buildItem(
                              S.of(context).date, cubit.SubscriptionDate ?? ""),

                          SizedBox(height: 25),

                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xff5A72A0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, "test_page");
                                  },
                                  child: state is SubscriptionVisaLoadingState
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(S.of(context).GoToHome,
                                          style:
                                              TextStyle(color: Colors.white)),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Color(0xff5A72A0)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, "Screen4");
                                  },
                                  child: Text(
                                    S.of(context).back,
                                    style: TextStyle(color: Color(0xff5A72A0)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

Widget buildItem(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Color(0xff5A72A0),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
