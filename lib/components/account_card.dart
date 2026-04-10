import 'package:flutter/material.dart';
import '../views/history.dart';
import 'settings_card.dart';

class AccountCard extends StatelessWidget {
  final VoidCallback? onHistory;

  const AccountCard({super.key, this.onHistory});

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      sectionTitle: 'Account',
      children: [
        SettingsNavRow(
          title: 'History',
          subtitle: 'View your recent trips',
          leadingIcon: Icons.history,
          onTap: onHistory ??
              () => Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (_) => const HistoryPage()),
                  ),
          showDivider: true,
        ),
      ],
    );
  }
}