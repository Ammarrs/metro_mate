import 'package:flutter/material.dart';
import 'package:second/generated/l10n.dart';
import 'settings_card.dart';

class AccountCard extends StatelessWidget {
  final VoidCallback? onHistory;

  const AccountCard({super.key, this.onHistory});

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      sectionTitle: S.of(context).Account,
      children: [
        SettingsNavRow(
          title: S.of(context).History,
          subtitle: S.of(context).ViewYourRecentTrips,
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
