import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                const CustomLabel(text: 'Driver / Owner (Unverified)'),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: '5fsg6785cTggKL',
                  icon: Icons.person,
                  controller: controller.driverOwnerController,
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'License Plate Number'),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: 'Plate Number',
                  icon: Icons.directions_car,
                  controller: controller.licensePlateController,
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Photo Motorcycle'),
                const SizedBox(height: 5),
                Obx(() => CustomImageUploader(
                  selectedImage: controller.selectedImage.value,
                  onImageSourceSelected: controller.handleImageSourceSelection,
                )),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Make'),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: 'Make',
                  icon: Icons.motorcycle_rounded,
                  controller: controller.makeController,
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Model'),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: 'Model',
                  icon: Icons.motorcycle_rounded, // Changed icon for Model
                  controller: controller.modelController,
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Year'),
                const SizedBox(height: 5),
                CustomYearPicker(
                  controller: controller.yearController,
                  hintText: 'Year',
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
                  hintText: 'Select Fuel Type',
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