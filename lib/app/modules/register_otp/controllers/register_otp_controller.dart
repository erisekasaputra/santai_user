import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'dart:async';
import 'package:santai/app/routes/app_pages.dart';

class RegisterOtpController extends GetxController {
  final otp = ['', '', '', ''].obs;
  final canResend = true.obs;
  final resendTimer = 60.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startResendTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void updateOtpDigit(int index, String value) {
    otp[index] = value;
    if (otp.every((digit) => digit.isNotEmpty)) {
      verifyOtp();
    }
  }

 void verifyOtp() {

  try {
    final fullOtp = otp.join();
    print('Entered OTP: $fullOtp');

    Future.delayed(const Duration(milliseconds: 500), () {
      print('Attempting to navigate...');
      Get.offAllNamed(Routes.REG_USER_PROFILE);
      print('Navigation command executed');

    });
  } catch (e) {
    CustomToast.show(
      message: "Failed to authenticate with server",
      type: ToastType.error,
    );
  }
}

  void resendOtp() {
    if (!canResend.value) return;

    print('Resending OTP...');
    
    canResend.value = false;
    startResendTimer();
  }

  void startResendTimer() {
    resendTimer.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        timer.cancel();
        canResend.value = true;
      }
    });
  }
}