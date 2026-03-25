import 'package:flutter/material.dart';

/// A professional, customizable dropdown button widget.
class CustomDropdownButton<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final Widget? icon;
  final double borderRadius;
  final Color? dropdownColor;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final TextStyle? style;
  final bool isExpanded;

  const CustomDropdownButton({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.hint,
    this.icon,
    this.borderRadius = 8.0,
    this.dropdownColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.elevation = 2,
    this.style,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).inputDecorationTheme.fillColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          items: items,
          value: value,
          onChanged: onChanged,
          hint: hint != null ? Text(hint!, style: style) : null,
          icon: icon ?? const Icon(Icons.arrow_drop_down),
          borderRadius: BorderRadius.circular(borderRadius),
          dropdownColor: dropdownColor,
          elevation: elevation.toInt(),
          style: style ?? Theme.of(context).textTheme.bodyLarge,
          isExpanded: isExpanded,
        ),
      ),
    );
  }
}
