import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/routes/app_pages.dart';

import 'package:http/http.dart' as http;

class RegMotorcycleController extends GetxController {
  final isLoading = false.obs;

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

  void handleImageSourceSelection(ImageSource source) {
    _pickImage(source);
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  Future<void> register() async {
    isLoading.value = true;

    try {
      await Future.delayed(const Duration(seconds: 2));

      CustomToast.show(
        message: "Registration Success",
        type: ToastType.success,
      );

      // await sendRegistrationData();

      Get.toNamed(Routes.DASHBOARD);
    } catch (e) {
      CustomToast.show(
        message: "Registration Failed",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendRegistrationData() async {
  isLoading.value = true;

  try {
    var uri = Uri.parse('YOUR_API_ENDPOINT_HERE');
    var request = http.MultipartRequest('POST', uri);


    request.fields['driver_owner'] = driverOwnerController.text;
    request.fields['license_plate'] = licensePlateController.text;
    request.fields['make'] = makeController.text;
    request.fields['model'] = modelController.text;
    request.fields['year'] = yearController.text;
    request.fields['fuel_type'] = selectedGas.value;

    if (selectedImage.value != null) {
      var file = await http.MultipartFile.fromPath(
        'motorcycle_image',
        selectedImage.value!.path,
      );
      request.files.add(file);
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      CustomToast.show(
        message: "Registration Success",
        type: ToastType.success,
      );
      Get.toNamed(Routes.DASHBOARD);
    } else {
      CustomToast.show(
        message: "Registration Failed: ${response.reasonPhrase}",
        type: ToastType.error,
      );
    }
  } catch (e) {
    CustomToast.show(
      message: "Registration Failed: $e",
      type: ToastType.error,
    );
  } finally {
    isLoading.value = false;
  }
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