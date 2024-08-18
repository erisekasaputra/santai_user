import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:santai/app/routes/app_pages.dart';

class SignUpController extends GetxController {
  final TextEditingController passwordController = TextEditingController();
  final isPasswordHidden = true.obs;


  final phoneController = TextEditingController();
  final countryCode = ''.obs;
  final phoneNumber = ''.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  final isAgreed = false.obs;

   void updatePhoneInfo(String code, String number) {
    countryCode.value = code;
    phoneNumber.value = number;
  }

  void signUp() {
    String password = passwordController.text;

    String fullPhoneNumber = '${countryCode.value}${phoneNumber.value}';
    print('Phone: $fullPhoneNumber, Password: $password');

    Get.toNamed(Routes.REG_USER_PROFILE);
  }

   Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      print('idToken: $idToken');
      print('accessToken: $accessToken');

      Get.snackbar('Success', 'idToken: $idToken Access Token: $accessToken');

      bool success = await sendTokenToServer(idToken);
      
      if (success) {
  
        Get.offAllNamed(Routes.HOME);
      } else {
    
        Get.snackbar('Error', 'Failed to authenticate with server');
      }
    } catch (error) {
      print(error);
      Get.snackbar('Error', 'Sign in with Google failed');
    }
  }

  Future<bool> sendTokenToServer(String? token) async {
  
    return true; // Placeholder
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}