// lib/widgets/crowdedness_indicator.dart
//
// A coloured pill badge with a pulsing dot that shows live station crowdedness.
// Receives only a CrowdednessLevel — knows nothing about cubits or services.

import 'package:flutter/material.dart';
import '../models/crowdedness_level.dart';

class CrowdednessIndicator extends StatelessWidget {
  const CrowdednessIndicator({super.key, required this.level});

  final CrowdednessLevel level;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color       : level.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border      : Border.all(color: level.color.withOpacity(0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PulseDot(color: level.color),
          const SizedBox(width: 6),
          Text(
            level.label,
            style: TextStyle(
              fontSize  : 12,
              fontWeight: FontWeight.w600,
              color     : level.color,
            ),
          ),
        ],
      ),
    );
  }
}

// Animated dot — pulses to signal this is live data.
class _PulseDot extends StatefulWidget {
  const _PulseDot({required this.color});
  final Color color;

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double>   _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync   : this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width : 8,
        height: 8,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}