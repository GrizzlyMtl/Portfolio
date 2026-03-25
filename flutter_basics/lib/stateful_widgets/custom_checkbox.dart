import 'package:flutter/material.dart';

/// A professional, reusable custom checkbox widget.
/// Supports label, custom colors, rounded corners, and value change callback.
class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? label;
  final Color? activeColor;
  final Color? checkColor;
  final Color? borderColor;
  final double borderRadius;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry padding;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.activeColor,
    this.checkColor,
    this.borderColor,
    this.borderRadius = 8.0,
    this.labelStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
  });

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant CustomCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeColor =
        widget.activeColor ?? Theme.of(context).colorScheme.primary;
    final checkColor = widget.checkColor ?? Colors.white;
    final borderColor = widget.borderColor ?? Theme.of(context).dividerColor;
    final labelStyle =
        widget.labelStyle ?? Theme.of(context).textTheme.bodyLarge;

    return Padding(
      padding: widget.padding,
      child: InkWell(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        onTap: () {
          setState(() {
            _value = !_value;
          });
          widget.onChanged(_value);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _value ? activeColor : Colors.transparent,
                border: Border.all(color: borderColor, width: 2),
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              child: _value
                  ? Icon(Icons.check, size: 18, color: checkColor)
                  : null,
            ),
            if (widget.label != null) ...[
              const SizedBox(width: 8),
              Text(widget.label!, style: labelStyle),
            ],
          ],
        ),
      ),
    );
  }
}
