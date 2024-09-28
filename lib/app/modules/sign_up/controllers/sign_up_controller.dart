import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_user_register.dart';
import 'package:santai/app/domain/usecases/authentikasi/register_user.dart';
// import 'package:santai/app/common/widgets/custom_snackbar.dart';
import 'package:santai/app/routes/app_pages.dart';

class SignUpController extends GetxController {
  final isLoading = false.obs;
  final isAgreed = false.obs;

  final TextEditingController passwordController = TextEditingController();
  final isPasswordHidden = true.obs;

  final phoneController = TextEditingController();
  final countryISOCode = ''.obs;
  final countryCode = ''.obs;
  final phoneNumber = ''.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  final RegisterUser registerUser;
  SignUpController({required this.registerUser});

  void updatePhoneInfo(String isoCode, String code, String number) {
    countryISOCode.value = isoCode;
    countryCode.value = code;
    phoneNumber.value = number;
  }


  Future<void> signUp() async {
    isLoading.value = true;

    String password = passwordController.text;
    String selectedCountryISOCode = countryISOCode.value;
    String fullPhoneNumber = '${countryCode.value}${phoneNumber.value}';

    try {
      final dataUserRegister = UserRegister(
        phoneNumber: fullPhoneNumber,
        password: password,
        regionCode: selectedCountryISOCode,
        userType: 'RegularUser',
      );

      final response = await registerUser(dataUserRegister);

      // print("responseHUUUU: ${response.next.otpRequestToken}");

      CustomToast.show(
        message: "Successfully registered!",
        type: ToastType.success,
      );

      Get.offAllNamed(Routes.REGISTER_OTP, arguments: {
        'source': 'signup',
        'otpRequestToken': response.next.otpRequestToken,
        'otpRequestId': response.next.otpRequestId,
      });
    } catch (error) {
      CustomToast.show(
        message: "Registration failed: ${error.toString()}",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      print('idToken: $idToken');
      print('accessToken: $accessToken');

      CustomToast.show(
        message: 'idToken: $idToken Access Token: $accessToken',
        type: ToastType.success,
      );

      bool success = await sendTokenToServer(idToken);

      if (success) {
        Get.offAllNamed(Routes.REGISTER_OTP);
      } else {
        CustomToast.show(
          message: "Failed to authenticate with server",
          type: ToastType.error,
        );
      }
    } catch (error) {
      print(error);
      CustomToast.show(
        message: "Sign in with Google failed",
        type: ToastType.error,
      );
    }
  }

  Future<bool> sendTokenToServer(String? token) async {
    return true;
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
