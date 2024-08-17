import 'package:get/get.dart';
import '../controllers/reg_user_profile_controller.dart';

class RegUserProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegUserProfileController());
  }
}