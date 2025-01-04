import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';

class AnimatedTabContainer extends StatefulWidget {
  final Widget child;
  final double height;

  const AnimatedTabContainer({
    super.key,
    required this.child,
    required this.height,
  });

  @override
  State<AnimatedTabContainer> createState() => _AnimatedTabContainerState();
}

class _AnimatedTabContainerState extends State<AnimatedTabContainer>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _colorController;
  List<List<Color>> gradientSets = [
    [Colors.blue, Colors.purple],
  ];
  int currentGradientIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    Timer.periodic(const Duration(seconds: 15), (timer) {
      if (mounted) {
        _changeGradient();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _changeGradient() {
    setState(() {
      currentGradientIndex = (currentGradientIndex + 1) % gradientSets.length;
      _colorController.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _colorController]),
      builder: (context, child) {
        final currentColors = gradientSets[currentGradientIndex];
        final nextColors =
            gradientSets[(currentGradientIndex + 1) % gradientSets.length];

        return Container(
          height: widget.height,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.lerp(currentColors[0], nextColors[0],
                        _colorController.value) ??
                    currentColors[0],
                Color.lerp(currentColors[1], nextColors[1],
                        _colorController.value) ??
                    currentColors[1],
              ],
              begin: Alignment(
                cos(_controller.value * 2 * pi) * 1.5,
                sin(_controller.value * 2 * pi) * 1.5,
              ),
              end: Alignment(
                cos((_controller.value + 0.5) * 2 * pi) * 1.5,
                sin((_controller.value + 0.5) * 2 * pi) * 1.5,
              ),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: widget.child,
        );
      },
    );
  }
}
