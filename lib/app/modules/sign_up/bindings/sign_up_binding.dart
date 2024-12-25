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
    Get.create<http.Client>(() => http.Client());

    Get.create<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: Get.find<http.Client>()),
    );

    Get.create<AuthRepository>(
      () => AuthRepositoryImpl(
          remoteDataSource: Get.find<AuthRemoteDataSource>()),
    );

    Get.create(() => RegisterUser(Get.find<AuthRepository>()));

    Get.put<SignUpController>(
      SignUpController(registerUser: Get.find<RegisterUser>()),
    );
  }
}
