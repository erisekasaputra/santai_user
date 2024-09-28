import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/domain/usecases/profile/insert_profile_user.dart';
import 'package:santai/app/routes/app_pages.dart';

class RegUserProfileController extends GetxController {
  final isLoading = false.obs;

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


  final UserInsertProfile insertProfileUser;
  RegUserProfileController({
    required this.insertProfileUser,
  });


  Future<void> register() async {
    isLoading.value = true;

    try {

      await Future.delayed(const Duration(seconds: 2));

      CustomToast.show(
        message: "Registration Success",
        type: ToastType.success,
      );


      Get.toNamed(Routes.REG_MOTORCYCLE);
      
    } catch (e) {
      CustomToast.show(
        message: "Registration Failed",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
    
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