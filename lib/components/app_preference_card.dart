import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          sectionTitle: 'App Preferences',
          children: [
            // ── Language Row ──
            const Divider(height: 1, thickness: 0.8, indent: 20, endIndent: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.language, color: kPrimaryBlue, size: 20),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Language',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A2E3D),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Choose your preferred language',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8FA8BE),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _LanguageToggle(
                    selected: state.language,
                    onChanged: cubit.toggleLanguage,
                  ),
                ],
              ),
            ),

            // ── Dark Mode ──
            SettingsToggleRow(
              title: 'Dark Mode',
              subtitle: 'Switch to dark theme',
              value: state.isDarkMode,
              onChanged: cubit.toggleDarkMode,
            ),

            // ── Sound Effects ──
            SettingsToggleRow(
              title: 'Sound Effects',
              subtitle: 'Enable app sounds',
              value: state.isSoundEnabled,
              onChanged: cubit.toggleSound,
            ),
          ],
        );
      },
    );
  }
}

class _LanguageToggle extends StatelessWidget {
  final AppLanguage selected;
  final ValueChanged<AppLanguage> onChanged;

  const _LanguageToggle({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LangOption(
          label: 'English',
          isSelected: selected == AppLanguage.english,
          onTap: () => onChanged(AppLanguage.english),
        ),
        const SizedBox(width: 12),
        _LangOption(
          label: 'العربية',
          isSelected: selected == AppLanguage.arabic,
          onTap: () => onChanged(AppLanguage.arabic),
        ),
      ],
    );
  }
}

class _LangOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LangOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? kPrimaryBlue : Colors.transparent,
              border: Border.all(
                color: isSelected ? kPrimaryBlue : const Color(0xFFCDD8E3),
                width: 2,
              ),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? kPrimaryBlue
                  : const Color(0xFF8FA8BE),
            ),
          ),
        ],
      ),
    );
  }
}