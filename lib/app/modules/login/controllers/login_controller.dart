import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/data/models/common/base_error.dart';

import 'package:santai/app/domain/entities/authentikasi/auth_signin_staff.dart';
import 'package:santai/app/domain/usecases/authentikasi/sign_in_staff.dart';

import 'package:santai/app/domain/entities/authentikasi/auth_signin_user.dart';
import 'package:santai/app/domain/usecases/authentikasi/sign_in_user.dart';

import 'package:santai/app/domain/usecases/authentikasi/sign_in_google.dart'
    as google_sign_in_usecase;
import 'package:santai/app/domain/entities/authentikasi/auth_signin_google.dart';
import 'package:santai/app/domain/usecases/common/common_get_img_url_public.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/modules/register_otp/controllers/register_otp_controller.dart';

import 'package:santai/app/routes/app_pages.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:santai/app/utils/logout_helper.dart';
import 'package:santai/app/utils/session_manager.dart';

class LoginController extends GetxController {
  final registerOtpController = Get.isRegistered<RegisterOtpController>()
      ? Get.find<RegisterOtpController>()
      : null;

  final SessionManager sessionManager = SessionManager();
  final Logout logout = Logout();
  final isLoading = false.obs;

  TextEditingController passwordController = TextEditingController();
  final isPasswordHidden = true.obs;

  TextEditingController phoneController = TextEditingController();
  final countryISOCode = ''.obs;
  final countryCode = ''.obs;
  final phoneNumber = ''.obs;

  TextEditingController businessCodeController = TextEditingController();
  final isStaffLogin = false.obs;

  final UserSignIn signinUser;
  final StaffSignIn signinStaff;
  final google_sign_in_usecase.GoogleSignIn signinGoogle;
  final CommonGetImgUrlPublic commonGetImgUrlPublic;

  final error = Rx<ErrorResponse?>(null);

  LoginController({
    required this.signinUser,
    required this.signinStaff,
    required this.signinGoogle,
    required this.commonGetImgUrlPublic,
  });

  @override
  void onInit() async {
    super.onInit();
    final response = await commonGetImgUrlPublic();
    await sessionManager.setSessionBy(
        SessionManagerType.commonFileUrl, response.data.url);
  }

  void updatePhoneInfo(String isoCode, String code, String number) {
    countryISOCode.value = isoCode;
    countryCode.value = code;
    phoneNumber.value = number;
  }

  void toggleStaffLogin({bool? value}) {
    if (value == null) {
      isStaffLogin.toggle();
      return;
    }
    isStaffLogin.value = value;
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
      if (response == null) {
        CustomToast.show(
            message:
                'We can not find your account in our database. Please make sure your credentials are correct',
            type: ToastType.error);
        return;
      }

      if (registerOtpController != null) {
        registerOtpController!.otpSource.value = 'login';
        registerOtpController!.otpRequestToken.value =
            response.next.otpRequestToken;
        registerOtpController!.otpRequestId.value = response.next.otpRequestId;
      }

      Get.toNamed(Routes.REGISTER_OTP, arguments: {
        'source': 'login',
        'otpRequestToken': response.next.otpRequestToken,
        'otpRequestId': response.next.otpRequestId,
      });
    } catch (e) {
      if (e is CustomHttpException) {
        error.value = e.errorResponse;
        if (e.errorResponse != null) {
          CustomToast.show(
            message: e.message,
            type: ToastType.error,
          );
          return;
        }
        if (e.statusCode == 401) {
          await logout.doLogout();
          return;
        }
        CustomToast.show(
          message: e.message,
          type: ToastType.error,
        );
      } else {
        CustomToast.show(
          message: "Upps, Unexpected error has occured",
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

      if (response == null) {
        CustomToast.show(
            message:
                'We can not find your account in our database. Please make sure your credentials are correct',
            type: ToastType.error);
        return;
      }

      Get.toNamed(Routes.REGISTER_OTP, arguments: {
        'source': 'login',
        'otpRequestToken': response.next.otpRequestToken,
        'otpRequestId': response.next.otpRequestId,
      });
    } catch (e) {
      if (e is CustomHttpException) {
        error.value = e.errorResponse;

        if (e.errorResponse != null) {
          CustomToast.show(
            message: e.message,
            type: ToastType.error,
          );
          return;
        }
        if (e.statusCode == 401) {
          await logout.doLogout();
          return;
        }
        CustomToast.show(
          message: e.message,
          type: ToastType.error,
        );
      } else {
        CustomToast.show(
          message: "Upps, Unexpected error has occured",
          type: ToastType.error,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        serverClientId:
            '1065462126306-sla57ni7q7n8mhs2v0miqa6u5ms8lrsi.apps.googleusercontent.com',
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google Sign-In was cancelled by the user');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('Failed to obtain Google ID token');
      }

      // Gunakan token ID untuk proses login
      final dataGoogleSignIn = SigninGoogle(googleIdToken: idToken);
      final response = await signinGoogle(dataGoogleSignIn);

      if (response == null) {
        CustomToast.show(
            message:
                'We can not find your account in our database. Please make sure your credentials are correct',
            type: ToastType.error);
        return;
      }

      Get.toNamed(Routes.REGISTER_OTP, arguments: {
        'source': 'login',
        'otpRequestToken': response.next.otpRequestToken,
        'otpRequestId': response.next.otpRequestId,
        'googleIdToken':
            idToken, // Tambahkan token ID ke argumen jika diperlukan
      });
    } catch (e) {
      if (e is CustomHttpException) {
        error.value = e.errorResponse;
        if (e.errorResponse != null) {
          CustomToast.show(
            message: e.message,
            type: ToastType.error,
          );
          return;
        }
        if (e.statusCode == 401) {
          await logout.doLogout();
          return;
        }
        CustomToast.show(
          message: e.message,
          type: ToastType.error,
        );
      } else {
        CustomToast.show(
          message: "Upps, Unexpected error has occured",
          type: ToastType.error,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> sendTokenToServer(String? token) async {
    return true; // Placeholder
  }
}
