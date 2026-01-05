import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:metro_mate/ChangePassword.dart';

import 'Bloc/Navigate_cubit.dart';
import 'Bloc/selectRoute_Cubit.dart';
import 'Buy_Ticket/ChosePaymentMethod.dart';
import 'Buy_Ticket/CreditDetils.dart';
import 'Buy_Ticket/PaymentFinish.dart';
import 'Buy_Ticket/Select Quantity.dart';
import 'NavigationBar_Page/Home.dart';
import 'NavigationBar_Page/Tickets.dart';
import 'NavigationBar_Page/setting.dart';
import 'NavigationBar_Page/wallet.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'RouteDeatils.dart';

void main() {
  runApp(MetroApp());
}

class MetroApp extends StatelessWidget {
  const MetroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [

      BlocProvider(
        create: (context)=>Navigate_Cubit() ,
      ),
      BlocProvider(
        create: (context)=>SelectRoute() ,
      ),

    ],




      child:MaterialApp(
      debugShowCheckedModeBanner: false,
      home: test_page(),
      routes: {
        'test_page':(context)=>test_page(),
        'Home':(context)=>Home(),

        'detalis':(context)=>Routedeatils(),
        'SelectQuantity':(context)=>SelectQuantity(),
        'Chosepaymentmethod':(context)=>Chosepaymentmethod(),
        'Creditdetils': (context)=>Creditdetils(),
        'finish': (context)=>Paymentfinish(),
        'ChangePassword': (context)=>Changepassword(),


      },
    )
    );
  }
}


class test_page extends StatelessWidget {
   test_page({super.key});

   List<Widget>NavigationBarpage=[Home(),Tickets(),Wallet(),Setting()];
   int CurrentIndex =0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFCFCFD),
      appBar:AppBar( automaticallyImplyLeading: false,) ,
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
