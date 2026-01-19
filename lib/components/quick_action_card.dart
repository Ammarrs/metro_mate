import 'package:flutter/material.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({
    Key? key,
    required this.mainTitle,
    required this.subTitle,
    this.type = "ticket",
  }) : super(key: key);

  final String mainTitle;
  final String subTitle;
  final String type; // calender or ticket

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive sizing based on available space
        final containerWidth = constraints.maxWidth;
        final iconSize = containerWidth * 0.35;
        final titleFontSize = containerWidth * 0.095;
        final subtitleFontSize = containerWidth * 0.075;
        
        return Container(
          width: containerWidth,
          padding: EdgeInsets.all(containerWidth * 0.1),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Container
              Container(
                width: iconSize,
                height: iconSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF5B9BD5), Color(0xFF4A90C8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  type == "ticket"
                      ? Icons.confirmation_number_outlined
                      : Icons.calendar_month_sharp,
                  color: Colors.white,
                  size: iconSize * 0.5,
                ),
              ),
              SizedBox(height: containerWidth * 0.08),
              
              // Title - Responsive font size
              Flexible(
                child: Text(
                  mainTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleFontSize.clamp(14.0, 18.0),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2C3E50),
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: containerWidth * 0.04),
              
              // Subtitle
              Flexible(
                child: Text(
                  subTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: subtitleFontSize.clamp(12.0, 14.0),
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}