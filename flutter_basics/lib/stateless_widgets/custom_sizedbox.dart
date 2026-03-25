import 'package:flutter/material.dart';

class CustomSizedBox extends StatelessWidget {
  final double width;
  final double height;

  const CustomSizedBox({super.key, this.width = 10, this.height = 10});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, height: height);
  }
}
