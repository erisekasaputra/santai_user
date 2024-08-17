import 'package:get/get.dart';

import '../controllers/reg_motorcycle_controller.dart';

class RegMotorcycleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegMotorcycleController>(
      () => RegMotorcycleController(),
    );
  }
}
