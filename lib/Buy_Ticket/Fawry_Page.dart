import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/generated/l10n.dart';

import '../Bloc/SelectRoute_State.dart';
import '../Bloc/selectRoute_Cubit.dart';

class FawryPage extends StatelessWidget {
  FawryPage();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SelectRoute>();
    return BlocConsumer<SelectRoute, RouteState>(
        listener: (context, state) {},
        builder: (context, state) {
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              S.current.billReference,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "${cubit.BillRefrance}",
                              style: TextStyle(
                                  color: Color(0xff5A72A0),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.pushNamed(context, "test_page");
                              },
                              color: Color(0xff5A72A0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(
                                    color: Color(0xff5A72A0),
                                  )),
                              minWidth: 140,
                              hoverColor: Colors.blue.shade900,
                              child: Text(
                                S.current.backToHome,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
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
