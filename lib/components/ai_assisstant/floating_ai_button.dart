import 'package:flutter/material.dart';
import 'package:second/components/ai_assisstant/ai_chat_screen.dart';

class FloatingAiButton extends StatelessWidget {
  const FloatingAiButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'ai_assistant_fab',
      onPressed: () => Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const AiChatScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              SlideTransition(
                position: Tween(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
                child: child,
              ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
    );
  }
}