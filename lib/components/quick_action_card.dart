import 'package:flutter/material.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({
    Key? key,
    required this.mainTitle,
    required this.subTitle,this.type = "ticket",
  }) : super(key: key);

  final String mainTitle;
  final String subTitle;
  final String type; // calender or ticket

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 210,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF5B9BD5), Color(0xFF4A90C8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(type == "ticket" ?
              Icons.confirmation_number_outlined : Icons.calendar_month_sharp,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          // Title
          Text(
            mainTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          // Subtitle
          Text(
            subTitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
