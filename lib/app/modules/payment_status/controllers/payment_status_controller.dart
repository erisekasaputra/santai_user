import 'package:get/get.dart';
import 'package:santai/app/routes/app_pages.dart';

class PaymentStatusController extends GetxController {
  final status = ''.obs;
  final orderSecret = ''.obs;
  final orderId = ''.obs;
  final amount = ''.obs;
  final transactionId = ''.obs;
  final count = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    status.value = Get.arguments['status'];
    orderSecret.value = Get.arguments['orderSecret'];
    orderId.value = Get.arguments['orderId'];
    amount.value = Get.arguments['amount'];
    transactionId.value = Get.arguments['transactionId'];
  }

  void increment() => count.value++;

  void redirectToHome() {
    Get.offAllNamed(Routes.DASHBOARD);
  }

  void showQRCode() {
    Get.offAllNamed(Routes.QR_ORDER, arguments: {
      'orderSecret': orderSecret.value,
      'paramAction': 'CLOSE',
    });
  }
}
