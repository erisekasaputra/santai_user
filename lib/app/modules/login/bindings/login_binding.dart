import 'package:get/get.dart';
import 'package:santai/app/modules/login/controllers/login_controller.dart';
import 'package:santai/app/domain/usecases/authentikasi/login_user.dart';
import 'package:santai/app/domain/usecases/authentikasi/login_staff.dart';
import 'package:santai/app/domain/repository/authentikasi/auth_repository.dart';
import 'package:santai/app/data/repositories/authentikasi/auth_repository_impl.dart';
import 'package:santai/app/data/datasources/authentikasi/auth_remote_data_source.dart';
import 'package:http/http.dart' as http;

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Register the http client
    Get.lazyPut<http.Client>(() => http.Client());

    // Register the remote data source
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: Get.find<http.Client>()),
    );

    // Register the repository
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: Get.find<AuthRemoteDataSource>()),
    );

    // Register the use cases
    Get.lazyPut(() => LoginUser(Get.find<AuthRepository>()));
    Get.lazyPut(() => LoginStaff(Get.find<AuthRepository>()));

    // Register the controller
    Get.lazyPut<LoginController>(
      () => LoginController(
        loginUser: Get.find<LoginUser>(),
        loginStaff: Get.find<LoginStaff>(),
      ),
    );
  }
}