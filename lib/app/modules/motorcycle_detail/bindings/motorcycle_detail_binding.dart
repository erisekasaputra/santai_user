import 'package:get/get.dart';

import '../controllers/motorcycle_detail_controller.dart';

class MotorcycleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MotorcycleDetailController>(
      () => MotorcycleDetailController(),
    );
  }
}
