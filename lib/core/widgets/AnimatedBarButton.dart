import 'package:flutter/material.dart';

class AnimatedBorderButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final bool isProfit;
  const AnimatedBorderButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.isProfit,
  });

  @override
  State<AnimatedBorderButton> createState() => _AnimatedBorderButtonState();
}

class _AnimatedBorderButtonState extends State<AnimatedBorderButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              gradient: SweepGradient(
                center: Alignment.center,
                startAngle: 0,
                endAngle: 3.14 * 2,
                transform: GradientRotation(_controller.value * 3.14 * 2),
                colors: widget.isProfit
                    ? const [
                        Colors.green,
                        Colors.white,
                      ]
                    : const [
                        Colors.red,
                        Colors.white,
                      ],
                stops: const [0.0, 0.5],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(6),
              ),
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}
