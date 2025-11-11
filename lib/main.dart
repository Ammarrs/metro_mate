import 'package:flutter/material.dart';
import 'package:metro_mate/login.dart';

void main() {
  runApp(MetroMate());
}

class MetroMate extends StatefulWidget {
  const MetroMate({super.key});

  @override
  State<MetroMate> createState() => _MetroMateState();
}

class _MetroMateState extends State<MetroMate> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const loginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
