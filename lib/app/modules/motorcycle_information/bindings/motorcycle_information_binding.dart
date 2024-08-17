import 'package:get/get.dart';

import '../controllers/motorcycle_information_controller.dart';

class MotorcycleInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MotorcycleInformationController>(
      () => MotorcycleInformationController(),
    );
  }
}
