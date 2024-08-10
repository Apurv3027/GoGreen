import 'package:go_green/screens/welcomePage.dart';
import 'package:go_green/utility/assets_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Splash_Screenn extends StatefulWidget {
  const Splash_Screenn({Key? key}) : super(key: key);

  @override
  State<Splash_Screenn> createState() => _Splash_ScreennState();
}

class _Splash_ScreennState extends State<Splash_Screenn> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(const WelcomePage());
    });
  }

  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: const [
        // Image(image: splash, fit: BoxFit.cover),
        Image(image: splashScreen, fit: BoxFit.cover),
      ],
    );
  }
}
