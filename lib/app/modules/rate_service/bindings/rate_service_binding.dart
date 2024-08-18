import 'package:get/get.dart';

import '../controllers/rate_service_controller.dart';

class RateServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RateServiceController>(
      () => RateServiceController(),
    );
  }
}
