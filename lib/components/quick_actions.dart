import 'package:flutter/material.dart';
import 'package:metro_mate/components/build_header.dart';
import 'package:metro_mate/components/quick_action_card.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildHeader(title: "Quick Actions",),
            Container(
              width: double.infinity,
              height: 220,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    QuickActionCard(mainTitle: "Buy Daily Ticket", subTitle: "Quick Purchase"),
                    QuickActionCard(mainTitle: "Get Subscribtion", subTitle: "Monthly Passes", type: "calendar",),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}