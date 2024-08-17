import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:santai/app/routes/app_pages.dart';

class RegMotorcycleController extends GetxController {
  final driverOwnerController = TextEditingController();
  final licensePlateController = TextEditingController();
  final makeController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final fuelTypeController = TextEditingController();

  final gasOptions = ['RON 95', 'RON 97', 'DIESEL', 'ELECTRIC'];
  final selectedGas = 'RON 95'.obs;

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

  void register() {
  Get.snackbar(
    "Registration Successful",
    "Your motorcycle has been registered successfully!",
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.grey[800],
    colorText: Colors.white,
    borderRadius: 10,
    margin: const EdgeInsets.all(10),
    duration: const Duration(seconds: 4),
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
  );
  Get.toNamed(Routes.DASHBOARD);
  }

  @override
  void onClose() {
    driverOwnerController.dispose();
    licensePlateController.dispose();
    makeController.dispose();
    modelController.dispose();
    yearController.dispose();
    fuelTypeController.dispose();
    super.onClose();
  }
}