import 'package:flutter/material.dart';

class Bullets extends StatelessWidget {
  Color color;
  Bullets({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: 8,
      decoration: BoxDecoration(shape: BoxShape.circle, color: this.color),
    );
  }
}
