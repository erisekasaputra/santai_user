import 'package:get/get.dart';
import 'package:santai/app/domain/usecases/authentikasi/signout.dart';

import '../controllers/settings_controller.dart';
import 'package:http/http.dart' as http;
import 'package:santai/app/data/datasources/authentikasi/auth_remote_data_source.dart';
import 'package:santai/app/data/repositories/authentikasi/auth_repository_impl.dart';
import 'package:santai/app/domain/repository/authentikasi/auth_repository.dart';
class SettingsBinding extends Bindings {
  @override
  // void dependencies() {
  //   Get.lazyPut<SettingsController>(
  //     () => SettingsController(),
  //   );
  // }


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
    Get.lazyPut(() => SignOutUser(Get.find<AuthRepository>()));


    // Register the controller
    Get.lazyPut<SettingsController>(
      () => SettingsController(
        signOutUser: Get.find<SignOutUser>(),
      ),
    );
  }
}
