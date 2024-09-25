import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai/app/common/widgets/custom_label_001.dart';
import 'package:santai/app/common/widgets/custom_phone_field.dart';
import 'package:santai/app/common/widgets/custom_pswd_field.dart';
import 'package:santai/app/common/widgets/custom_text_field.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/theme/app_theme.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primary_100 = Theme.of(context).colorScheme.primary_100;
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: constraints.maxHeight * 0.2,
                          child: Image.asset(
                            'assets/images/company_logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              'Welcome Back',
                              style: TextStyle(fontSize: constraints.maxHeight * 0.04, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.01),
                            Text(
                              'Login to your account',
                              style: TextStyle(fontSize: constraints.maxHeight * 0.02, color: Colors.black),
                            ),
                          ],
                        ),
                        Obx(() => Column(
                          children: [
                            if (controller.isStaffLogin.value) ...[
                              const CustomLabel(text: 'Business Code'),
                              CustomTextField(
                                controller: controller.businessCodeController,
                                hintText: 'Enter business code',
                                icon: Icons.business_center,
                              ),
                              SizedBox(height: 10),
                            ],
                            const CustomLabel(text: 'Phone'),
                            CustomPhoneField(
                              hintText: 'Enter your phone number',
                              controller: controller.phoneController,
                              onChanged: controller.updatePhoneInfo,
                            ),
                            SizedBox(height: 10),
                            const CustomLabel(text: 'Password'),
                            CustomPasswordField(
                              controller: controller.passwordController,
                              isPasswordHidden: controller.isPasswordHidden,
                            ),
                          ],
                        )),
                        Column(
                          children: [
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
                            SizedBox(height: 10),
                            Obx(() => CustomElevatedButton(
                              text: controller.isStaffLogin.value
                                  ? 'Staff Log In'
                                  : 'Log In',
                              onPressed: controller.isLoading.value
                                  ? null
                                  : (controller.isStaffLogin.value
                                      ? controller.signInAsStaff
                                      : controller.login),
                              isLoading: controller.isLoading.value,
                            )),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: borderColor, width: 1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    icon: Image.asset('assets/images/google_logo.png',
                                        width: 30, height: 30),
                                    onPressed: controller.signInWithGoogle,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: borderColor, width: 1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.business_center,
                                        size: 30, color: Colors.black),
                                    onPressed: controller.toggleStaffLogin,
                                  ),
                                ),
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
                                style: TextStyle(fontSize: 16),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.toNamed(Routes.SIGN_UP);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.black,
                                ),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: primary_100
                                  ),
                                ),
                              ),
                              const Text(
                                "with mobile phone",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}