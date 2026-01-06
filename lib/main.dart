import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:second/ChangePassword/ChangePassword_Cubit.dart';
import 'package:second/components/home_app_bar.dart';

import 'package:second/services/auth_service.dart';
import 'package:second/views/login_view.dart';
import 'package:second/views/profile_page_view.dart';

import 'Bloc/Navigate_cubit.dart';
import 'Bloc/selectRoute_Cubit.dart';
import 'Buy_Ticket/ChosePaymentMethod.dart';
import 'Buy_Ticket/CreditDetils.dart';
import 'Buy_Ticket/PaymentFinish.dart';
import 'Buy_Ticket/Select Quantity.dart';
import 'ChangePassword/ChangePassword.dart';
import 'NavigationBar_Page/Home.dart';
import 'NavigationBar_Page/Tickets.dart';
import 'NavigationBar_Page/setting.dart';
import 'NavigationBar_Page/wallet.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'RouteDeatils.dart';
import 'OnbordingScreens.dart';
import 'block/Cubit.dart';
import 'Authentication/ForgetPassword/Forget_Password.dart';
import 'Authentication/ForgetPassword/NewPassword_Page.dart';
import 'Authentication/Regestration/Register_Otp.dart';
import 'Authentication/Regestration/Register_page.dart';
import 'Authentication_Cubit/ForgetPassword_Cubit/ForgetPassword_Cubit.dart';
import 'Authentication_Cubit/Register_Cubit/Register_Cubit.dart';


import 'components/wallet.dart';
import 'cubits/login/login_cubit.dart';



void main() {
  runApp(MetroApp());
}

class MetroApp extends StatelessWidget {
  const MetroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context)=>ChangePasswordCubit() ,
      ),
        BlocProvider(
        create: (context)=>RegisterCubit() ,
    ),
    BlocProvider(
    create: (context)=>ForgetPasswordCubit() ,
    ),
    BlocProvider(create: (context) => LoginCubit(AuthService()),),

      BlocProvider(
        create: (context)=>Navigate_Cubit() ,
      ),
      BlocProvider(
        create: (context)=>SelectRoute() ,
      ),
      BlocProvider(
      create: (context) => OnBoardingCubit()..CheckSeen(),
      )
    ],










      child:MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Onbordingscreen(),
      routes: {
        'test_page':(context)=>test_page(),
        'Home':(context)=>Home(),
        'loginPage': (context) => const LoginPage(),
        'Register':(context)=>RegisterPage(),
        'RegisterOtp':(context)=>RegisterOtp(),
        'ForgetPassword':(context)=>ForgetPassword(),
        /*'VerifyEmail':(context)=>  VerifyEmail(),*/
        'NewpasswordPage':(context)=>NewpasswordPage(),
        'detalis':(context)=>Routedeatils(),
        'SelectQuantity':(context)=>SelectQuantity(),
        'Chosepaymentmethod':(context)=>Chosepaymentmethod(),
        'Creditdetils': (context)=>Creditdetils(),
        'finish': (context)=>Paymentfinish(),
        'ChangePassword': (context)=>Changepassword(),
        'Onbordingscreen': (context)=>Onbordingscreen(),
        'Profile': (context) => ProfilePageView(),
      },
    )
    );
  }
}


class test_page extends StatelessWidget {
   test_page({super.key});

   List<Widget>NavigationBarpage=[Home(),Tickets(),Wallet(),Setting()];
    List<PreferredSizeWidget> NavigationBarAppBar = [
     AppBar(title: HomeAppBar(),automaticallyImplyLeading: false,),
     AppBar(title: Text("Ticket"),automaticallyImplyLeading: false,),
     AppBar(title: Text("Profile"),automaticallyImplyLeading: false,),
     AppBar(title: Text("Settings"),automaticallyImplyLeading: false,),
   ];


   int CurrentIndex =0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFCFCFD),
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(kToolbarHeight),
      //   child: BlocBuilder<Navigate_Cubit,int>(builder: (context,state){
        
      //     return  NavigationBarAppBar.elementAt(state);
        
      //   }),
      // ) ,

      body:BlocBuilder<Navigate_Cubit,int>(builder: (context,state){
        
        return  NavigationBarpage.elementAt(state);
        
      }) ,


      bottomNavigationBar: BlocBuilder<Navigate_Cubit,int>(
        builder: (context,state) {
          return BottomNavigationBar(

              onTap: (value){
                CurrentIndex=value;
                context.read<Navigate_Cubit>().ChangeIndex(value);
                context.read<SelectRoute>().Hide();
                context.read<SelectRoute>().ClearSelection();

              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,

              currentIndex: state,
              selectedItemColor: Colors.blue.shade300,
              unselectedItemColor: Colors.grey,
              items: [


                BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined),label: "Home"),
                BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.ticket),label: "Tickets"),
                BottomNavigationBarItem(  icon: Icon(Icons.account_balance_wallet),label: "Wallet"),
                BottomNavigationBarItem(icon: Icon(Icons.settings),label: "Settings"),

              ]
          );
        }
      ),


    );
  }
}
