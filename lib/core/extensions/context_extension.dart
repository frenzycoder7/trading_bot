import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trading_bot/core/widgets/AnimatedBarButton.dart';

enum SnackBarType { error, success }

extension SnackBarExtension on BuildContext {
  void showAppSnackBar({
    required String message,
    required SnackBarType type,
    Duration? duration,
  }) {
    final backgroundColor =
        type == SnackBarType.error ? Colors.red : Colors.green;

    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration ?? const Duration(seconds: 4),
        action: type == SnackBarType.error
            ? SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () {},
              )
            : null,
      ),
    );
  }

  Widget animatedBorderButton({
    required VoidCallback onPressed,
    required Widget child,
    required bool isProfit,
  }) {
    return AnimatedBorderButton(
      onPressed: onPressed,
      isProfit: isProfit,
      child: child,
    );
  }
}

extension DateExtension on String {
  String formatDate() {
    final date = DateTime.parse(this);
    return DateFormat('EEE').format(date);
  }
}
