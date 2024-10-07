import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/domain/entities/profile/profile_user.dart';
import 'package:santai/app/domain/usecases/profile/insert_profile_user.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/services/timezone_service.dart';

class RegUserProfileController extends GetxController {
  final isLoading = false.obs;

  final referenceCodeController = TextEditingController();
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final genderController = TextEditingController();

  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();

  final posCodeController = TextEditingController();
  final countryController = TextEditingController();

  final genderOptions = ['Male', 'Female'];
  final selectedGender = 'Male'.obs;

  final UserInsertProfile insertProfileUser;
  RegUserProfileController({
    required this.insertProfileUser,
  });

  bool validateFields() {

    if (firstNameController.text.isEmpty ||
        dateOfBirthController.text.isEmpty ||
        selectedGender.value.isEmpty ||
        addressController.text.isEmpty ||
        cityController.text.isEmpty ||
        stateController.text.isEmpty ||
        posCodeController.text.isEmpty ||
        countryController.text.isEmpty) {
      return false;
    }

     final datetimeOfBirthController = DateTime.parse(dateOfBirthController.text);
    datetimeOfBirthController.toString();

   return true;
  }

  Future<void> register() async {
    if (!validateFields()) {
      CustomToast.show(
        message: "Please fill in all required fields",
        type: ToastType.error,
      );
      return;
    }

    isLoading.value = true;

    try {
      final TimezoneService timezoneService = TimezoneService();
      String timezone = await timezoneService.getDeviceTimezone();

      final profileUser = ProfileUser(
        timeZoneId: timezone,
        referralCode: referenceCodeController.text,
        address: ProfileAddress(
          addressLine1: addressController.text,
          city: cityController.text,
          state: stateController.text,
          postalCode: posCodeController.text,
          country: countryController.text,
        ),
        personalInfo: ProfilePersonalInfo(
          firstName: firstNameController.text,
          middleName: middleNameController.text,
          lastName: lastNameController.text,
          dateOfBirth: dateOfBirthController.text,
          gender: selectedGender.value,
        ),
      );

      await insertProfileUser(profileUser);

      CustomToast.show(
        message: "Successfully Register Profile!",
        type: ToastType.success,
      );

      Get.offAllNamed(Routes.REG_MOTORCYCLE);
    } catch (error) {
      CustomToast.show(
        message: "Login failed: ${error.toString()}",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    referenceCodeController.dispose();
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    dateOfBirthController.dispose();
    genderController.dispose();

    addressController.dispose();
    cityController.dispose();
    stateController.dispose();

    posCodeController.dispose();
    countryController.dispose();

    super.onClose();
  }
}
