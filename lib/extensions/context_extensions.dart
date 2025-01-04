import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trading_bot/core/widgets/shimmer_text.dart';
import 'package:fluttertoast/fluttertoast.dart';

extension ContextExtensions on BuildContext {
  AppBar animatedAppBar({
    required String title,
    required VoidCallback onBackPressed,
    VoidCallback? onInfoPressed,
    String dialogTitle = 'Information',
    String dialogContent = 'Add your information here.',
    List<Color>? gradientColors,
    Duration animationDuration = const Duration(seconds: 2),
    List<Widget>? actions,
    double? elevation,
    BorderRadius? borderRadius,
    TextStyle? titleStyle,
    TextStyle? dialogTitleStyle,
    TextStyle? dialogContentStyle,
    Color? baseShimmerColor,
    Color? highlightShimmerColor,
    Color? dialogBackgroundColor,
    BorderRadius? dialogBorderRadius,
  }) {
    return AppBar(
      elevation: elevation ?? 4,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors ??
                [
                  Theme.of(this).primaryColor.withOpacity(0.8),
                  Theme.of(this).primaryColor,
                  Theme.of(this).primaryColorDark,
                ],
          ),
        ),
        child: TweenAnimationBuilder(
          duration: animationDuration,
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return Stack(
              children: [
                Positioned(
                  right: -50 + (150 * value),
                  top: -20,
                  child: Opacity(
                    opacity: 0.2,
                    child: Icon(
                      Icons.currency_bitcoin,
                      size: 100,
                      color: Colors.white.withOpacity(value),
                    ),
                  ),
                ),
                Positioned(
                  left: -30 + (100 * value),
                  bottom: -10,
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(
                      Icons.attach_money,
                      size: 80,
                      color: Colors.white.withOpacity(value),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      title: ShimmerText(
        text: title,
        baseColor: baseShimmerColor ?? Colors.white,
        highlightColor: highlightShimmerColor ?? Colors.white.withOpacity(0.7),
        style: titleStyle ??
            const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
      ),
      leading: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 800),
        tween: Tween<double>(begin: 0, end: 1),
        curve: Curves.elasticOut,
        builder: (context, double value, child) {
          return Transform.rotate(
            angle: (1 - value) * 1.5,
            child: Transform.scale(
              scale: value,
              child: child,
            ),
          );
        },
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: onBackPressed,
        ),
      ),
      actions: actions ??
          [
            if (onInfoPressed != null)
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 1000),
                tween: Tween<double>(begin: 0, end: 1),
                curve: Curves.bounceOut,
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.white),
                  onPressed: () {
                    showGeneralDialog(
                      context: this,
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return ScaleTransition(
                          scale: animation,
                          child: AlertDialog(
                            backgroundColor: dialogBackgroundColor ??
                                Theme.of(context).primaryColor.withOpacity(0.9),
                            title: Text(
                              dialogTitle,
                              style: dialogTitleStyle ??
                                  const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            content: Text(
                              dialogContent,
                              style: dialogContentStyle ??
                                  const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: dialogBorderRadius ??
                                  BorderRadius.circular(15),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'Close',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 400),
                      barrierDismissible: true,
                      barrierLabel: '',
                      barrierColor: Colors.black54,
                    );
                  },
                ),
              ),
          ],
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ??
            const BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
      ),
    );
  }

  void showToast({
    required String message,
    Color backgroundColor = Colors.red,
    Toast length = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: length,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

extension NavigationExtension on BuildContext {
  Future<bool> showConfirmationDialog({
    String title = 'Confirmation',
    String message = 'Are you sure?',
    String cancelText = 'No',
    String confirmText = 'Yes',
  }) async {
    final result = await showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Widget shimmerLoader({
    double height = 60,
    double width = 100,
    double borderRadius = 12,
    double padding = 10,
    double margin = 5,
    double opacity = 0.1,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding),
        margin: EdgeInsets.symmetric(horizontal: margin, vertical: margin),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(opacity),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        height: height,
        width: width,
      ),
    );
  }

  Widget circularLoader({
    double size = 15,
    double strokeWidth = 1,
  }) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
