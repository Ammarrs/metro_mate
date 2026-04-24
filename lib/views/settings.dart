import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/generated/l10n.dart';
import '../cubits/settings/settings_cubit.dart';
import '../cubits/settings/settings_state.dart';
import '../components/app_preference_card.dart';
import '../components/notifications_card.dart';
import '../components/security_privacy_card.dart';
import '../components/account_card.dart';
import '../components/help_support_card.dart';
import '../components/settings_card.dart';
import '../components/about_card.dart';

/// Used in the bottom nav tab — NO Scaffold (parent already has one)
class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(),
      child: const _SettingsBody(),
    );
  }
}

/// Used when pushed as a full-screen route (e.g. from profile page)
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F4F8),
        body: SafeArea(child: _SettingsBody()),
      ),
    );
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kCardMaxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  S.current.Settings,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A2E3D),
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),
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
    );
  }
}
