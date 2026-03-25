import 'package:flutter/material.dart';

/// A professional, customizable slider widget with value indicator, label, and modern design.
class CustomSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final ValueChanged<double> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final double trackHeight;
  final Widget? icon;

  const CustomSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.activeColor = Colors.blueAccent,
    this.inactiveColor = Colors.grey,
    this.thumbColor = Colors.white,
    this.trackHeight = 6.0,
    this.icon,
  });

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant CustomSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _value) {
      _value = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.icon != null) ...[widget.icon!, const SizedBox(width: 12)],
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Gradient bar behind the slider
              Container(
                height: widget.trackHeight + 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.trackHeight),
                  gradient: const LinearGradient(
                    colors: [Colors.green, Colors.yellow, Colors.red],
                    stops: [0.0, 0.6, 1.0],
                  ),
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.transparent,
                  inactiveTrackColor: Colors.transparent,
                  thumbColor: widget.thumbColor,
                  overlayColor: widget.activeColor.withAlpha(38),
                  trackHeight: widget.trackHeight,
                  valueIndicatorColor: widget.activeColor,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 12,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 22,
                  ),
                  valueIndicatorTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Slider(
                  value: _value,
                  min: widget.min,
                  max: widget.max,
                  divisions: widget.divisions,
                  label: widget.label ?? _value.toStringAsFixed(2),
                  onChanged: (val) {
                    setState(() => _value = val);
                    widget.onChanged(val);
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: widget.activeColor.withAlpha(25),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: widget.activeColor, width: 1),
          ),
          child: Text(
            _value.toStringAsFixed(2),
            style: TextStyle(
              color: widget.activeColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
