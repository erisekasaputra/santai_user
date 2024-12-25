import 'package:get/get.dart';

import '../controllers/qr_order_controller.dart';

class QrOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<QrOrderController>(
      QrOrderController(),
    );
  }
}
