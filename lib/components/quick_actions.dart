import 'package:flutter/material.dart';
import 'package:second/components/quick_action_card.dart';
import 'package:second/generated/l10n.dart';

import 'build_header.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildHeader(title: s.QuickActions),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = (constraints.maxWidth - 20) / 2;
              final cardHeight = cardWidth * 1.17;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child: QuickActionCard(
                      mainTitle: s.BuyDailyTicket,
                      subTitle: s.QuickPurchase,
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child: QuickActionCard(
                      mainTitle: s.GetSubscription,
                      subTitle: s.MonthlyPasses,
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
