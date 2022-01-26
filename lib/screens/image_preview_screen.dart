import 'dart:io';

import 'package:apptest/utils/navigation.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  XFile image;
  ImagePreview(this.image);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: FileImage(File(image.path)), fit: BoxFit.cover)),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => AppNavigation.popScreen(context),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
