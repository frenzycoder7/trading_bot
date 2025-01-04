import 'package:flutter/material.dart';
import 'package:trading_bot/core/widgets/shimmer_text.dart';

class PriceDisplayBox extends StatelessWidget {
  const PriceDisplayBox({
    super.key,
    required this.label,
    required this.price,
    required this.baseColor,
    this.fontSize = 11,
    this.labelSize = 9,
  });

  final String label;
  final double price;
  final Color baseColor;
  final double fontSize;
  final double labelSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            baseColor.withOpacity(0.2),
            baseColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: baseColor.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$label ',
            style: TextStyle(
              color: Colors.grey,
              fontSize: labelSize,
              fontWeight: FontWeight.w500,
            ),
          ),
          ShimmerText(
            text: '\$${price.toStringAsFixed(2)}',
            baseColor: baseColor,
            highlightColor: baseColor.withOpacity(0.5),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}