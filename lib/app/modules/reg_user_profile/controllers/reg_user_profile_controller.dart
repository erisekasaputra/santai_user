import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/routes/app_pages.dart';

class RegUserProfileController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final isPasswordHidden = true.obs;

  final isAgreed = false.obs;

  void signUp() {
    // Implement your login logic here
    String phone = phoneController.text;
    String password = passwordController.text;
    String email = emailController.text;
    print('Phone: $phone, Password: $password, Email: $email');

    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
