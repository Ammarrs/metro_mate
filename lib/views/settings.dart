import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/settings/settings_cubit.dart';
import '../cubits/settings/settings_state.dart';
import '../components/app_preference_card.dart';
import '../components/notifications_card.dart';
import '../components/security_privacy_card.dart';
import '../components/account_card.dart';
import '../components/help_support_card.dart';
import '../components/settings_card.dart';
import '../components/about_card.dart';

/// Entry point – provides the [SettingsCubit] to the whole page.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(),
      child: const _SettingsContent(),
    );
  }
}

class _SettingsContent extends StatelessWidget {
  const _SettingsContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: kCardMaxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── Page header ──
                  _SettingsHeader(),
                  const SizedBox(height: 24),

                  // ── Section cards ──
                  const AppPreferencesCard(),
                  const SizedBox(height: 20),

                  const NotificationsCard(),
                  const SizedBox(height: 20),

                  const SecurityPrivacyCard(),
                  const SizedBox(height: 20),

                  const AccountCard(),
                  const SizedBox(height: 20),

                  const HelpSupportCard(),
                  const SizedBox(height: 20),

                  const AboutCard(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Header matching the Metro Mate "buildHeader" style
class _SettingsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Settings',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1A2E3D),
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}
