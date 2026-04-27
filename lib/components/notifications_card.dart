import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/settings/settings_cubit.dart';
import '../cubits/settings/settings_state.dart';
import '../generated/l10n.dart';
import 'settings_card.dart';

class NotificationsCard extends StatelessWidget {
  const NotificationsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();

        return SettingsCard(
          sectionTitle: S.of(context).notifications,
          sectionIcon: Icons.notifications_outlined,
          children: [
            SettingsToggleRow(
              title: S.of(context).pushNotifications,
              subtitle: S.of(context).receiveNotifications,
              value: state.isPushNotificationsEnabled,
              onChanged: cubit.togglePushNotifications,
            ),
            SettingsToggleRow(
              title: S.of(context).emailNotifications,
              subtitle: S.of(context).receiveEmailUpdates,
              value: state.isEmailNotificationsEnabled,
              onChanged: cubit.toggleEmailNotifications,
            ),
            SettingsToggleRow(
              title: S.of(context).smsAlerts,
              subtitle: S.of(context).smsUpdates,
              value: state.isSmsAlertsEnabled,
              onChanged: cubit.toggleSmsAlerts,
            ),
            SettingsToggleRow(
              title: S.of(context).marketing,
              subtitle: S.of(context).offersPromotions,
              value: state.isMarketingEnabled,
              onChanged: cubit.toggleMarketing,
            ),
          ],
        );
      },
    );
  }
}
