import 'package:flutter/material.dart';
import 'package:second/components/quick_action_card.dart';

import 'build_header.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildHeader(title: "Quick Actions"),
        
        // Responsive container
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calculate card width based on available space
              final cardWidth = (constraints.maxWidth - 20) / 2; // 20 for gap
              final cardHeight = cardWidth * 1.17; // Maintain aspect ratio
              
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child: QuickActionCard(
                      mainTitle: "Buy Daily Ticket",
                      subTitle: "Quick Purchase",
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child: QuickActionCard(
                      mainTitle: "Get Subscribtion",
                      subTitle: "Monthly Passes",
                      type: "calendar",
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}