import 'package:flutter/material.dart';

class AppNavigation {
  static void pushToScreen(BuildContext context, {required Widget screen}) {
    Navigator.push(context, MaterialPageRoute(builder: (c) => screen));
  }

  static void pushReplacement(BuildContext context, {required Widget screen}) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (c) => screen));
  }

  static void popScreen(BuildContext context) {
    Navigator.pop(context);
  }
}
