import 'package:apptest/utils/screen_utils.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  double width, height;
  String label;
  BorderRadiusGeometry? borderRadius;
  Color? labelColor;

  Gradient? gradient;
  Function onTap;

  CustomButton(
      {this.gradient,
      required this.onTap,
      required this.label,
      this.height = 50,
      this.width = double.infinity,
      this.labelColor,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        this.onTap();
      },
      child: Container(
        width: this.width,
        height: this.height,
        decoration: BoxDecoration(
            gradient: this.gradient, borderRadius: this.borderRadius),
        child: Center(
          child: Text(
            this.label,
            style: TextStyle(color: this.labelColor),
          ),
        ),
      ),
    );
  }
}
