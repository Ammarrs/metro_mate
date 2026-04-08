import 'package:flutter/material.dart';
import 'settings_card.dart';

class AboutCard extends StatelessWidget {
  final String version;
  // kept for future use
  final VoidCallback? onTermsOfService;
  final VoidCallback? onPrivacyPolicy;

  const AboutCard({
    super.key,
    this.version = '1.0.0',
    this.onTermsOfService,
    this.onPrivacyPolicy,
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
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          children: [
            const Text(
              'Metro Mate',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: kPrimaryBlue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Version $version',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF8FA8BE),
              ),
            ),
            // Terms of Service & Privacy Policy — hidden for now
            // const SizedBox(height: 16),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     GestureDetector(
            //       onTap: onTermsOfService,
            //       child: const Text('Terms of Service', style: TextStyle(fontSize: 13, color: kPrimaryBlue, fontWeight: FontWeight.w500)),
            //     ),
            //     const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('•', style: TextStyle(color: Color(0xFF8FA8BE), fontSize: 13))),
            //     GestureDetector(
            //       onTap: onPrivacyPolicy,
            //       child: const Text('Privacy Policy', style: TextStyle(fontSize: 13, color: kPrimaryBlue, fontWeight: FontWeight.w500)),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}