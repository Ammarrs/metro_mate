import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/generated/l10n.dart';
import 'package:second/Bloc/LocaliztionCubit/Localization_Cubit.dart';

import '../cubits/settings/settings_cubit.dart';
import '../cubits/settings/settings_state.dart';
import 'settings_card.dart';

class AppPreferencesCard extends StatelessWidget {
  const AppPreferencesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();

        return SettingsCard(
          sectionTitle: S.of(context).AppPreferences,
          children: [
            // ── Language Row (UPDATED) ──
            const Divider(height: 1, thickness: 0.8, indent: 20, endIndent: 20),
            BlocBuilder<LocaleCubit, LocaleState>(
              builder: (context, state) {
                final cubit = context.read<LocaleCubit>();

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).Language,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      /// 🇪🇬 عربي
                      RadioListTile<String>(
                        title: Text("العربية"),
                        value: 'ar',
                        groupValue: cubit.currentLocale.languageCode,
                        onChanged: (value) {
                          cubit.changeToArabic();
                        },
                      ),

                      /// 🇺🇸 English
                      RadioListTile<String>(
                        title: Text("English"),
                        value: 'en',
                        groupValue: cubit.currentLocale.languageCode,
                        onChanged: (value) {
                          cubit.changeToEnglish();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

            // ── Dark Mode ──
            // SettingsToggleRow(
            //   title: S.of(context).DarkMode,
            //   subtitle: S.of(context).SwitchDarkTheme,
            //   value: state.isDarkMode,
            //   onChanged: cubit.toggleDarkMode,
            // ),

            // ── Sound Effects ──
            // SettingsToggleRow(
            //   title: S.of(context).SoundEffects,
            //   subtitle: S.of(context).EnableSounds,
            //   value: state.isSoundEnabled,
            //   onChanged: cubit.toggleSound,
            // ),
          ],
        );
      },
    );
  }
}
