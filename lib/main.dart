import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'OnbordingScreens.dart';
import 'block/Cubit.dart';

void main() {
  runApp(MetroApp());
}

class MetroApp extends StatelessWidget {
  const MetroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnBoardingCubit()..CheckSeen(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Onbordingscreen(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(backgroundColor: Colors.white, title: Text('Home page')),
      body: Text('Home', style: TextStyle(fontSize: 30, color: Colors.white)),
    );
  }
}
