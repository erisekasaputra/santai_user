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
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primary300 = Theme.of(context).colorScheme.primary_300;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: constraints.maxHeight * 0.17,
                            child: Image.asset(
                              'assets/images/logo_hd_santaimoto_blue.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Welcome Back',
                            style: TextStyle(
                              color: Colors.grey.shade900,
                              fontSize: constraints.maxHeight * 0.045,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Login to your account',
                            style: TextStyle(
                              color: Colors.grey.shade900,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () => Column(
                              children: [
                                if (controller.isStaffLogin.value) ...[
                                  const CustomLabel(
                                    text: 'Business Code',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  const SizedBox(height: 5),
                                  CustomTextField(
                                    controller:
                                        controller.businessCodeController,
                                    hintText: 'Enter Business Code',
                                    icon: Icons.business_outlined,
                                    fieldName: "BusinessCode",
                                    error: controller.error,
                                  ),
                                  const SizedBox(height: 20),
                                ],
                                const CustomLabel(
                                  text: 'Phone',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                const SizedBox(height: 5),
                                CustomPhoneField(
                                  hintText: 'Enter Phone Number',
                                  controller: controller.phoneController,
                                  onChanged: controller.updatePhoneInfo,
                                  error: controller.error,
                                ),
                                const CustomLabel(
                                  text: 'Password',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                const SizedBox(height: 5),
                                CustomPasswordField(
                                  controller: controller.passwordController,
                                  isPasswordHidden: controller.isPasswordHidden,
                                  fieldName: "Password",
                                  error: controller.error,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Get.toNamed(Routes.FORGOT_PASSWORD);
                                  },
                                  child: const Text(
                                    'Forgot password?',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Obx(() => CustomElevatedButton(
                                    text: 'Log In',
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : (controller.isStaffLogin.value
                                            ? controller.signInAsStaff
                                            : controller.login),
                                    isLoading: controller.isLoading.value,
                                    height: 48,
                                  )),
                              const SizedBox(height: 20),
                              Obx(
                                () => controller.isStaffLogin.value
                                    ? const SizedBox.shrink()
                                    : const Row(
                                        children: [
                                          Expanded(
                                            child: Divider(
                                              color: Colors.grey, // Line color
                                              thickness: 1, // Line thickness
                                              indent:
                                                  3, // Left space before line
                                              endIndent:
                                                  15, // Right space after line
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              'Or',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Divider(
                                              color: Colors.grey,
                                              thickness: 1,
                                              indent: 15,
                                              endIndent: 3,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              // Obx(
                              //   () => controller.isStaffLogin.value
                              //       ? const SizedBox.shrink()
                              //       : const SizedBox(height: 20),
                              // ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     Card(
                              //       color: Colors.white,
                              //       shape: RoundedRectangleBorder(
                              //         side: BorderSide(
                              //             color: borderColor, width: 1),
                              //         borderRadius: BorderRadius.circular(8),
                              //       ),
                              //       child: Obx(
                              //         () => !controller.isStaffLogin.value
                              //             ? IconButton(
                              //                 icon: const Icon(
                              //                     Icons.business_outlined,
                              //                     size: 30,
                              //                     color: Color(0xFF1E3A8A)),
                              //                 onPressed:
                              //                     controller.toggleStaffLogin,
                              //               )
                              //             : const SizedBox.shrink(),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                          Obx(
                            () => controller.isStaffLogin.value
                                ? const SizedBox.shrink()
                                : const SizedBox(height: 20),
                          ),
                          Obx(
                            () {
                              return controller.isStaffLogin.value
                                  ? const SizedBox.shrink()
                                  : FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Dont have an Account ",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Saira',
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.toNamed(Routes.SIGN_UP);
                                            },
                                            child: const Text(
                                              "Sign Up",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Saira',
                                                fontWeight: FontWeight.w500,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Text(
                                            "with mobile phone",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Saira',
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Sticky icon on top-right corner
              Obx(
                () => Positioned(
                  top: 10, // Posisi vertikal dari atas
                  right: 10, // Posisi horizontal dari kanan
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Button untuk 'Personal' - urutan dimulai dari kanan
                      TextButton(
                        onPressed: () {
                          controller.toggleStaffLogin(value: false);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: !controller.isStaffLogin.value
                              ? primary300 // Warna latar belakang saat dipilih
                              : Colors
                                  .transparent, // Tidak ada latar belakang saat tidak dipilih
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12), // Border radius yang lebih kecil
                          ),
                        ),
                        child: Text(
                          'Personal',
                          style: TextStyle(
                            fontSize: 16,
                            color: !controller.isStaffLogin.value
                                ? Colors.white
                                : primary300,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      // Pipeline (garis pemisah) menggunakan karakter '|'
                      Text(
                        ' | ',
                        style: TextStyle(
                          fontSize: 16,
                          color: primary300,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // Button untuk 'Business'
                      TextButton(
                        onPressed: () {
                          controller.toggleStaffLogin(value: true);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: controller.isStaffLogin.value
                              ? primary300 // Warna latar belakang saat dipilih
                              : Colors
                                  .transparent, // Tidak ada latar belakang saat tidak dipilih

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12), // Border radius yang lebih kecil
                          ),
                        ),
                        child: Text(
                          'Business',
                          style: TextStyle(
                            fontSize: 16,
                            color: controller.isStaffLogin.value
                                ? Colors.white
                                : primary300,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
