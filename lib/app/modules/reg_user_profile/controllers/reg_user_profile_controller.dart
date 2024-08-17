import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/routes/app_pages.dart';

class RegUserProfileController extends GetxController {

  final referenceCodeController = TextEditingController();
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final genderController = TextEditingController();
  final addressController = TextEditingController();
  final posCodeController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;

  final genderOptions = ['Male', 'Female'];
  final selectedGender = 'Male'.obs;


  void register() {
    Get.toNamed(Routes.REG_MOTORCYCLE);
  }


  @override
  void onClose() {
    referenceCodeController.dispose();
    fullNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    dateOfBirthController.dispose();
    genderController.dispose();
    addressController.dispose();
    posCodeController.dispose();
    super.onClose();
  }
}