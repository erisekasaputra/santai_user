import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai/app/common/widgets/custom_label_001.dart';
import 'package:santai/app/common/widgets/custom_phone_field.dart';
import 'package:santai/app/common/widgets/custom_pswd_field.dart';
import 'package:santai/app/common/widgets/custom_text_field.dart';
import 'package:santai/app/routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

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
                const SizedBox(height: 50), // Spacer to center content
                const Icon(Icons.image, size: 100),
                const SizedBox(height: 20),
                const Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Login to your account',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 20),


                // const CustomLabel(
                //   text: 'Phone',
                // ),
                // CustomPhoneField(
                //   hintText: 'Enter your phone number',
                //   controller: controller.phoneController,
                //   onChanged: controller.updatePhoneInfo,
                // ),
                // const SizedBox(height: 10),
                // const CustomLabel(
                //   text: 'Password',
                // ),
                // CustomPasswordField(
                //   controller: controller.passwordController,
                //   isPasswordHidden: controller.isPasswordHidden,
                // ),

                Obx(() => Column(
                  children: [
                    if (controller.isStaffLogin.value) ...[
                      const SizedBox(height: 10),
                      const CustomLabel(text: 'Business Code'),
                      CustomTextField(
                        controller: controller.businessCodeController,
                        hintText: 'Enter business code',
                        icon: Icons.business_center,
                      ),
                    ],
                    const SizedBox(height: 10),
                    const CustomLabel(text: 'Phone'),
                    CustomPhoneField(
                      hintText: 'Enter your phone number',
                      controller: controller.phoneController,
                      onChanged: controller.updatePhoneInfo,
                    ),
                    const CustomLabel(text: 'Password'),
                    CustomPasswordField(
                      controller: controller.passwordController,
                      isPasswordHidden: controller.isPasswordHidden,
                    ),
                    
                  ],
                )),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Obx(() => CustomElevatedButton(
                //   text: controller.isStaffLogin.value ? 'Staff Log In' : 'Log In',
                //   onPressed: controller.isStaffLogin.value ? controller.signInAsStaff : controller.login,
                // )),
                Obx(() => CustomElevatedButton(
                  text: controller.isStaffLogin.value ? 'Staff Log In' : 'Log In',
                  onPressed: controller.isLoading.value
                    ? null
                    : (controller.isStaffLogin.value ? controller.signInAsStaff : controller.login),
                  child: controller.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                          strokeWidth: 2,
                        ),
                      )
                    : null,
                )),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: Image.asset('assets/images/google_logo.png', width: 50, height: 50),
                          onPressed: controller.signInWithGoogle,
                        ),
                        const Text('Sign in with Google'),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.business_center, size: 50, color: Colors.black),
                          onPressed: controller.toggleStaffLogin,
                        ),
                        Obx(() => Text(controller.isStaffLogin.value ? 'Switch to User' : 'Sign in as Staff')),
                      ],
                    ),
                  ],
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed(Routes.SIGN_UP);
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
                              TextSpan(text: "Sign Up "),
                              TextSpan(text: "with mobile phone", style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}