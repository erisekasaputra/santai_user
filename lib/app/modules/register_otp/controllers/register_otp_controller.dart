import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_verify_login.dart';
import 'package:santai/app/domain/entities/authentikasi/otp_request.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_otp_register_verify.dart';

import 'package:santai/app/domain/usecases/authentikasi/otp_verify_register.dart';
import 'package:santai/app/domain/usecases/authentikasi/send_otp.dart';
import 'package:santai/app/domain/usecases/authentikasi/verify_login.dart';

import 'dart:async';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/services/notification_service.dart';
import 'package:santai/app/services/secure_storage_service.dart';

class RegisterOtpController extends GetxController {
  final otpSource = ''.obs;
  final otpRequestId = ''.obs;
  final otpRequestToken = ''.obs;

  final otp = ['', '', '', '', '', ''].obs;
  final canResend = true.obs;
  final resendTimer = 60.obs;

  final isLoadingSms = false.obs;
  final isLoadingWhatsApp = false.obs;

  final phoneNumber = ''.obs;

  final NotificationService _notificationService = NotificationService();
  final SecureStorageService _secureStorage = SecureStorageService();

  Timer? _timer;

  final SendOtp sendOtp;
  final VerifyOtpRegister otpRegisterVerify;
  final LoginVerify verifyLogin;

  RegisterOtpController({
    required this.sendOtp,
    required this.otpRegisterVerify,
    required this.verifyLogin,
  });

  @override
  void onInit() {
    super.onInit();
    startResendTimer();

    otpSource.value = Get.arguments?['source'] ?? '';
    otpRequestId.value = Get.arguments?['otpRequestId'] ?? '';
    otpRequestToken.value = Get.arguments?['otpRequestToken'] ?? '';
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

  void sendOtpViaSms() async {
    isLoadingSms.value = true;
    try {
      final otpRequest = OtpRequest(
        otpProviderType: 'Sms',
        otpRequestId: otpRequestId.value,
        otpRequestToken: otpRequestToken.value,
      );

      final response = await sendOtp(otpRequest);

      phoneNumber.value = response.data.phoneNumber;

      _notificationService.showNotification(
        id: 0,
        title: 'Santai',
        body: response.data.token ?? '',
      );

      canResend.value = false;
      startResendTimer();
    } catch (e) {
      CustomToast.show(
        message: "Failed to send OTP via SMS: ${e.toString()}",
        type: ToastType.error,
      );
    } finally {
      isLoadingSms.value = false;
    }
  }

  void sendOtpViaWhatsApp() async {
    isLoadingWhatsApp.value = true;
    try {
      _notificationService.showNotification(
        id: 0,
        title: 'Santai',
        body: 'OTP has been sent',
      );

      canResend.value = false;
      startResendTimer();
    } catch (e) {
      CustomToast.show(
        message: "Failed to send OTP via WhatsApp",
        type: ToastType.error,
      );
    } finally {
      isLoadingWhatsApp.value = false;
    }
  }

  void verifyOtp() async {
    try {
      final fullOtp = otp.join();
      // print('Entered OTP: $fullOtp');

      final otpRegisterVerifyRequest = OtpRegisterVerify(
        phoneNumber: phoneNumber.value,
        token: fullOtp,
      );

      await otpRegisterVerify(otpRegisterVerifyRequest);

      if (otpSource.value == 'login') {

        final deviceId = await _secureStorage.readSecureData('fcm_token');

        final verifyLoginRequest = VerifyLogin(
          deviceId: deviceId ?? '',
          phoneNumber: phoneNumber.value,
          token: fullOtp,
        );

        final response = await verifyLogin(verifyLoginRequest);

        await _secureStorage.writeSecureData('access_token', response.data.accessToken);
        await _secureStorage.writeSecureData('refresh_token', response.data.refreshToken.token);
        await _secureStorage.writeSecureData('user_id', response.data.sub);

        if (response.next.action == "Homepage") {
          Get.offAllNamed(Routes.DASHBOARD);
        } else if (response.next.action == "CreateAccount") {
          Get.offAllNamed(Routes.REG_USER_PROFILE);
        };

      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (e) {
      CustomToast.show(
        message: "Failed to authenticate with server",
        type: ToastType.error,
      );
    }
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
