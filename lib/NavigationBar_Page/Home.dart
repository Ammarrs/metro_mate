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
            // Home App Bar with gradient
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
                  padding: const EdgeInsets.only(top: 20, bottom: 30),
                  children: [
                    // 1. Plan Your Route
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                      child: PlanYorRoute(cubit: cubit),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // 2. Quick Actions
                    QuickActions(),
                    
                    const SizedBox(height: 20),
                    
                    // 3. Nearest Metro Station
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
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








// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:second/components/nearest_metro_station.dart';
// import 'package:second/components/plan_your_rote.dart';
// import 'package:second/components/quick_actions.dart';




// import '../Bloc/SelectRoute_State.dart';
// import '../Bloc/selectRoute_Cubit.dart';
// import 'Tickets.dart';

// class Home extends StatelessWidget {
//   Home({super.key});


//   @override
//   Widget build(BuildContext context) {
//     final cubit= context.read<SelectRoute>();

//     return  BlocConsumer<SelectRoute,RouteState>(
//       listener: (context,state){
//         if (state is InfoErorrState) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.Error),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }

//         if (state is InfoSucessState) {
//           cubit.ClearSelection();
//           Navigator.pushNamed(context, "detalis");
//         }


//       },
//       builder: (context,state) {
//         return Padding(
//           padding: const EdgeInsets.all(30.0),
//           child: ListView(
//             children: [
//               PlanYorRoute(cubit: cubit),
//               QuickActions(),
//               NearestMetroStation(),
//             ],
//           ),
//         );
//       }
//     );
//   }
// }

