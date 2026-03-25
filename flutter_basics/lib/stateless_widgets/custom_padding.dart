import 'package:flutter/material.dart';

class CustomPadding extends StatelessWidget {
  final Widget child;
  final double horizontal;
  final double vertical;

  const CustomPadding({
    super.key,
    required this.child,
    this.horizontal = 16.0,
    this.vertical = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: child,
    );
  }
}
