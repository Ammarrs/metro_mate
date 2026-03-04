import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/components/nearest_metro_station.dart';
import 'package:second/components/plan_your_rote.dart';
import 'package:second/components/quick_actions.dart';
import 'package:second/components/home_app_bar.dart';

import '../Bloc/SelectRoute_State.dart';
import '../Bloc/selectRoute_Cubit.dart';
import '../cubits/user/user_cubit.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    // Load user data when home screen initializes
    // This will fetch the profile photo and user info
    context.read<UserCubit>().loadUser();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SelectRoute>();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<SelectRoute, RouteState>(
      listener: (context, state) {
        if (state is InfoErorrState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.Error),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state is InfoSucessState) {
          cubit.ClearSelection();
          Navigator.pushNamed(context, "detalis");
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            // Home App Bar with gradient (now responsive)
            // The HomeAppBar will automatically listen to UserCubit
            // and display the profile photo when available
            HomeAppBar(
              onNotificationPressed: () {
                print("Notifications pressed");
              },
              onDepositPressed: () {
                print("Deposit pressed");
              },
            ),
            
            // Scrollable content
            Expanded(
              child: Container(
                color: Colors.grey[50],
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: screenHeight * 0.02,
                    bottom: screenHeight * 0.03,
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.05,
                  ),
                  child: Column(
                    children: [
                      // 1. Plan Your Route
                      PlanYorRoute(cubit: cubit),
                      
                      SizedBox(height: screenHeight * 0.025),
                      
                      // 2. Quick Actions
                      QuickActions(),
                      
                      SizedBox(height: screenHeight * 0.025),
                      
                      // 3. Nearest Metro Station
                      NearestMetroStation(),
                      
                      SizedBox(height: screenHeight * 0.02),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}