import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai/app/common/widgets/custom_label_001.dart';
import 'package:santai/app/common/widgets/custom_pswd_field.dart';
import 'package:santai/app/common/widgets/custom_text_field.dart';
import 'package:santai/app/routes/app_pages.dart';

import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({Key? key}) : super(key: key);
  
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
                const SizedBox(height: 50), // Spacer to center content
                const Icon(Icons.image, size: 100),
                const SizedBox(height: 20),
                const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Login to your account',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 20),
                const CustomLabel(
                  text: 'Phone',
                ),
                CustomTextField(
                  hintText: '+62',
                  icon: Icons.phone,
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                const CustomLabel(
                  text: 'Email',
                ),
                CustomTextField(
                  hintText: 'Email',
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
                const SizedBox(height: 20),
                Obx(() => Row(
                  children: [
                    Checkbox(
                      value: controller.isAgreed.value,
                      onChanged: (value) {
                        controller.isAgreed.value = value ?? false;
                        print("Value: $value");
                      },
                      checkColor: Colors.white, 
                      activeColor: Colors.black,
                    ),
                    Expanded(
                      child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 14, 
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(text: "I agree to the ", style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: "Terms & Conditions"),
                              TextSpan(text: " and ", style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: "Privacy Policy"),
                            ],
                          ),
                        ),
                    ),
                  ],
                )),

                const SizedBox(height: 10),
                CustomElevatedButton(
                  text: 'Create Account',
                  onPressed: controller.isAgreed.value ? controller.signUp : null,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.black,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Or",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.circle),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.circle),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.circle),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "You Have an Account?",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed(Routes.LOGIN);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black, // Maintain text color
                        ),
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(text: "Sign In "),
                              TextSpan(text: "with mobile phone", style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20), // Add some space at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}
