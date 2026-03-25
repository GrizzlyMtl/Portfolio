import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final double elevation;
  final double borderRadius;

  const CustomCard({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.elevation = 4,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}
