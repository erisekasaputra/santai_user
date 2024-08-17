import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai/app/common/widgets/custom_label_001.dart';
import 'package:santai/app/common/widgets/custom_text_field.dart';
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Registration Motorcycle',
                    style: TextStyle(
                      fontSize: 30, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const CustomLabel(text: 'Driver / Owner (Unverified)'),
                CustomTextField(
                  hintText: '5fsg6785cTggKL',
                  icon: Icons.person,
                  controller: controller.driverOwnerController,
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'License Plate Number'),
                CustomTextField(
                  hintText: 'Plate Number',
                  icon: Icons.directions_car,
                  controller: controller.licensePlateController,
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Photo Motorcycle'),
                Obx(() => GestureDetector(
                  onTap: controller.showImageSourceDialog,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: controller.selectedImage.value != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              controller.selectedImage.value!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt, size: 40),
                                Text('Upload here'),
                              ],
                            ),
                          ),
                  ),
                )),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Make'),
                CustomTextField(
                  hintText: 'Make',
                  icon: Icons.motorcycle_rounded,
                  controller: controller.makeController,
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Model'),
                CustomTextField(
                  hintText: 'Model',
                  icon: Icons.motorcycle_rounded, // Changed icon for Model
                  controller: controller.modelController,
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Year'),
                GestureDetector(
                  onTap: () async {
                    final int currentYear = DateTime.now().year;
                    final int? selectedYear = await showDialog<int>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            'Select Year',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          content: SizedBox(
                            width: double.maxFinite,
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: currentYear - 1900 + 1,
                              itemBuilder: (BuildContext context, int index) {
                                final int year = currentYear - index;
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                  color: Colors.grey[100],
                                  child: InkWell(
                                    onTap: () => Navigator.of(context).pop(year),
                                    child: Center(
                                      child: Text(
                                        year.toString(),
                                        style: const TextStyle(
                                          color: Colors.black, 
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                    if (selectedYear != null) {
                      controller.yearController.text = selectedYear.toString();
                    }
                  },
                  child: AbsorbPointer(
                    child: CustomTextField(
                      hintText: 'Year',
                      icon: Icons.calendar_today,
                      controller: controller.yearController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Fuel Type'),
                Obx(() => Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: DropdownButtonFormField<String>(
                    borderRadius: BorderRadius.circular(20),
                    dropdownColor: Colors.white,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.local_gas_station),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    value: controller.selectedGas.value,
                    items: controller.gasOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      controller.selectedGas.value = newValue!;
                    },
                  ),
                )),
                const SizedBox(height: 20),
                CustomElevatedButton(
                  text: 'Registration',
                  onPressed: controller.register,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}