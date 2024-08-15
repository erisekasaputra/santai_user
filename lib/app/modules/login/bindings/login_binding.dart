import 'package:get/get.dart';
import 'package:santai/app/data/repositories/user_repository.dart';
import 'package:santai/app/data/repositories/user_repository_impl.dart';
import 'package:santai/app/domain/usecases/login_use_case.dart';
import 'package:santai/app/modules/login/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRepository>(() => UserRepositoryImpl());
    Get.lazyPut(() => LoginUseCase(Get.find()));
    Get.lazyPut(() => LoginController(Get.find()));
  }
}