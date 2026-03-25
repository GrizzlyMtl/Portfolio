import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final Color color;
  final double borderRadius;
  final BoxDecoration decoration;

  const CustomContainer({
    super.key,
    required this.child,
    this.width = 200,
    this.height = 200,
    this.color = Colors.grey,
    this.borderRadius = 12,
    this.decoration = const BoxDecoration(
      color: Color.fromARGB(255, 34, 34, 34),
      boxShadow: [BoxShadow(blurRadius: 12, offset: Offset(0, 6))],
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
