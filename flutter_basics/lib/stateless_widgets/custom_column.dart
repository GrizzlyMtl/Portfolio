import 'package:flutter/material.dart';

class CustomColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment alignment;

  const CustomColumn({
    super.key,
    required this.children,
    this.alignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: alignment, children: children);
  }
}
