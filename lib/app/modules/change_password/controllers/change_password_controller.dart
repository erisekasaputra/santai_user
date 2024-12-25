import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/data/models/common/base_error.dart';
import 'package:santai/app/domain/entities/authentikasi/password_reset.dart';
import 'package:santai/app/domain/usecases/authentikasi/reset_password.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/modules/register_otp/controllers/register_otp_controller.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/utils/logout_helper.dart';

class ChangePasswordController extends GetxController {
  final registerOtpController = Get.isRegistered<RegisterOtpController>()
      ? Get.find<RegisterOtpController>()
      : null;
  final Logout logout = Logout();
  final isLoading = false.obs;

  final otp = ''.obs;
  final otpRequestId = ''.obs;
  final otpRequestToken = ''.obs;
  final identity = ''.obs;

  final error = Rx<ErrorResponse?>(null);

  final RxList<ErrorDetail> errors = RxList<ErrorDetail>([]);

  TextEditingController newPasswordController = TextEditingController();

  ResetPassword resetPassword;

  ChangePasswordController({required this.resetPassword});

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();

    otp.value = Get.arguments['otp'];
    identity.value = Get.arguments['identity'];
    otpRequestId.value = Get.arguments['otpRequestId'];
    otpRequestToken.value = Get.arguments['otpRequestToken'];
  }

  Future<void> changePasswordAction() async {
    try {
      if (newPasswordController.text.isEmpty ||
          otp.value.isEmpty ||
          otpRequestId.value.isEmpty ||
          otpRequestToken.value.isEmpty) {
        return;
      }

      var resetBody = PasswordReset(
          identity: identity.value,
          newPassword: newPasswordController.text,
          otpCode: otp.value);
      var result = await resetPassword(resetBody);

      if (result) {
        CustomToast.show(
            message: 'Password has been changed', type: ToastType.success);
        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (e) {
      if (e is CustomHttpException) {
        error.value = e.errorResponse;

        if (e.message.toLowerCase().contains('otp') &&
            e.message.toLowerCase().contains('valid')) {
          if (registerOtpController != null) {
            registerOtpController!.otpSource.value = 'reset_password';
            registerOtpController!.otpRequestToken.value =
                otpRequestToken.value;
            registerOtpController!.otpRequestId.value = otpRequestId.value;
            registerOtpController!.phoneNumber.value = identity.value;
          }

          Get.toNamed(Routes.REGISTER_OTP, arguments: {
            'source': 'reset_password',
            'otpRequestId': otpRequestId.value,
            'otpRequestToken': otpRequestToken.value,
            'identity': identity.value,
          });
        }
        return;
      }

      CustomToast.show(
        message: 'An unexpected error has occured',
        type: ToastType.error,
      );
    }
  }
}
