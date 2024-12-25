import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_verify_login.dart';
import 'package:santai/app/domain/entities/authentikasi/otp_request.dart';
import 'package:santai/app/domain/enumerations/user_types_enum.dart';

import 'package:santai/app/domain/usecases/authentikasi/otp_verify_register.dart';
import 'package:santai/app/domain/usecases/authentikasi/send_otp.dart';
import 'package:santai/app/domain/usecases/authentikasi/verify_login.dart';
import 'package:santai/app/domain/usecases/profile/get_business_profile_user.dart';
import 'package:santai/app/domain/usecases/profile/get_profile_user.dart';
import 'package:santai/app/domain/usecases/profile/get_staff_profile_user.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/modules/change_password/controllers/change_password_controller.dart';

import 'dart:async';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/utils/http_error_handler.dart';
import 'package:santai/app/utils/logout_helper.dart';
import 'package:santai/app/utils/session_manager.dart';

class RegisterOtpController extends GetxController {
  final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());

  // FocusNodes for managing focus
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  // Value observable for OTP
  RxString otp = ''.obs;

  // Method to handle text change
  void onTextChanged(int index, String value) {
    if (value.isNotEmpty && value.length <= 2 && index < 5) {
      // Move to next field if not the last field
      focusNodes[index + 1].requestFocus();
      controllers[index].text = controllers[index].text.substring(0, 1);
    } else if (value.isNotEmpty && value.length <= 2 && index == 5) {
      focusNodes[index].requestFocus();
      controllers[index].text = controllers[index].text.substring(0, 1);
    } else if (index > 0) {
      focusNodes[index - 1].requestFocus();
    }
    updateOtp();
  }

  // Update OTP value based on controllers' text
  void updateOtp() {
    otp.value = controllers.map((c) => c.text).join();

    if (otp.value.length == 6) {
      verifyOtp(otp.value);
    }
  }

  final changePasswordController = Get.isRegistered<ChangePasswordController>()
      ? Get.find<ChangePasswordController>()
      : null;
  final SessionManager sessionManager = SessionManager();
  final Logout logout = Logout();
  final otpSource = ''.obs;
  final otpRequestId = ''.obs;
  final otpRequestToken = ''.obs;
  final nextAction = ''.obs;

  final canResend = true.obs;
  final resendTimer = 60.obs;

  final isLoadingSms = false.obs;
  final isLoadingWhatsApp = false.obs;

  final phoneNumber = ''.obs;

  Timer? _timer;

  final SendOtp sendOtp;
  final VerifyOtpRegister otpRegisterVerify;
  final LoginVerify verifyLogin;
  final UserGetProfile getUserProfile;
  final GetBusinessProfileUser getBusinessUser;
  final GetStaffProfileUser getStaffUser;

  RegisterOtpController({
    required this.sendOtp,
    required this.otpRegisterVerify,
    required this.verifyLogin,
    required this.getUserProfile,
    required this.getBusinessUser,
    required this.getStaffUser,
  });

  @override
  void onInit() {
    super.onInit();
    startResendTimer();

    phoneNumber.value = Get.arguments?['identity'] ?? '';
    otpSource.value = Get.arguments?['source'] ?? '';
    otpRequestId.value = Get.arguments?['otpRequestId'] ?? '';
    otpRequestToken.value = Get.arguments?['otpRequestToken'] ?? '';

    // for (int i = 0; i < controllers.length; i++) {
    //   controllers[i].addListener(() {
    //     String value = controllers[i].text;
    //     if (value == "") {
    //       onTextChanged(i, value);
    //     }
    //   });
    // }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void sendOtpViaSms() async {
    isLoadingSms.value = true;
    try {
      final otpRequest = OtpRequest(
        otpProviderType: 'Sms',
        otpRequestId: otpRequestId.value,
        otpRequestToken: otpRequestToken.value,
      );

      final response = await sendOtp(otpRequest);

      if (response == null) {
        CustomToast.show(
          message: "Could not send the OTP",
          type: ToastType.error,
        );
        return;
      }
      nextAction.value = response.next.action;
      phoneNumber.value = response.data.phoneNumber;
      canResend.value = false;
      startResendTimer();
    } catch (error) {
      if (error is CustomHttpException) {
        if (error.statusCode == 401) {
          await logout.doLogout();
          return;
        }

        if (error.errorResponse != null) {
          parseErrorMessage(error.errorResponse!);
          CustomToast.show(
            message: error.message,
            type: ToastType.error,
          );
          return;
        }

        CustomToast.show(message: error.message, type: ToastType.error);
        return;
      } else {
        CustomToast.show(
          message: "An unexpected error has occured",
          type: ToastType.error,
        );
      }
    } finally {
      isLoadingSms.value = false;
    }
  }

  void verifyOtp(String otp) async {
    try {
      if (otpSource.value == 'login' || otpSource.value == 'signup') {
        final deviceId =
            await sessionManager.getSessionBy(SessionManagerType.deviceId);

        final verifyLoginRequest = VerifyLogin(
          deviceId: deviceId,
          phoneNumber: phoneNumber.value,
          token: otp,
        );

        final response = await verifyLogin(verifyLoginRequest);

        if (response == null) {
          throw CustomHttpException(400, "We could not log you in");
        }

        await sessionManager.registerSessionForLogin(
          accessToken: response.data.accessToken,
          refreshToken: response.data.refreshToken.token,
          userId: response.data.sub,
          userType: response.data.userType,
          businessCode: response.data.businessCode ?? '',
          userPhoneNumber: response.data.phoneNumber,
        );

        if (response.data.userType == UserTypesEnum.regularUser) {
          var userProfile = await getUserProfile(response.data.sub);
          if (userProfile == null) {
            Get.offAllNamed(Routes.REG_USER_PROFILE);
            return;
          } else {
            await sessionManager.registerSessionForProfile(
              userName:
                  '${userProfile.data.personalInfo.firstName} ${userProfile.data.personalInfo.middleName ?? ''} ${userProfile.data.personalInfo.lastName ?? ''}',
              timeZone: userProfile.data.timeZoneId,
              phoneNumber: userProfile.data.phoneNumber,
              imageProfile: userProfile.data.personalInfo.profilePicture ?? '',
              referralCode: userProfile.data.referral.referralCode,
            );
            Get.offAllNamed(Routes.DASHBOARD);
            return;
          }
        }

        if (response.data.userType == UserTypesEnum.businessUser) {
          var businessUser = await getBusinessUser(response.data.sub);
          if (businessUser == null) {
            await logout.doLogout();
            CustomToast.show(
                message: 'Your business account has not been registered',
                type: ToastType.error);
            return;
          }

          await sessionManager.registerSessionForProfile(
            userName: businessUser.data.businessName,
            timeZone: businessUser.data.timeZoneId,
            phoneNumber: businessUser.data.phoneNumber ?? '',
            imageProfile: '',
            referralCode: businessUser.data.referral?.referralCode ?? '',
          );

          Get.toNamed(Routes.DASHBOARD);
          return;
        }

        if (response.data.userType == UserTypesEnum.staffUser) {
          var staffUser = await getStaffUser(response.data.sub);
          if (staffUser == null) {
            await logout.doLogout();
            CustomToast.show(
                message: 'Your staff account has not been registered',
                type: ToastType.error);
            return;
          }

          await sessionManager.registerSessionForProfile(
            userName: staffUser.data.name,
            timeZone: staffUser.data.timeZoneId,
            phoneNumber: staffUser.data.phoneNumber ?? '',
            imageProfile: '',
            referralCode: '',
          );

          Get.toNamed(Routes.DASHBOARD);
          return;
        }

        Get.offAllNamed(Routes.LOGIN);
      } else if (otpSource.value == 'reset_password') {
        if (changePasswordController != null) {
          changePasswordController!.otp.value = otp.trim();
          changePasswordController!.identity.value = phoneNumber.value.trim();
          changePasswordController!.otpRequestId.value = otpRequestId.value;
          changePasswordController!.otpRequestToken.value =
              otpRequestToken.value;
        }

        Get.toNamed(
          Routes.CHANGE_PASSWORD,
          arguments: {
            'otp': otp,
            'otpRequestId': otpRequestId.value,
            'otpRequestToken': otpRequestToken.value,
            'identity': phoneNumber.value
          },
        );
      }
    } catch (e) {
      if (e is CustomHttpException) {
        if (e.statusCode == 401) {
          await logout.doLogout();
          return;
        }

        if (e.errorResponse != null) {
          parseErrorMessage(e.errorResponse!);
          CustomToast.show(
            message: e.message,
            type: ToastType.error,
          );
          return;
        }

        CustomToast.show(message: e.message, type: ToastType.error);
        return;
      }
      CustomToast.show(
        message:
            "We couldn't procced you request. Please ensure your details are correct.",
        type: ToastType.error,
      );
    }
  }

  void startResendTimer() {
    resendTimer.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        timer.cancel();
        canResend.value = true;
      }
    });
  }
}
