import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/domain/usecases/login_use_case.dart';
import 'package:santai/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final LoginUseCase loginUseCase;
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordHidden = true.obs;

  LoginController(this.loginUseCase);

  void login() async {
    final phone = phoneController.text;
    final password = passwordController.text;

    print('Phone: $phone, Password: $password');

    Get.toNamed(Routes.REGISTER_OTP);

    // final user = await loginUseCase.execute(phone, password);
    // print('Logged in user: ${user.email}');
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}