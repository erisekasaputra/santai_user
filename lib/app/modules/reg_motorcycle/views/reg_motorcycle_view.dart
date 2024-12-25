import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_back_button.dart';
import 'package:santai/app/common/widgets/custom_date_picker.dart';
import 'package:santai/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai/app/common/widgets/custom_image_uploader.dart';
import 'package:santai/app/common/widgets/custom_label_001.dart';
import 'package:santai/app/common/widgets/custom_modern_dropdown.dart';
import 'package:santai/app/common/widgets/custom_text_field.dart';
import 'package:santai/app/common/widgets/custom_year_picker.dart';
import 'package:santai/app/routes/app_pages.dart';
import '../controllers/reg_motorcycle_controller.dart';

class RegMotorcycleView extends GetView<RegMotorcycleController> {
  const RegMotorcycleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 0, 8),
          child: CustomBackButton(
            onPressed: () => Get.offAllNamed(Routes.DASHBOARD),
            text: 'Skip',
          ),
        ),
        leadingWidth: 100,
        title: Obx(() => Text(
              controller.isUpdateMode.value ? 'Update' : 'Registration',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            )),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const CustomLabel(
                  text: 'Photo Motorcycle',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 5),
                Obx(() => CustomImageUploader(
                      selectedImage: controller.selectedImage.value,
                      selectedImageUrl: controller.selectedImageUrl.value,
                      isLoading: controller.isLoading.value,
                      onImageSourceSelected:
                          controller.handleImageSourceSelection,
                      fieldName: "ImageUrl",
                      error: controller.error,
                    )),
                const SizedBox(height: 10),
                const CustomLabel(
                  text: 'Registration Number',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: 'Registration Number',
                  icon: null,
                  controller: controller.registrationNumberController,
                  fieldName: "RegistrationNumber",
                  error: controller.error,
                ),
                const SizedBox(height: 10),
                const CustomLabel(
                  text: 'Make',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: 'Make',
                  icon: null,
                  controller: controller.brandController,
                  fieldName: "Brand",
                  error: controller.error,
                ),
                const SizedBox(height: 10),
                const CustomLabel(
                  text: 'Model',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: 'Model',
                  icon: null,
                  controller: controller.modelController,
                  fieldName: "Model",
                  error: controller.error,
                ),
                if (controller.isUpdateMode.value) ...[
                  const SizedBox(height: 10),
                  const CustomLabel(
                    text: 'Vehicle Type',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 5),
                  ModernDropdown(
                    selectedItem: controller.selectedVehicleType.value,
                    items: controller.vehicleTypeOptions,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        controller.selectedVehicleType.value = newValue;
                      }
                    },
                    // hintText: 'Select Vehicle Type',
                    prefixIcon: null,
                    width: double.infinity,
                    fieldName: "VehicleType",
                    error: controller.error,
                  ),
                  const SizedBox(height: 10),
                  const CustomLabel(
                    text: 'Year Manufacture',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 5),
                  CustomYearPicker(
                    controller: controller.yearOfManufactureController,
                    hintText: 'Year of Manufacture',
                    fieldName: "Year",
                    error: controller.error,
                  ),
                  const SizedBox(height: 10),
                  const CustomLabel(
                    text: 'Chasis Number',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    hintText: 'Chassis Number',
                    icon: null,
                    controller: controller.chasisNumberController,
                    fieldName: "ChassisNumber",
                    error: controller.error,
                  ),
                  const SizedBox(height: 10),
                  const CustomLabel(
                    text: 'Engine Number',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    hintText: 'Engine Number',
                    icon: null,
                    controller: controller.engineNumberController,
                    fieldName: "EngineNumber",
                    error: controller.error,
                  ),
                  const SizedBox(height: 10),
                  const CustomLabel(
                    text: 'Insurance Number',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    hintText: 'Insurance Number',
                    icon: null,
                    controller: controller.insuranceNumberController,
                    fieldName: "InsuranceNumber",
                    error: controller.error,
                  ),
                  const SizedBox(height: 10),
                  const CustomLabel(
                    text: 'Last Inspection Date',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 5),
                  CustomDatePicker(
                    hintText: 'Last Inspection Date',
                    controller: controller.lastInspectionDateLocalController,
                    fieldName: "LastInspection",
                    error: controller.error,
                  ),
                  const SizedBox(height: 10),
                  const CustomLabel(
                    text: 'Odometer Reading',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    hintText: 'Odometer Reading',
                    icon: null,
                    controller: controller.odometerReadingController,
                    keyboardType: TextInputType.number,
                    fieldName: "Odometer",
                    error: controller.error,
                  ),
                  const SizedBox(height: 10),
                  const CustomLabel(
                    text: 'Fuel Type',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 5),
                  ModernDropdown(
                    selectedItem: controller.selectedGas.value,
                    items: controller.gasOptions,
                    onChanged: (newValue) {
                      if (newValue != null && newValue.isNotEmpty) {
                        controller.selectedGas.value = newValue;
                      }

                      if (newValue == null || newValue.isEmpty) {
                        controller.selectedGas.value = '';
                      }
                    },
                    prefixIcon: null,
                    width: double.infinity,
                    fieldName: "FuelType",
                    error: controller.error,
                  ),
                  const SizedBox(height: 10),
                  const CustomLabel(
                    text: 'Owner Name',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    hintText: 'Owner Name',
                    icon: null,
                    controller: controller.ownerNameController,
                    fieldName: "OwnerName",
                    error: controller.error,
                  ),
                  const SizedBox(height: 10),
                  const CustomLabel(
                    text: 'Owner Address',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    hintText: 'Owner Address',
                    icon: null,
                    controller: controller.ownerAddressController,
                    fieldName: "OwnerAddress",
                    error: controller.error,
                  ),
                  const SizedBox(height: 10),
                  const CustomLabel(
                    text: 'Usage Status',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 5),
                  ModernDropdown(
                    selectedItem: controller.selectedUsageStatus.value,
                    items: controller.usageStatusOptions,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        controller.selectedUsageStatus.value = newValue;
                      }

                      if (newValue == null || newValue.isEmpty) {
                        controller.selectedUsageStatus.value = '';
                      }
                    },
                    prefixIcon: null,
                    width: double.infinity,
                    fieldName: "UsageStatus",
                    error: controller.error,
                  ),
                  const SizedBox(height: 10),
                  const CustomLabel(
                    text: 'Ownership Status',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 5),
                  ModernDropdown(
                    selectedItem: controller.selectedOwnershipStatus.value,
                    items: controller.ownershipStatusOptions,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        controller.selectedOwnershipStatus.value = newValue;
                      }
                      if (newValue == null || newValue.isEmpty) {
                        controller.selectedOwnershipStatus.value = '';
                      }
                    },
                    // hintText: 'Select Fuel Type',
                    prefixIcon: null,
                    width: double.infinity,
                    fieldName: "OwnershipStatus",
                    error: controller.error,
                  ),
                  const SizedBox(height: 10),
                  const CustomLabel(
                    text: 'Transmission Type',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 5),
                  ModernDropdown(
                    selectedItem: controller.selectedTransmission.value,
                    items: controller.transmissionOptions,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        controller.selectedTransmission.value = newValue;
                      }

                      if (newValue == null || newValue.isEmpty) {
                        controller.selectedTransmission.value = '';
                      }
                    },
                    prefixIcon: null,
                    width: double.infinity,
                    fieldName: "TransmissionType",
                    error: controller.error,
                  ),
                ],
                const SizedBox(height: 20),
                Obx(() => CustomElevatedButton(
                      text:
                          controller.isUpdateMode.value ? 'Update' : 'Register',
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.register,
                      isLoading: controller.isLoading.value,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
