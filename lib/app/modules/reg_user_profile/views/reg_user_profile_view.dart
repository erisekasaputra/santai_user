import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai/app/common/widgets/custom_label_001.dart';
import 'package:santai/app/common/widgets/custom_text_field.dart';
import '../controllers/reg_user_profile_controller.dart';

class RegUserProfileView extends GetView<RegUserProfileController> {
  const RegUserProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Registration',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Your account',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 20),
                const CustomLabel(text: 'Reference Code'),
                CustomTextField(
                  hintText: 'Reference Code',
                  icon: Icons.code,
                  controller: controller.referenceCodeController,
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'First Name'),
                CustomTextField(
                  hintText: 'First Name',
                  icon: Icons.person,
                  controller: TextEditingController(),
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Middle Name'),
                CustomTextField(
                  hintText: 'Middle Name',
                  icon: Icons.person,
                  controller: TextEditingController(),
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Last Name'),
                CustomTextField(
                  hintText: 'Last Name',
                  icon: Icons.person,
                  controller: TextEditingController(),
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Phone'),
                CustomTextField(
                  hintText: '[+6] 018 222 0060',
                  icon: Icons.phone,
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Email'),
                CustomTextField(
                  hintText: 'Email',
                  icon: Icons.email,
                  controller: TextEditingController(), 
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomLabel(text: 'Date of Birth'),
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
                                controller.dateOfBirthController.text = formattedDate;
                              }
                            },
                            child: AbsorbPointer(
                              child: CustomTextField(
                                hintText: 'Date of Birth',
                                icon: Icons.calendar_today,
                                controller: controller.dateOfBirthController,
                                keyboardType: TextInputType.datetime,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomLabel(text: 'Gender'),
                          Obx(() => DropdownButtonFormField<String>(
                            borderRadius: BorderRadius.circular(20),
                            dropdownColor: Colors.white,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            value: controller.selectedGender.value,
                            items: controller.genderOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              controller.selectedGender.value = newValue!;
                            },
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Address'),
                CustomTextField(
                  hintText: 'Address',
                  icon: Icons.location_on,
                  controller: controller.addressController,
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Postal Code'),
                CustomTextField(
                  hintText: 'Postal Code',
                  icon: Icons.pin_drop,
                  controller: controller.posCodeController,
                  keyboardType: TextInputType.number,
                ),
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