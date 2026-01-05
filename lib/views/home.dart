import 'package:flutter/material.dart';
import 'package:metro_mate/components/wallet.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TransitHeaderComponent(),
    );
  }
}