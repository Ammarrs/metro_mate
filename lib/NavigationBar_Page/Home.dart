import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/components/nearest_metro_station.dart';
import 'package:second/components/plan_your_rote.dart';
import 'package:second/components/quick_actions.dart';
import 'package:second/components/home_app_bar.dart';

import '../Bloc/SelectRoute_State.dart';
import '../Bloc/selectRoute_Cubit.dart';

class Home extends StatelessWidget {
  Home({super.key});

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
            HomeAppBar(
              onNotificationPressed: () {
                print("Notifications pressed");
                // You can navigate to notifications page here
              },
              onDepositPressed: () {
                print("Deposit pressed");
                // You can navigate to deposit page here
              },
            ),
            
            // Scrollable content
            Expanded(
              child: Container(
                color: Colors.grey[50],
                child: ListView(
                  padding: EdgeInsets.only(
                    top: screenHeight * 0.025,
                    bottom: screenHeight * 0.04,
                  ),
                  children: [
                    // 1. Plan Your Route
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                        vertical: screenHeight * 0.012,
                      ),
                      child: PlanYorRoute(cubit: cubit),
                    ),
                    
                    SizedBox(height: screenHeight * 0.025),
                    
                    // 2. Quick Actions
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                      ),
                      child: QuickActions(),
                    ),
                    
                    SizedBox(height: screenHeight * 0.025),
                    
                    // 3. Nearest Metro Station
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                      ),
                      child: NearestMetroStation(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}