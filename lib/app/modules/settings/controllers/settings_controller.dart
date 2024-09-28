import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_signout.dart';
import 'package:santai/app/domain/usecases/authentikasi/signout.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/services/secure_storage_service.dart';

class SettingsController extends GetxController {
  final SecureStorageService _secureStorage = SecureStorageService();
  

  final accessToken = ''.obs;
  final refreshToken = ''.obs;
  final deviceId = ''.obs;

  final SignOutUser signOutUser;

  SettingsController(
      {required this.signOutUser});

  @override
  void onInit() async {
    super.onInit();

    accessToken.value = await _secureStorage.readSecureData('access_token') ?? '';
    refreshToken.value = await _secureStorage.readSecureData('refresh_token') ?? '';
    deviceId.value = await _secureStorage.readSecureData('fcm_token') ?? '';

    // Get.snackbar('access_token', accessToken.value);
    // Get.snackbar('refresh_token', refreshToken.value);

    print('access_token: ${accessToken.value}');
    print('refresh_token: ${refreshToken.value}');
    print('device_id: ${deviceId.value}');

  }

  void signOut() async {
    try {
      final dataUserSignIn = SignOut(
        accessToken: accessToken.value,
        refreshToken: refreshToken.value,
        deviceId: deviceId.value,
      );

      final response = await signOutUser(dataUserSignIn);

      // print("responseHUUUU: ${response.next.otpRequestToken}");

      CustomToast.show(
        message: "Successfully logout!",
        type: ToastType.success,
      );

      Get.offAllNamed(Routes.LOGIN);
    } catch (error) {
      
      CustomToast.show(
        message: "Login failed: ${error.toString()}",
        type: ToastType.error,
      );
    } finally {
    }
  }

  final String profileImageUrl = 'https://example.com/profile-image.jpg';
  final String userName = 'Pang Li Quan';
  final String phoneNumber = '+018 222 0060';
  final String currentLanguage = 'English (UK)';
}
