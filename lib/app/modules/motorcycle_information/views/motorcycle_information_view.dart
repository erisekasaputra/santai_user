import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_text_field.dart';
import 'package:santai/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai/app/common/widgets/custom_label_001.dart';
import '../controllers/motorcycle_information_controller.dart';

class MotorcycleInformationView extends GetView<MotorcycleInformationController> {
  const MotorcycleInformationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Information',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomLabel(text: 'Verify Ownership'),
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
              const CustomLabel(text: 'Verify Ownership'),
              
              CustomTextField(
                hintText: '5fsg6785cTggKL',
                icon: Icons.verified_user,
                controller: controller.verifyOwnershipController,
              ),
              const SizedBox(height: 10),
              const CustomLabel(text: 'Chassis Number'),
              
              CustomTextField(
                hintText: '5fsg6785cTggKL',
                icon: Icons.confirmation_number,
                controller: controller.chassisNumberController,
              ),
              const SizedBox(height: 10),
              const CustomLabel(text: 'Engine Number'),
              
              CustomTextField(
                hintText: 'Placeholder',
                icon: Icons.engineering,
                controller: controller.engineNumberController,
              ),
              const SizedBox(height: 10),
              const CustomLabel(text: 'Insurance No'),
              
              CustomTextField(
                hintText: 'Placeholder',
                icon: Icons.security,
                controller: controller.insuranceNoController,
              ),
              const SizedBox(height: 10),
              const CustomLabel(text: 'Insurance Company'),
              
              CustomTextField(
                hintText: 'Insurance Company',
                icon: Icons.business,
                controller: controller.insuranceCompanyController,
              ),
              const SizedBox(height: 10),
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomLabel(text: 'Road Tax Expire Date'),
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(const Duration(days: 5 * 365)),
                      lastDate: DateTime.now().add(const Duration(days: 10 * 365)),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            primaryColor: Colors.grey,
                            hintColor: Colors.grey, 
                            colorScheme: ColorScheme.light(primary: Colors.grey),
                            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                          ),
                          child: child ?? Container(),
                        );
                      },
                    );
                    if (pickedDate != null) {
                      String formattedDate = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                      controller.roadTaxExpireDateController.text = formattedDate;
                    }
                  },
                  child: AbsorbPointer(
                    child: CustomTextField(
                      hintText: 'Road Tax Expire Date',
                      icon: Icons.calendar_today,
                      controller: controller.roadTaxExpireDateController,
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                ),
              ],
            ),
              const SizedBox(height: 10),
              const CustomLabel(text: 'Odometer'),
              
              CustomTextField(
                hintText: 'Odometer',
                icon: Icons.speed,
                controller: controller.odometerController,
              ),
              const SizedBox(height: 10),
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomLabel(text: 'Purchased Date'),
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            primaryColor: Colors.grey,
                            hintColor: Colors.grey, 
                            colorScheme: ColorScheme.light(primary: Colors.grey),
                            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                          ),
                          child: child ?? Container(),
                        );
                      },
                    );
                    if (pickedDate != null) {
                      String formattedDate = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                      controller.purchasedDateController.text = formattedDate;
                    }
                  },
                  child: AbsorbPointer(
                    child: CustomTextField(
                      hintText: 'Purchased Date',
                      icon: Icons.calendar_today,
                      controller: controller.purchasedDateController,
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                ),
              ],
            ),
              const SizedBox(height: 32),
              CustomElevatedButton(
                text: 'Save',
                onPressed: controller.saveInformation,
              ),
            ],
          ),
        ),
      ),
    );
  }


}