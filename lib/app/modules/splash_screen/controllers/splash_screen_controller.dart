import 'package:get/get.dart';
import 'package:santai/app/routes/app_pages.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () {
      Get.offNamed(Routes.LOGIN);
    });
  }

}