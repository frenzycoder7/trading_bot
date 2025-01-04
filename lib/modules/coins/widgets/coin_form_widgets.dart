import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';

class AnimatedFormContainer extends StatelessWidget {
  final Widget child;

  const AnimatedFormContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class CoinFormSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final bool disabled;
  final bool useDecimals;
  final int decimals;

  const CoinFormSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.disabled = false,
    this.useDecimals = false,
    this.decimals = 1,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedFormContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ${useDecimals ? value.toStringAsFixed(decimals) : value.round()}',
            style: TextStyle(
              fontSize: 16,
              color: disabled ? Theme.of(context).disabledColor : null,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: disabled
                    ? null
                    : () {
                        if (value > min) {
                          final step = useDecimals ? 0.1 : 1.0;
                          onChanged((value - step).clamp(min, max));
                        }
                        FocusScope.of(context).unfocus();
                      },
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Expanded(
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  divisions: useDecimals
                      ? ((max - min) * pow(10, decimals)).round()
                      : (max - min).round(),
                  label: useDecimals
                      ? value.toStringAsFixed(decimals)
                      : value.round().toString(),
                  onChanged: disabled
                      ? null
                      : (value) {
                          onChanged(value);
                          FocusScope.of(context).unfocus();
                        },
                ),
              ),
              IconButton(
                onPressed: disabled
                    ? null
                    : () {
                        if (value < max) {
                          final step = useDecimals ? 0.1 : 1.0;
                          onChanged((value + step).clamp(min, max));
                        }
                        FocusScope.of(context).unfocus();
                      },
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CoinFormSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool disabled;

  const CoinFormSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedFormContainer(
      child: SwitchListTile(
        title: Text(
          label,
          style: TextStyle(
            color: disabled ? Theme.of(context).disabledColor : null,
          ),
        ),
        value: value,
        onChanged: disabled ? null : onChanged,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String label;

  const SubmitButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    this.label = 'Add Coin',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: isLoading ? Colors.green.shade300 : Colors.green,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Processing...',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                )
              : Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
        ),
      ),
    );
  }
}
