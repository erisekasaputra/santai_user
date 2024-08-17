import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:santai/app/routes/app_pages.dart';

class MotorcycleInformationController extends GetxController {
  final verifyOwnership = '5fsg6785cTggKL'.obs;
  final chassisNumber = '5fsg6785cTggKL'.obs;
  final engineNumber = ''.obs;
  final insuranceNo = ''.obs;
  final insuranceCompany = '1999'.obs;
  final roadTaxExpireDate = ''.obs;
  final odometer = ''.obs;
  final purchasedDate = ''.obs;

  final TextEditingController verifyOwnershipController = TextEditingController();
  final TextEditingController chassisNumberController = TextEditingController();
  final TextEditingController engineNumberController = TextEditingController();
  final TextEditingController insuranceNoController = TextEditingController();
  final TextEditingController insuranceCompanyController = TextEditingController();
  final TextEditingController roadTaxExpireDateController = TextEditingController();
  final TextEditingController odometerController = TextEditingController();
  final TextEditingController purchasedDateController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    verifyOwnershipController.text = verifyOwnership.value;
    chassisNumberController.text = chassisNumber.value;
    insuranceCompanyController.text = insuranceCompany.value;
  }

  final selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  void showImageSourceDialog() {
    Get.dialog(
      AlertDialog(
        title: const Center(
          child: Text(
            'Select Image Source',
            style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold), 
          ),
        ),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.black, size: 30), 
              title: const Text(
                'Gallery',
                style: TextStyle(color: Colors.black, fontSize: 20) 
              ),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.black, size: 30), 
              title: const Text(
                'Camera',
                style: TextStyle(color: Colors.black, fontSize: 20)
              ),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  void saveInformation() {
  print('Saving motorcycle information...');
  Get.snackbar('Success', 'Motorcycle information saved successfully');
  Get.toNamed(Routes.MOTORCYCLE_DETAIL);
}
  @override
  void onClose() {
    verifyOwnershipController.dispose();
    chassisNumberController.dispose();
    engineNumberController.dispose();
    insuranceNoController.dispose();
    insuranceCompanyController.dispose();
    roadTaxExpireDateController.dispose();
    odometerController.dispose();
    purchasedDateController.dispose();
    super.onClose();
  }
}