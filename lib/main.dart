import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metro_mate/cubits/login/login_cubit.dart';
import 'package:metro_mate/services/auth_service.dart';
import 'package:metro_mate/views/home.dart';
import 'package:metro_mate/views/login_view.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit(AuthService()),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'loginPage',
        routes: {
          'loginPage': (context) => const LoginPage(),
          'home': (context) => const Home(),
        },
      ),
    );
  }
}
