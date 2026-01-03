import 'package:flutter/material.dart';
class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(height: 30,),
            Text(" Setting Page ")


          ],
        ),
      ),
    );
  }
}
