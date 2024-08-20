import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash_image.png',
              width: 200,
              height: 200,
            ),
            // const SizedBox(height: 20),
            // const Text(
            //   'SANTAI',
            //   style: TextStyle(
            //     fontSize: 50,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.black,
            //   ),
            // ),
            // const SizedBox(height: 5),
            // const Text(
            //   'YOUR NO.1 MOTORCYCLE MAINTENANCE SERVICE PROVIDER',
            //   style: TextStyle(
            //     fontSize: 14, 
            //     color: Colors.black,
            //     fontWeight: FontWeight.bold,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
          ],
        ),
      ),
    );
  }
}