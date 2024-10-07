import 'package:get/get.dart';
import 'package:santai/app/controllers/permission_controller.dart';
import 'package:santai/app/domain/usecases/common/common_get_img_url_public.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/controllers/device_info_controller.dart';
import 'package:santai/app/services/secure_storage_service.dart';
import 'package:santai/app/services/timezone_service.dart';

class SplashScreenController extends GetxController {
  final DeviceInfoController deviceInfoController =
      Get.find<DeviceInfoController>();
  final TimezoneService timezoneService = TimezoneService();
  final PermissionController _permissionController =
      Get.find<PermissionController>();
  final SecureStorageService _secureStorage = SecureStorageService();

  final CommonGetImgUrlPublic commonGetImgUrlPublic;

  SplashScreenController({required this.commonGetImgUrlPublic});

  @override
  void onInit() {
    super.onInit();
    initializeApp();
  }

  Future<void> initializeApp() async {
 
    final response = await commonGetImgUrlPublic();

    

    await _secureStorage.writeSecureData(
        'commonGetImgUrlPublic', response.url);

    await _permissionController.requestLocationPermission();
    await Future.delayed(const Duration(seconds: 2));

    String? accessToken = await _secureStorage.readSecureData('access_token');
    // Get.offAllNamed(Routes.LOGIN);
    if (accessToken != null) {
      Get.offAllNamed(Routes.DASHBOARD);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
