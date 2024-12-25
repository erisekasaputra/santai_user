import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/data/models/common/base_error.dart';
import 'package:santai/app/domain/usecases/authentikasi/forgot_password.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/modules/register_otp/controllers/register_otp_controller.dart';
import 'package:santai/app/routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  final registerOtpController = Get.isRegistered<RegisterOtpController>()
      ? Get.find<RegisterOtpController>()
      : null;
  TextEditingController phoneController = TextEditingController();
  final countryISOCode = ''.obs;
  final countryCode = ''.obs;
  final phoneNumber = ''.obs;
  final isLoading = false.obs;

  final count = 0.obs;

  final ForgotPassword forgotPassword;

  final error = Rx<ErrorResponse?>(null);

  ForgotPasswordController({required this.forgotPassword});

  @override
  void onInit() {
    super.onInit();
    resetPhoneController();
  }

  void resetPhoneController() {
    phoneController.text = '';
    phoneNumber.value = '';
    phoneNumber.refresh();
  }

  void updatePhoneInfo(String isoCode, String code, String number) {
    countryISOCode.value = isoCode;
    countryCode.value = code;
    phoneNumber.value = number;
  }

  Future<void> forgotPasswordAction() async {
    try {
      var forgotPasswordResult =
          await forgotPassword('${countryCode.value}${phoneNumber.value}');

      if (forgotPasswordResult != null && forgotPasswordResult.isSuccess) {
        if (registerOtpController != null) {
          registerOtpController!.otpSource.value = 'reset_password';
          registerOtpController!.otpRequestToken.value =
              forgotPasswordResult.next.otpRequestToken;
          registerOtpController!.otpRequestId.value =
              forgotPasswordResult.next.otpRequestId;
        }

        Get.toNamed(Routes.REGISTER_OTP, arguments: {
          'otpRequestId': forgotPasswordResult.next.otpRequestId,
          'otpRequestToken': forgotPasswordResult.next.otpRequestToken,
          'source': 'reset_password'
        });
        return;
      }

      CustomToast.show(
        message: "Uupps, we could not find your account",
        type: ToastType.error,
      );
    } catch (exception) {
      if (exception is CustomHttpException) {
        if (exception.errorResponse != null) {
          error.value = exception.errorResponse;
          CustomToast.show(
            message: exception.message,
            type: ToastType.error,
          );
          return;
        }

        CustomToast.show(message: exception.message, type: ToastType.error);
        return;
      } else {
        CustomToast.show(
          message: "An unexpected error occurred",
          type: ToastType.error,
        );
      }
    }
  }
}
