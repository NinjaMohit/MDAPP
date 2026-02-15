import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:md_app/splash/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  final SplashController splashcontroller = Get.put(SplashController());
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          'assets/image_spalsh.jpg',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
