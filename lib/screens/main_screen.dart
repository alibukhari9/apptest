import 'package:apptest/components/benefits_item.dart';
import 'package:apptest/components/custom_button.dart';
import 'package:apptest/screens/camera_screen.dart';
import 'package:apptest/utils/constant.dart';
import 'package:apptest/utils/navigation.dart';
import 'package:apptest/utils/screen_utils.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/student.jpg'),
                      fit: BoxFit.cover)),
            ),
            Container(
              padding: EdgeInsets.all(20),
              height: double.infinity,
              width: double.infinity,
              color: Colors.black.withOpacity(0.2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Text(
                          'Are you a student',
                          textScaleFactor: 1.2,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                          onTap: () {
                            AppNavigation.pushToScreen(context,
                                screen: CamerScreen());
                          },
                          label: 'Upload Student ID Card',
                          gradient: greenGradient,
                          height: ScreenUtil.getHeight(context) * 0.05,
                          width: ScreenUtil.getWidth(context) * 0.6,
                          labelColor: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Benefits',
                            textScaleFactor: 1.2,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        BenefitsItem(
                            text:
                                '10% discount on all our Vaqra clothing articles. 2 ways to implement this.'),
                        SizedBox(
                          height: 10,
                        ),
                        BenefitsItem(text: '30% discount on all deliveries'),
                        SizedBox(
                          height: 10,
                        ),
                        BenefitsItem(
                            text: '10% discount on our stylist services'),
                        SizedBox(
                          height: 10,
                        ),
                        BenefitsItem(
                            text:
                                '10% discount on our way to promote packages'),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Skip',
                        textScaleFactor: 1.2,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
