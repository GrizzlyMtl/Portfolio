import 'package:flutter/material.dart';

/// A professional, customizable radio knob widget for modern Flutter apps.
class CustomRadioKnob<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final String label;
  final Color activeColor;
  final Color inactiveColor;
  final double size;
  final double knobSize;
  final TextStyle? labelStyle;
  final Widget? icon;

  const CustomRadioKnob({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
    this.activeColor = Colors.blueAccent,
    this.inactiveColor = Colors.grey,
    this.size = 32.0,
    this.knobSize = 16.0,
    this.labelStyle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool selected = value == groupValue;
    return InkWell(
      borderRadius: BorderRadius.circular(size),
      onTap: () => onChanged(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: 8)],
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? activeColor : inactiveColor,
                width: 2.5,
              ),
              color: selected ? activeColor.withAlpha(20) : Colors.transparent,
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: activeColor.withAlpha(46),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: selected ? knobSize : 0,
                height: selected ? knobSize : 0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? activeColor : Colors.transparent,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style:
                labelStyle ??
                Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: selected ? activeColor : inactiveColor,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
          ),
        ],
      ),
    );
  }
}
