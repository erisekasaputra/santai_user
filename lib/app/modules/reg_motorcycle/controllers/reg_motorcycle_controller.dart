import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/domain/entities/fleet/fleet_user.dart';
import 'package:santai/app/domain/usecases/fleet/insert_fleet_user.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/routes/app_pages.dart';

// import 'package:http/http.dart' as http;
import 'package:santai/app/services/image_upload_service.dart';

class RegMotorcycleController extends GetxController {
  final isLoading = false.obs;

  final registrationNumberController = TextEditingController();
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final yearOfManufactureController = TextEditingController();
  final chasisNumberController = TextEditingController();
  final engineNumberController = TextEditingController();
  final insuranceNumberController = TextEditingController();
  final isInsuranceValidController = true.obs;
  final lastInspectionDateLocalController = TextEditingController();
  final odometerReadingController = TextEditingController();
  final ownerNameController = TextEditingController();
  final ownerAddressController = TextEditingController();

  final vehicleTypeOptions = ['Motorcycle'];
  final selectedVehicleType = 'Motorcycle'.obs;

  final gasOptions = [
    'Gasoline',
    'Diesel' 'Electric',
    'Hybrid',
    'CompressedNaturalGas',
    'LiquifiedPetroleumGas',
    'Biodiesel',
    'Hydrogen'
  ];
  final selectedGas = 'Gasoline'.obs;

  final usageStatusOptions = [
    'Private',
    'Commercial',
    'Taxi',
    'Rental',
    'PublicService',
    'Logistic'
  ];
  final selectedUsageStatus = 'Private'.obs;

  final ownershipStatusOptions = [
    'FullyOwned',
    'Leased',
    'Underload',
    'CoOwned',
    'Gifted',
    'Rental'
  ];
  final selectedOwnershipStatus = 'FullyOwned'.obs;

  final transmissionOptions = ['Manual', 'Automatic'];
  final selectedTransmission = 'Manual'.obs;

  final selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  final resourceName = ''.obs;

  final UserInsertFleet insertFleetUser;
  final ImageUploadService _imageUploadService;
  RegMotorcycleController({
    required this.insertFleetUser,
    required ImageUploadService imageUploadService,
  }) : _imageUploadService = imageUploadService;

  bool validateFields() {
    if (registrationNumberController.text.isEmpty ||
        brandController.text.isEmpty ||
        modelController.text.isEmpty ||
        yearOfManufactureController.text.isEmpty ||
        chasisNumberController.text.isEmpty ||
        engineNumberController.text.isEmpty ||
        insuranceNumberController.text.isEmpty ||
        lastInspectionDateLocalController.text.isEmpty ||
        odometerReadingController.text.isEmpty ||
        ownerNameController.text.isEmpty ||
        ownerAddressController.text.isEmpty ||
        selectedGas.value.isEmpty ||
        selectedUsageStatus.value.isEmpty ||
        selectedOwnershipStatus.value.isEmpty ||
        selectedTransmission.value.isEmpty) {
      return false;
    }

    final datetimeLastInspectionDateLocalController =
        DateTime.parse(lastInspectionDateLocalController.text);
    datetimeLastInspectionDateLocalController.toString();

    return true;
  }

  void handleImageSourceSelection(ImageSource source) {
    _pickImage(source);
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);

      isLoading.value = true;

      try {
        resourceName.value = await _imageUploadService.uploadImage(selectedImage.value!);

        print("HASILLLL   resourceName: $resourceName");

        CustomToast.show(
          message: "Image uploaded successfully",
          type: ToastType.success,
        );
      } catch (e) {
        CustomToast.show(
          message: "Error uploading image: $e",
          type: ToastType.error,
        );
      } finally {
        isLoading.value = false;
      }
    }
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
      final dataFleetUser = FleetUser(
        registrationNumber: registrationNumberController.text,
        brand: brandController.text,
        model: modelController.text,
        yearOfManufacture: int.parse(yearOfManufactureController.text),
        chassisNumber: chasisNumberController.text,
        engineNumber: engineNumberController.text,
        insuranceNumber: insuranceNumberController.text,
        isInsuranceValid: isInsuranceValidController.value,
        vehicleType: selectedVehicleType.value,
        lastInspectionDateLocal:
            DateTime.parse(lastInspectionDateLocalController.text),
        odometerReading: int.parse(odometerReadingController.text),
        ownerName: ownerNameController.text,
        ownerAddress: ownerAddressController.text,
        fuelType: selectedGas.value,
        usageStatus: selectedUsageStatus.value,
        ownershipStatus: selectedOwnershipStatus.value,
        transmissionType: selectedTransmission.value,
        imageUrl: resourceName.value,
      );

      await insertFleetUser(dataFleetUser);

      CustomToast.show(
        message: "Successfully Register Motorcycle!",
        type: ToastType.success,
      );

      Get.offAllNamed(Routes.DASHBOARD);
    } catch (error) {
      if (error is CustomHttpException) {
        CustomToast.show(
          message: error.message,
          type: ToastType.error,
        );
      } else {
        CustomToast.show(
          message: "An unexpected error occurred",
          type: ToastType.error,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // driverOwnerController.dispose();
    // licensePlateController.dispose();
    // makeController.dispose();
    // modelController.dispose();
    // yearController.dispose();
    // fuelTypeController.dispose();
    super.onClose();
  }
}
