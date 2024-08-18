import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_snackbar.dart';
import 'package:santai/app/domain/usecases/login_use_case.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  final isLoading = false.obs;

  final LoginUseCase loginUseCase;
  final passwordController = TextEditingController();
  final isPasswordHidden = true.obs;

  final phoneController = TextEditingController();
  final countryCode = ''.obs;
  final phoneNumber = ''.obs;

  final businessCodeController = TextEditingController();
  final isStaffLogin = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  LoginController(this.loginUseCase);

   void updatePhoneInfo(String code, String number) {
    countryCode.value = code;
    phoneNumber.value = number;
  }

  void login() async {
    isLoading.value = true;
    final password = passwordController.text;

    String fullPhoneNumber = '${countryCode.value}${phoneNumber.value}';

    print('Phone: $fullPhoneNumber, Password: $password');


    await Future.delayed(Duration(seconds: 2));

    ModernSnackbar.show(
      message: "Login successful",
      type: SnackbarType.success,
    );

    isLoading.value = false;
    Get.toNamed(Routes.REGISTER_OTP);

    // final user = await loginUseCase.execute(phone, password);
    // print('Logged in user: ${user.email}');
  }

  void toggleStaffLogin() {
    isStaffLogin.toggle();
  }

  void signInAsStaff() async {
    isLoading.value = true;

    final phone = '${countryCode.value}${phoneNumber.value}';
    final password = passwordController.text;
    final businessCode = businessCodeController.text;

    if (phone.isEmpty || password.isEmpty || businessCode.isEmpty) {
      ModernSnackbar.show(
        message: "Please fill in all fields",
        type: SnackbarType.warning,
      );
      isLoading.value = false;
      return;
    }

    await Future.delayed(Duration(seconds: 2));

    print('Staff Login - Phone: $phone, Password: $password, Business Code: $businessCode');
    
    isLoading.value = false;
    Get.toNamed(Routes.REGISTER_OTP);
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