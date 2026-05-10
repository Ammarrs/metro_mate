import 'package:flutter/material.dart';

const Color kPrimaryBlue = Color(0xFF5B7C99);
const Color kLightBlue = Color(0xFFEAF1F8);
const double kCardMaxWidth = 500;

/// Wraps content in a Metro Mate styled white card with shadow
class SettingsCard extends StatelessWidget {
  final String sectionTitle;
  final IconData? sectionIcon;
  final List<Widget> children;

  const SettingsCard({
    super.key,
    required this.sectionTitle,
    this.sectionIcon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: kCardMaxWidth),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(80),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                children: [
                  if (sectionIcon != null) ...[
                    Icon(sectionIcon, color: kPrimaryBlue, size: 22),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    sectionTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A2E3D),
                    ),
                  ),
                ],
              ),
            ),
            ...children,
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

/// A toggle row inside a settings card
class SettingsToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  const SettingsToggleRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showDivider)
          const Divider(height: 1, thickness: 0.8, indent: 20, endIndent: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A2E3D),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8FA8BE),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.white,
                activeTrackColor: kPrimaryBlue,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFCDD8E3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A navigation row (with chevron) inside a settings card
class SettingsNavRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? leadingIcon;
  final VoidCallback? onTap;
  final bool showDivider;
  final bool isHighlighted;

  const SettingsNavRow({
    super.key,
    required this.title,
    required this.subtitle,
    this.leadingIcon,
    this.onTap,
    this.showDivider = true,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showDivider)
          const Divider(height: 1, thickness: 0.8, indent: 20, endIndent: 20),
        Material(
          color: isHighlighted ? kLightBlue : Colors.transparent,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  if (leadingIcon != null) ...[
                    Icon(leadingIcon, color: kPrimaryBlue, size: 20),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A2E3D),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8FA8BE),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right,
                      color: Color(0xFF8FA8BE), size: 22),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
