import 'package:flutter/material.dart';

/// A professional, customizable switch widget with animation and ripple effect.
class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final double width;
  final double height;
  final Duration duration;
  final double borderRadius;
  final IconData? activeIcon;
  final IconData? inactiveIcon;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.thumbColor = Colors.white,
    this.width = 56.0,
    this.height = 32.0,
    this.duration = const Duration(milliseconds: 250),
    this.borderRadius = 20.0,
    this.activeIcon,
    this.inactiveIcon,
  });

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  late bool _isPressed;

  @override
  void initState() {
    super.initState();
    _isPressed = false;
  }

  void _handleTap() {
    widget.onChanged(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        width: widget.width,
        height: widget.height,
        duration: widget.duration,
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: widget.value ? widget.activeColor : widget.inactiveColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Optional icons
            if (widget.activeIcon != null && widget.inactiveIcon != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      widget.inactiveIcon,
                      size: 18,
                      color: widget.value
                          ? widget.inactiveColor.withAlpha(179)
                          : widget.thumbColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      widget.activeIcon,
                      size: 18,
                      color: widget.value
                          ? widget.thumbColor
                          : widget.activeColor.withAlpha(179),
                    ),
                  ),
                ],
              ),
            // Thumb
            AnimatedAlign(
              alignment: widget.value
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              duration: widget.duration,
              curve: Curves.easeInOut,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Material(
                  color: widget.thumbColor,
                  shape: const CircleBorder(),
                  elevation: _isPressed ? 6 : 2,
                  child: Container(
                    width: widget.height - 8,
                    height: widget.height - 8,
                    alignment: Alignment.center,
                    child: (widget.value && widget.activeIcon != null)
                        ? Icon(
                            widget.activeIcon,
                            size: 16,
                            color: widget.activeColor,
                          )
                        : (!widget.value && widget.inactiveIcon != null)
                        ? Icon(
                            widget.inactiveIcon,
                            size: 16,
                            color: widget.inactiveColor,
                          )
                        : null,
                  ),
                ),
              ),
            ),
            // Ripple effect
            if (_isPressed)
              Positioned.fill(
                child: AnimatedOpacity(
                  opacity: _isPressed ? 0.2 : 0.0,
                  duration: const Duration(milliseconds: 150),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
