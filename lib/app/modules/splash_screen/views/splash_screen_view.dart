import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/theme/app_theme.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color colorPrimary50 = Theme.of(context).colorScheme.primary_300;
    return Scaffold(
      backgroundColor: colorPrimary50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_hd_santaimoto_white.png',
              width: 300,
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
}
