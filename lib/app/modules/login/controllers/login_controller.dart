import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';

import 'package:santai/app/domain/entities/authentikasi/auth_signin_staff.dart';
import 'package:santai/app/domain/usecases/authentikasi/sign-in_staff.dart';

import 'package:santai/app/domain/entities/authentikasi/auth_signin_user.dart';
import 'package:santai/app/domain/usecases/authentikasi/sign-in_user.dart';

import 'package:santai/app/domain/usecases/authentikasi/sign-in_google.dart'
    as GoogleSignInUsecase;
import 'package:santai/app/domain/entities/authentikasi/auth_signin_google.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';

import 'package:santai/app/routes/app_pages.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  final isLoading = false.obs;

  final passwordController = TextEditingController();
  final isPasswordHidden = true.obs;

  final phoneController = TextEditingController();
  final countryISOCode = ''.obs;
  final countryCode = ''.obs;
  final phoneNumber = ''.obs;

  final businessCodeController = TextEditingController();
  final isStaffLogin = false.obs;

  final UserSignIn signinUser;
  final StaffSignIn signinStaff;
  final GoogleSignInUsecase.GoogleSignIn signinGoogle;

  LoginController(
      {required this.signinUser,
      required this.signinStaff,
      required this.signinGoogle});

  void updatePhoneInfo(String isoCode, String code, String number) {
    countryISOCode.value = isoCode;
    countryCode.value = code;
    phoneNumber.value = number;
  }

  void toggleStaffLogin() {
    isStaffLogin.toggle();
  }

  void login() async {
    isLoading.value = true;

    String fullPhoneNumber = '${countryCode.value}${phoneNumber.value}';

    try {
      final dataUserSignIn = SigninUser(
        phoneNumber: fullPhoneNumber,
        password: passwordController.text,
        regionCode: countryISOCode.value,
      );

      final response = await signinUser(dataUserSignIn);

      CustomToast.show(
        message: "Successfully login!",
        type: ToastType.success,
      );

      Get.offAllNamed(Routes.REGISTER_OTP, arguments: {
        'source': 'login',
        'otpRequestToken': response.next.otpRequestToken,
        'otpRequestId': response.next.otpRequestId,
      });
    } catch (error) {
      if (error is CustomHttpException) {
        CustomToast.show(
          message: error.message,
          type: ToastType.error,
        );
      } else {
        CustomToast.show(
          message: "An unexpected error occurred",
          type: ToastType.error,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void signInAsStaff() async {
    isLoading.value = true;

    String fullPhoneNumber = '${countryCode.value}${phoneNumber.value}';

    try {
      final dataSignInStaff = SigninStaff(
        phoneNumber: fullPhoneNumber,
        password: passwordController.text,
        regionCode: countryISOCode.value,
        businessCode: businessCodeController.text,
      );

      final response = await signinStaff(dataSignInStaff);
      
      CustomToast.show(
        message: "Successfully login!",
        type: ToastType.success,
      );

      Get.offAllNamed(Routes.REGISTER_OTP, arguments: {
        'source': 'login',
        'otpRequestToken': response.next.otpRequestToken,
        'otpRequestId': response.next.otpRequestId,
      });
    } catch (error) {
      CustomToast.show(
        message: "Login failed: ${error.toString()}",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
  try {
    isLoading.value = true;

    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
      serverClientId:
          '1065462126306-sla57ni7q7n8mhs2v0miqa6u5ms8lrsi.apps.googleusercontent.com',
    );

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      throw Exception('Google Sign-In was cancelled by the user');
    }

    print("Google Sign-In successful. Email: ${googleUser.email}");

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final String? idToken = googleAuth.idToken;

    if (idToken == null) {
      throw Exception('Failed to obtain Google ID token');
    }

    // Cetak token ID untuk keperluan debugging (hapus ini di produksi)
    print("Google ID Token: $idToken");

    // Gunakan token ID untuk proses login
    final dataGoogleSignIn = SigninGoogle(googleIdToken: idToken);
    final response = await signinGoogle(dataGoogleSignIn);

    CustomToast.show(
      message: "Successfully logged in with Google!",
      type: ToastType.success,
    );

    // Anda bisa menyimpan token ID jika diperlukan untuk penggunaan selanjutnya
    // await saveGoogleIdToken(idToken);

    Get.offAllNamed(Routes.REGISTER_OTP, arguments: {
      'source': 'login',
      'otpRequestToken': response.next.otpRequestToken,
      'otpRequestId': response.next.otpRequestId,
      'googleIdToken': idToken, // Tambahkan token ID ke argumen jika diperlukan
    });
  } catch (error) {
    // ... (kode penanganan error tetap sama)
  } finally {
    isLoading.value = false;
  }
}

// Metode tambahan untuk menyimpan token jika diperlukan
// Future<void> saveGoogleIdToken(String token) async {
//   // Implementasi penyimpanan token, misalnya menggunakan shared preferences
// }

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
