import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'OnbordingScreens.dart';
import 'block/Cubit.dart';
import 'Authentication/ForgetPassword/Forget_Password.dart';
import 'Authentication/ForgetPassword/NewPassword_Page.dart';
import 'Authentication/Regestration/Register_Otp.dart';
import 'Authentication/Regestration/Register_page.dart';
import 'Authentication_Cubit/ForgetPassword_Cubit/ForgetPassword_Cubit.dart';
import 'Authentication_Cubit/Register_Cubit/Register_Cubit.dart';



void main() {
  runApp(MetroApp());
}

class MetroApp extends StatelessWidget {
  const MetroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
      create: (context) => OnBoardingCubit()..CheckSeen(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Onbordingscreen(),
      
      BlocProvider(
        create: (context)=>RegisterCubit() ,
      ),
      BlocProvider(
        create: (context)=>ForgetPasswordCubit() ,
      ),
    );
  }
}

    ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(),
        routes: {
          'Home':(context)=>Home(),
          'Register':(context)=>RegisterPage(),
          'RegisterOtp':(context)=>RegisterOtp(),
          'ForgetPassword':(context)=>ForgetPassword(),
          /*'VerifyEmail':(context)=>  VerifyEmail(),*/
          'NewpasswordPage':(context)=>NewpasswordPage()


        },
      ),
    );
  }
}

class Home extends StatelessWidget {
  Home({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MaterialButton(onPressed: (){
                Navigator.pushNamed(context, 'Register');
              },
                child: Text("GO To Register Page "),

              ),
              SizedBox(height: 20,),
              MaterialButton(onPressed: (){
                Navigator.pushNamed(context, 'ForgetPassword');
              },
                child: Text("GO To Forget Password Page "),
              )


            ],
          ),
        ),
      ),
    );
  }
}
