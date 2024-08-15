import 'package:get/get.dart';
import 'dart:async';

class RegisterOtpController extends GetxController {
  final otp = ''.obs;
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

  void addDigit(String digit) {
    if (otp.value.length < 6) {
      otp.value += digit;
    }
  }

  void deleteLastDigit() {
    if (otp.value.isNotEmpty) {
      otp.value = otp.value.substring(0, otp.value.length - 1);
    }
  }

  void resendOtp() {
    // Implement OTP resend logic here
    canResend.value = false;
    startResendTimer();
  }

  void startResendTimer() {
    resendTimer.value = 60;
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