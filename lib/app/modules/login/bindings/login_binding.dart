import 'package:get/get.dart';
import 'package:santai/app/domain/usecases/authentikasi/sign-in_user.dart';
import 'package:santai/app/domain/usecases/authentikasi/sign-in_staff.dart';
import 'package:santai/app/domain/usecases/authentikasi/sign-in_google.dart';
import 'package:santai/app/modules/login/controllers/login_controller.dart';

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
    Get.lazyPut(() => UserSignIn(Get.find<AuthRepository>()));
    Get.lazyPut(() => StaffSignIn(Get.find<AuthRepository>()));
    Get.lazyPut(() => GoogleSignIn(Get.find<AuthRepository>()));


    // Register the controller
    Get.lazyPut<LoginController>(
      () => LoginController(
        signinUser: Get.find<UserSignIn>(),
        signinStaff: Get.find<StaffSignIn>(),
        signinGoogle: Get.find<GoogleSignIn>(),
      ),
    );
  }
}