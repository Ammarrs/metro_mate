import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/settings/settings_cubit.dart';
import '../cubits/settings/settings_state.dart';
import 'settings_card.dart';

class SecurityPrivacyCard extends StatelessWidget {
  final VoidCallback? onChangePassword;

  const SecurityPrivacyCard({super.key, this.onChangePassword});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();
        return SettingsCard(
          sectionTitle: 'Security & Privacy',
          sectionIcon: Icons.shield_outlined,
          children: [
            // ── Biometric Login (toggle) ──
            const Divider(height: 1, thickness: 0.8, indent: 20, endIndent: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.phone_android_outlined,
                      color: kPrimaryBlue, size: 20),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Biometric Login',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A2E3D),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Use fingerprint or face ID',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8FA8BE),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: state.isBiometricEnabled,
                    onChanged: cubit.toggleBiometric,
                    activeColor: Colors.white,
                    activeTrackColor: kPrimaryBlue,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: const Color(0xFFCDD8E3),
                  ),
                ],
              ),
            ),

            // ── Change Password (nav) ──
            SettingsNavRow(
              title: 'Change Password',
              subtitle: 'Update your account password',
              leadingIcon: Icons.lock_outline,
              onTap: onChangePassword,
              showDivider: true,
            ),
          ],
        );
      },
    );
  }
}