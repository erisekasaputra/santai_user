import 'package:get/get.dart';
import 'package:santai/app/routes/app_pages.dart';

class QrOrderController extends GetxController {
  final orderSecret = ''.obs;
  final paramAction = ''.obs;

  final count = 0.obs;
  @override
  void onInit() async {
    super.onInit();
    orderSecret.value = Get.arguments['orderSecret'] ?? "";
    paramAction.value = Get.arguments['paramAction'] ?? "";
  }

  void increment() => count.value++;

  void backToDashboard() {
    if (paramAction.value == "BACK") {
      Get.back(closeOverlays: true);
      return;
    }
    Get.offAllNamed(Routes.DASHBOARD);
  }
}
