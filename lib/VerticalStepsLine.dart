import 'package:flutter/material.dart';
class VerticalStepsLine extends StatelessWidget {
  final List<String> values;
  final Color color;

  const VerticalStepsLine({
    super.key,
    required this.values,
    this.color = const Color(0xff5A72A0),
  });

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(values.length * 2 - 1, (index) {
        if (index.isEven) {
          final stepIndex = index ~/ 2;
          final isFirst = stepIndex == 0;
          final isLast = stepIndex == values.length - 1;

          final double circleSize =
          (isFirst || isLast) ? 20 : 12;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  values[stepIndex],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Container(
              width: 3,
              height: 30,
              margin: const EdgeInsets.symmetric(vertical: 6),
              color: color,
            ),
          );
        }
      }),
    );
  }
}