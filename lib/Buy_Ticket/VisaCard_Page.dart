import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/SelectRoute_State.dart';
import '../Bloc/selectRoute_Cubit.dart';
class VisacardPage extends StatelessWidget {
  VisacardPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Visa Page")

        ],
      ),

    );
  }
}
