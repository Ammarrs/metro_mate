import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/settings/settings_cubit.dart';
import '../cubits/settings/settings_state.dart';
import 'settings_card.dart';

class NotificationsCard extends StatelessWidget {
  const NotificationsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();
        return SettingsCard(
          sectionTitle: 'Notifications',
          sectionIcon: Icons.notifications_outlined,
          children: [
            SettingsToggleRow(
              title: 'Push Notifications',
              subtitle: 'Receive app notifications',
              value: state.isPushNotificationsEnabled,
              onChanged: cubit.togglePushNotifications,
            ),
            SettingsToggleRow(
              title: 'Email Notifications',
              subtitle: 'Receive updates via email',
              value: state.isEmailNotificationsEnabled,
              onChanged: cubit.toggleEmailNotifications,
            ),
            SettingsToggleRow(
              title: 'SMS Alerts',
              subtitle: 'Important updates via SMS',
              value: state.isSmsAlertsEnabled,
              onChanged: cubit.toggleSmsAlerts,
            ),
            SettingsToggleRow(
              title: 'Marketing',
              subtitle: 'Promotions and offers',
              value: state.isMarketingEnabled,
              onChanged: cubit.toggleMarketing,
            ),
          ],
        );
      },
    );
  }
}