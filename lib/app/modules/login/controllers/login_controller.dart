import 'dart:convert';

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

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

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

      // print("responseHUUUU: ${response.next.otpRequestToken}");

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

      // print("responseHUUUU: ${response.next.otpRequestToken}");

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
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // final String? accessToken = googleAuth.accessToken;

      print("idToken: ${googleAuth.idToken}");
      print("accessToken: ${googleAuth.accessToken}");

      // final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      final dataGoogleSignIn = SigninGoogle(googleIdToken: accessToken!);

      final response = await signinGoogle(dataGoogleSignIn);

      // print("responseHUUUU: ${response.next.otpRequestToken}");

      CustomToast.show(
        message: "Successfully login with Google!",
        type: ToastType.success,
      );

      Get.offAllNamed(Routes.REGISTER_OTP, arguments: {
        'source': 'login',
        'otpRequestToken': response.next.otpRequestToken,
        'otpRequestId': response.next.otpRequestId,
      });
    } catch (error) {
      String message;
      int statusCode = 500;

      if (error is Exception) {
        String errorString = error.toString();
        if (errorString.startsWith('Exception: ')) {
          errorString = errorString.substring(11);
        }
        try {
          final Map<String, dynamic> errorJson = json.decode(errorString);
          message = errorJson['message'] ?? 'Unknown error';
          statusCode = errorJson['statusCode'] ?? 500;

          print("message: $message");
          print("statusCode: $statusCode");

          CustomToast.show(
            message: "Login failed1111: $message (Status Code: $statusCode)",
            type: ToastType.error,
          );
        } catch (_) {
          message = errorString;
        }
      } else {
        message = "An unexpected error occurred";
      }

      CustomToast.show(
        message: "Login failed: $message (Status Code: $statusCode)",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
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
