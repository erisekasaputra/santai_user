import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_date_picker.dart';
import 'package:santai/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai/app/common/widgets/custom_image_uploader.dart';
import 'package:santai/app/common/widgets/custom_label_001.dart';
import 'package:santai/app/common/widgets/custom_modern_dropdown.dart';
import 'package:santai/app/common/widgets/custom_text_field.dart';
import 'package:santai/app/common/widgets/custom_year_picker.dart';
import '../controllers/reg_motorcycle_controller.dart';

class RegMotorcycleView extends GetView<RegMotorcycleController> {
  const RegMotorcycleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Registration',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Motorcycle',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                const SizedBox(height: 20),
                const CustomLabel(text: 'Photo Motorcycle'),
                const SizedBox(height: 5),
                Obx(() => CustomImageUploader(
                  selectedImage: controller.selectedImage.value,
                  onImageSourceSelected: controller.handleImageSourceSelection,
                )),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Registration Number'),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: 'Registration Number',
                  icon: Icons.person,
                  controller: controller.registrationNumberController,
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Vehicle Type'),
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
                  prefixIcon: Icons.local_gas_station,
                  width: double.infinity,
                ),
                const CustomLabel(text: 'Brand'),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: '',
                  icon: Icons.directions_car,
                  controller: controller.brandController,
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Model'),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: '',
                  icon: Icons.directions_car,
                  controller: controller.modelController,
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Year Manufacture'),
                const SizedBox(height: 5),
                CustomYearPicker(
                  controller: controller.yearOfManufactureController,
                  hintText: '',
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Chasis Number'),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: '',
                  icon: Icons.motorcycle_rounded,
                  controller: controller.chasisNumberController,
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Engine Number'),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: '',
                  icon: Icons.motorcycle_rounded, // Changed icon for Model
                  controller: controller.engineNumberController,
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Insurance Number'),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: '',
                  icon: Icons.motorcycle_rounded, // Changed icon for Model
                  controller: controller.insuranceNumberController,
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Last Inspection Date'),
                const SizedBox(height: 5),
                CustomDatePicker(
                  hintText: 'Last Inspection Date',
                  controller: controller.lastInspectionDateLocalController,
                ),
                 const SizedBox(height: 10),
                const CustomLabel(text: 'Odometer Reading'),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: '',
                  icon: Icons.motorcycle_rounded, // Changed icon for Model
                  controller: controller.odometerReadingController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Fuel Type'),
                const SizedBox(height: 5),
                ModernDropdown(
                  selectedItem: controller.selectedGas.value,
                  items: controller.gasOptions,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      controller.selectedGas.value = newValue;
                    }
                  },
                  // hintText: 'Select Fuel Type',
                  prefixIcon: Icons.local_gas_station,
                  width: double.infinity,
                ),
                 const SizedBox(height: 10),
                const CustomLabel(text: 'Owner Name'),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: '',
                  icon: Icons.motorcycle_rounded, // Changed icon for Model
                  controller: controller.ownerNameController,
                ),
                 const SizedBox(height: 10),
                const CustomLabel(text: 'Owner Address'),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: '',
                  icon: Icons.motorcycle_rounded, // Changed icon for Model
                  controller: controller.ownerAddressController,
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Usage Status'),
                const SizedBox(height: 5),
                ModernDropdown(
                  selectedItem: controller.selectedUsageStatus.value,
                  items: controller.usageStatusOptions,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      controller.selectedUsageStatus.value = newValue;
                    }
                  },
                  // hintText: 'Select Fuel Type',
                  prefixIcon: Icons.local_gas_station,
                  width: double.infinity,
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Ownership Status'),
                const SizedBox(height: 5),
                ModernDropdown(
                  selectedItem: controller.selectedOwnershipStatus.value,
                  items: controller.ownershipStatusOptions,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      controller.selectedOwnershipStatus.value = newValue;
                    }
                  },
                  // hintText: 'Select Fuel Type',
                  prefixIcon: Icons.local_gas_station,
                  width: double.infinity,
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Transmission Type'),
                const SizedBox(height: 5),
                ModernDropdown(
                  selectedItem: controller.selectedTransmission.value,
                  items: controller.transmissionOptions,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      controller.selectedTransmission.value = newValue;
                    }
                  },
                  // hintText: 'Select Fuel Type',
                  prefixIcon: Icons.local_gas_station,
                  width: double.infinity,
                ),
                const SizedBox(height: 20),
                 Obx(() => CustomElevatedButton(
                  text: 'Registration',
                  onPressed: controller.isLoading.value ? null : controller.register,
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