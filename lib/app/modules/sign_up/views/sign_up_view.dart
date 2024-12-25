import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai/app/common/widgets/custom_label_001.dart';
import 'package:santai/app/common/widgets/custom_phone_field.dart';
import 'package:santai/app/common/widgets/custom_pswd_field.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
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
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.grey.shade900,
                                fontSize: constraints.maxHeight * 0.045,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Your account',
                              style: TextStyle(
                                color: Colors.grey.shade900,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const CustomLabel(
                              text: 'Phone Number',
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
                            const SizedBox(height: 10),
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
                            const SizedBox(height: 10),
                            Obx(
                              () => Row(
                                crossAxisAlignment: CrossAxisAlignment
                                    .center, // Pastikan sejajar vertikal
                                children: [
                                  Align(
                                    alignment: Alignment
                                        .topCenter, // Checkbox berada di posisi atas
                                    child: Checkbox(
                                      value: controller.isAgreed.value,
                                      onChanged: (value) {
                                        controller.isAgreed.value =
                                            value ?? false;
                                      },
                                      checkColor: Colors.white,
                                      activeColor: Colors.black,
                                    ),
                                  ),
                                  Expanded(
                                    child: RichText(
                                      textAlign:
                                          TextAlign.left, // Teks rata kiri
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Saira',
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: "I agree to the ",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Saira',
                                            ),
                                          ),
                                          TextSpan(
                                            text: "Terms & Conditions",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Saira',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary_100,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                showDialog(
                                                  context: Get.context!,
                                                  builder: (context) =>
                                                      _buildTermsAndCondition(
                                                          context),
                                                );
                                              },
                                          ),
                                          const TextSpan(
                                            text: " and ",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Saira',
                                            ),
                                          ),
                                          TextSpan(
                                            text: "Privacy Policy",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Saira',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary_100,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                showDialog(
                                                  context: Get.context!,
                                                  builder: (context) =>
                                                      _buildPrivacyPolicy(
                                                          context),
                                                );
                                              },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Obx(
                              () => CustomElevatedButton(
                                text: 'Sign Up',
                                onPressed: controller.isLoading.value
                                    ? null
                                    : (controller.isAgreed.value
                                        ? controller.signUp
                                        : null),
                                isLoading: controller.isLoading.value,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey, // Line color
                                    thickness: 1, // Line thickness
                                    indent: 3, // Left space before line
                                    endIndent: 15, // Right space after line
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
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
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Card(
                            //       color: Colors.white,
                            //       shape: RoundedRectangleBorder(
                            //         side: BorderSide(color: borderColor, width: 1),
                            //         borderRadius: BorderRadius.circular(8),
                            //       ),
                            //       child: IconButton(
                            //         icon: Image.asset('assets/images/google_logo.png',
                            //             width: 30, height: 30),
                            //         onPressed: controller.signInWithGoogle,
                            //       ),
                            //     ),
                            //     const SizedBox(width: 10),
                            //     Card(
                            //       color: Colors.white,
                            //       shape: RoundedRectangleBorder(
                            //         side: BorderSide(color: borderColor, width: 1),
                            //         borderRadius: BorderRadius.circular(8),
                            //       ),
                            //       child: IconButton(
                            //         icon: Image.asset('assets/images/facebook_logo.png', width: 30, height: 30),
                            //         onPressed: controller.signInWithGoogle,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            const SizedBox(height: 20),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Teks reguler awal
                                  const Text(
                                    "Already have an account ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                  // "Sign Up" dengan gaya bold dan warna biru
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(Routes
                                          .LOGIN); // Aksi saat "Sign Up" di klik
                                    },
                                    child: const Text(
                                      "Sign In",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight
                                            .w500, // Bold lebih tebal untuk penekanan
                                        color: Colors
                                            .blueAccent, // Garis bawah untuk gaya interaktif
                                      ),
                                    ),
                                  ),
                                  // Tambahan spasi kecil agar tidak terlalu dekat
                                  const SizedBox(width: 4),
                                  // Teks reguler akhir
                                  const Text(
                                    "with mobile phone",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPrivacyPolicy(BuildContext context) {
    return AlertDialog(
      title: const Text("Privacy Policy"),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 1, // 50% dari tinggi layar
        width: MediaQuery.of(context).size.width * 1, // 80% dari lebar layar
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: MarkdownBody(
              data: controller.privacyPolicy.value,
              onTapLink: (text, href, title) {
                if (href != null) {
                  launchUrl(Uri.parse(href));
                }
              },
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Close"),
        ),
      ],
    );
  }

  Widget _buildTermsAndCondition(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Terms & Conditions",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height, // 60% dari tinggi layar
        width: MediaQuery.of(context).size.width, // 90% dari lebar layar
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: MarkdownBody(
              data: controller.termsAndCondition.value,
              onTapLink: (text, href, title) {
                if (href != null) {
                  launchUrl(Uri.parse(href));
                }
              },
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "Close",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
