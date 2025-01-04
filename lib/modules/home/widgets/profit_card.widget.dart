import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trading_bot/extensions/context_extensions.dart';

class ProfitCard extends StatelessWidget {
  final String label;
  final double amount;
  final bool isPositive;
  final bool isLoading;

  const ProfitCard({
    super.key,
    required this.label,
    required this.amount,
    required this.isPositive,
    this.isLoading = false,
  });

  String _formatAmount(double amount) {
    final symbol = isPositive ? '+\$' : '-\$';
    final absAmount = amount.abs();

    if (absAmount >= 10000000) {
      return '$symbol${(absAmount / 10000000).toStringAsFixed(2)} Cr';
    } else if (absAmount >= 100000) {
      return '$symbol${(absAmount / 100000).toStringAsFixed(2)} L';
    } else if (absAmount >= 1000) {
      return '$symbol${(absAmount / 1000).toStringAsFixed(2)}K';
    }

    return '$symbol${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return context.shimmerLoader(
        height: 60,
        width: 100,
        borderRadius: 12,
        padding: 10,
        margin: 5,
        opacity: 0.1,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatAmount(amount),
            style: TextStyle(
              color: isPositive ? Colors.greenAccent : Colors.redAccent,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
