import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai/app/common/widgets/custom_label_001.dart';
import 'package:santai/app/common/widgets/custom_pswd_field.dart';
import 'package:santai/app/common/widgets/custom_text_field.dart';
// import 'package:santai/app/routes/app_pages.dart';

import '../controllers/reg_user_profile_controller.dart';

class RegUserProfileView extends GetView<RegUserProfileController> {
  const RegUserProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const CustomLabel(
                  text: 'Reference Code',
                ),
                CustomTextField(
                  hintText: 'Reference Code',
                  icon: Icons.phone,
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                const CustomLabel(
                  text: 'Full Name',
                ),
                CustomTextField(
                  hintText: 'Full Name',
                  icon: Icons.email,
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                const CustomLabel(
                  text: 'Password',
                ),
                 CustomPasswordField(
                  controller: controller.passwordController,
                  isPasswordHidden: controller.isPasswordHidden,
                ),
                const SizedBox(height: 10),
                const CustomLabel(
                  text: 'Confirm Password',
                ),
                 CustomPasswordField(
                  controller: controller.passwordController,
                  isPasswordHidden: controller.isPasswordHidden,
                ),
                const SizedBox(height: 10),
                const CustomLabel(
                  text: 'Phone',
                ),
                CustomTextField(
                  hintText: 'Phone',
                  icon: Icons.phone,
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
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
                          CustomTextField(
                            hintText: 'Date of Birth',
                            icon: Icons.calendar_today,
                            controller: controller.phoneController,
                            keyboardType: TextInputType.datetime,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16), // Spacer between fields
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomLabel(text: 'Gender'),
                          CustomTextField(
                            hintText: 'Gender',
                            icon: Icons.person,
                            controller: controller.phoneController,
                            keyboardType: TextInputType.text,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const CustomLabel(
                  text: 'Address',
                ),
                CustomTextField(
                  hintText: 'Address',
                  icon: Icons.location_on,
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomLabel(text: 'Pos Code'),
                          CustomTextField(
                            hintText: 'Pos Code',
                            icon: Icons.pin_drop, // Using pin_drop icon for post code
                            controller: controller.phoneController,
                            keyboardType: TextInputType.number, // Changed to number for post code
                          ),
                        ],
                      ),
                    ),
                  ],
                ),



                const SizedBox(height: 20),
                CustomElevatedButton(
                  text: 'Registration',
                  onPressed: controller.isAgreed.value ? controller.signUp : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
