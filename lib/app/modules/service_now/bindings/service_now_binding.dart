import 'package:get/get.dart';

import '../controllers/service_now_controller.dart';

class ServiceNowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceNowController>(
      () => ServiceNowController(),
    );
  }
}
