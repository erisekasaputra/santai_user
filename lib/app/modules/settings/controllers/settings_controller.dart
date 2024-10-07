import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_signout.dart';
import 'package:santai/app/domain/usecases/authentikasi/signout.dart';
import 'package:santai/app/helpers/sqlite_db_helper.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/services/secure_storage_service.dart';

class SettingsController extends GetxController {
  final SecureStorageService _secureStorage = SecureStorageService();
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  final accessToken = ''.obs;
  final refreshToken = ''.obs;
  final deviceId = ''.obs;

  final SignOutUser signOutUser;

  SettingsController({required this.signOutUser});

  @override
  void onInit() async {
    super.onInit();

    accessToken.value =
        await _secureStorage.readSecureData('access_token') ?? '';
    refreshToken.value =
        await _secureStorage.readSecureData('refresh_token') ?? '';
    deviceId.value = await _secureStorage.readSecureData('fcm_token') ?? '';

  

    print('access_token: ${accessToken.value}');
    print('refresh_token: ${refreshToken.value}');
    print('device_id: ${deviceId.value}');


    final currentAddress = await dbHelper.getCurrentAddress();
    final latitude = currentAddress!['latitude'] as double;
    final longitude = currentAddress['longitude'] as double;

    print('longitude: $longitude');
    print('latitude: $latitude');


  }

  void signOut() async {
    try {
      final dataUserSignIn = SignOut(
        accessToken: accessToken.value,
        refreshToken: refreshToken.value,
        deviceId: deviceId.value,
      );

      await signOutUser(dataUserSignIn);
      await _secureStorage.deleteSecureData('access_token');
      await _secureStorage.deleteSecureData('refresh_token');
      await _secureStorage.deleteSecureData('device_id');
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
    } finally {}
  }

  void onEditProfileTap() {
    // Implement edit profile logic
    Get.toNamed(Routes.REG_USER_PROFILE);
  }

  void onAddressTap() {
    // Implement address logic
    // Get.toNamed(Routes.ADDRESS);
  }

  void onNotificationTap() {
    // Implement notification settings logic
    // Get.toNamed(Routes.NOTIFICATION_SETTINGS);
  }

  void onEWalletTap() {
    // Implement e-wallet logic
    // Get.toNamed(Routes.E_WALLET);
  }

  void onSecurityTap() {
    // Implement security settings logic
    // Get.toNamed(Routes.SECURITY_SETTINGS);
  }

  void onLanguageTap() {
    // Implement language settings logic
    // Get.toNamed(Routes.LANGUAGE_SETTINGS);
  }

  void onPrivacyPolicyTap() {
    // Implement privacy policy logic
    // Get.toNamed(Routes.PRIVACY_POLICY);
  }

  void onSupportTap() {
    // Implement support logic
    // Get.toNamed(Routes.SUPPORT);
  }

  void onInviteFriendsTap() {
    // Implement invite friends logic
    // Get.toNamed(Routes.INVITE_FRIENDS);
  }

  final String profileImageUrl = 'https://example.com/profile-image.jpg';
  final String userName = 'Pang Li Quan';
  final String phoneNumber = '+018 222 0060';
  final String currentLanguage = 'English (UK)';
}
