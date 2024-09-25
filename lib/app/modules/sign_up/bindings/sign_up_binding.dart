import 'package:get/get.dart';
import 'package:santai/app/data/repositories/authentikasi/auth_repository_impl.dart';
import 'package:santai/app/data/datasources/authentikasi/auth_remote_data_source.dart';
import 'package:santai/app/domain/repository/authentikasi/auth_repository.dart';
import 'package:santai/app/domain/usecases/authentikasi/register_user.dart';
import '../controllers/sign_up_controller.dart';
import 'package:http/http.dart' as http;

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<http.Client>(() => http.Client());

    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: Get.find<http.Client>()),
    );

    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: Get.find<AuthRemoteDataSource>()),
    );


    Get.lazyPut(() => RegisterUser(Get.find<AuthRepository>()));

    Get.lazyPut<SignUpController>(
      () => SignUpController(registerUser: Get.find<RegisterUser>()),
    );
  }
}