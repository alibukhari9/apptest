import 'package:apptest/components/bullets.dart';
import 'package:apptest/utils/constant.dart';
import 'package:flutter/material.dart';

class BenefitsItem extends StatelessWidget {
  String text;
  BenefitsItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: Bullets(color: greenColor),
        ),
        SizedBox(
          width: 5,
        ),
        Flexible(
          child: Column(
            children: [
              Text(
                text,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        )
      ],
    );
  }
}
