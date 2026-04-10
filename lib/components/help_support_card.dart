import 'package:flutter/material.dart';
import 'settings_card.dart';

class HelpSupportCard extends StatelessWidget {
  final VoidCallback? onAbout;           // was onHelpCenter
  final VoidCallback? onContactSupport;

  const HelpSupportCard({
    super.key,
    this.onAbout,
    this.onContactSupport,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      sectionTitle: 'Help & Support',
      children: [
        const Divider(height: 1, thickness: 0.8, indent: 20, endIndent: 20),
        _HelpNavRow(
          title: 'About',                // was 'Help Center'
          subtitle: 'FAQs and guides',
          leadingIcon: Icons.info_outline,
          onTap: onAbout,
          isHighlighted: true,
        ),
        _HelpNavRow(
          title: 'Contact Support',
          subtitle: 'Get help from our team',
          leadingIcon: Icons.chat_bubble_outline,
          onTap: onContactSupport,
        ),
      ],
    );
  }
}

class _HelpNavRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData leadingIcon;
  final VoidCallback? onTap;
  final bool isHighlighted;

  const _HelpNavRow({
    required this.title,
    required this.subtitle,
    required this.leadingIcon,
    this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isHighlighted ? kLightBlue : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Icon(leadingIcon, color: kPrimaryBlue, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A2E3D))),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF8FA8BE))),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF8FA8BE), size: 22),
            ],
          ),
        ),
      ),
    );
  }
}