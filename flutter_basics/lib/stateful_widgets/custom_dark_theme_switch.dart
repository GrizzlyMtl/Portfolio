import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A professional, accessible, modern dark theme switch with label and description.
class CustomDarkThemeSwitch extends StatefulWidget {
  final String settingsKey;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? label;
  final String? description;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final double width;
  final double height;
  final Duration duration;
  final double borderRadius;
  final IconData? activeIcon;
  final IconData? inactiveIcon;
  final bool glassy;

  const CustomDarkThemeSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.description,
    this.activeColor = const Color(0xFF4F8CFF),
    this.inactiveColor = const Color(0xFF23272F),
    this.thumbColor = Colors.white,
    this.width = 60.0,
    this.height = 34.0,
    this.duration = const Duration(milliseconds: 300),
    this.borderRadius = 22.0,
    this.activeIcon = Icons.dark_mode,
    this.inactiveIcon = Icons.light_mode,
    this.glassy = true,
    this.settingsKey = 'custom_dark_theme_switch',
  });

  @override
  State<CustomDarkThemeSwitch> createState() => _CustomDarkThemeSwitchState();
}

class _CustomDarkThemeSwitchState extends State<CustomDarkThemeSwitch> {
  bool? _localValue;

  @override
  void initState() {
    super.initState();
    _loadSetting();
  }

  Future<void> _loadSetting() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(widget.settingsKey)) {
      setState(() {
        _localValue = prefs.getBool(widget.settingsKey);
      });
    }
  }

  Future<void> _saveSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(widget.settingsKey, value);
  }

  bool _isPressed = false;
  bool _isFocused = false;

  void _handleTap() {
    final newValue = !(_localValue ?? widget.value);
    setState(() {
      _localValue = newValue;
    });
    widget.onChanged(newValue);
    _saveSetting(newValue);
  }

  void _handleFocus(bool focus) {
    setState(() => _isFocused = focus);
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    // Use runtimeType for compatibility if RawKeyDownEvent is not directly available
    if (event is KeyDownEvent &&
        (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.space)) {
      _handleTap();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final bool effectiveValue = _localValue ?? widget.value;
    final switchWidget = Focus(
      onFocusChange: _handleFocus,
      autofocus: false,
      canRequestFocus: true,
      onKeyEvent: _handleKey,
      child: GestureDetector(
        onTap: _handleTap,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: Semantics(
          label: widget.label ?? 'Dark theme switch',
          value: effectiveValue ? 'On' : 'Off',
          button: true,
          toggled: effectiveValue,
          child: AnimatedContainer(
            width: widget.width,
            height: widget.height,
            duration: widget.duration,
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: effectiveValue ? widget.activeColor : widget.inactiveColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [
                if (_isPressed)
                  BoxShadow(
                    color: Colors.black.withAlpha(64),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                if (_isFocused)
                  BoxShadow(
                    color: widget.activeColor.withAlpha(128),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                if (widget.glassy)
                  BoxShadow(
                    color: Colors.white.withAlpha(20),
                    blurRadius: 24,
                    spreadRadius: 1,
                  ),
              ],
              gradient: widget.glassy
                  ? LinearGradient(
                      colors: widget.value
                          ? [
                              widget.activeColor.withAlpha(217),
                              widget.activeColor.withAlpha(140),
                            ]
                          : [
                              widget.inactiveColor.withAlpha(243),
                              widget.inactiveColor.withAlpha(179),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
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
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(
                          widget.inactiveIcon,
                          size: 18,
                          color: widget.value
                              ? widget.inactiveColor.withAlpha(120)
                              : widget.thumbColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Icon(
                          widget.activeIcon,
                          size: 18,
                          color: widget.value
                              ? widget.thumbColor
                              : widget.activeColor.withAlpha(120),
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
                    child: AnimatedContainer(
                      duration: widget.duration,
                      curve: Curves.easeInOut,
                      width: widget.height - 8,
                      height: widget.height - 8,
                      decoration: BoxDecoration(
                        color: widget.thumbColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(46),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        gradient: widget.glassy
                            ? LinearGradient(
                                colors: [
                                  Colors.white.withAlpha(243),
                                  Colors.white.withAlpha(179),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                      ),
                      child: Center(
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
                      opacity: _isPressed ? 0.18 : 0.0,
                      duration: const Duration(milliseconds: 120),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(
                            widget.borderRadius,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    if (widget.label == null && widget.description == null) {
      return switchWidget;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        switchWidget,
        if (widget.label != null || widget.description != null)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.label != null)
                  Text(
                    widget.label!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (widget.description != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      widget.description!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
