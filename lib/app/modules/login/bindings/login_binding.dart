import 'package:get/get.dart';
import 'package:santai/app/data/datasources/common/common_remote_data_source.dart';
import 'package:santai/app/data/repositories/common/common_repository_impl.dart';
import 'package:santai/app/domain/repository/common/common_repository.dart';
import 'package:santai/app/domain/usecases/authentikasi/sign_in_user.dart';
import 'package:santai/app/domain/usecases/authentikasi/sign_in_staff.dart';
import 'package:santai/app/domain/usecases/authentikasi/sign_in_google.dart';
import 'package:santai/app/domain/usecases/common/common_get_img_url_public.dart';
import 'package:santai/app/modules/login/controllers/login_controller.dart';

import 'package:santai/app/domain/repository/authentikasi/auth_repository.dart';
import 'package:santai/app/data/repositories/authentikasi/auth_repository_impl.dart';
import 'package:santai/app/data/datasources/authentikasi/auth_remote_data_source.dart';
import 'package:http/http.dart' as http;

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Register the http client
    Get.create<http.Client>(() => http.Client());
    Get.create<CommonRemoteDataSource>(
      () => CommonRemoteDataSourceImpl(client: Get.find<http.Client>()),
    );
    // Register the remote data source
    Get.create<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: Get.find<http.Client>()),
    );

    Get.create<CommonRepository>(
      () => CommonRepositoryImpl(
          remoteDataSource: Get.find<CommonRemoteDataSource>()),
    );
    Get.create<AuthRepository>(
      () => AuthRepositoryImpl(
          remoteDataSource: Get.find<AuthRemoteDataSource>()),
    );

    Get.create(() => CommonGetImgUrlPublic(Get.find<CommonRepository>()));
    Get.create(() => UserSignIn(Get.find<AuthRepository>()));
    Get.create(() => StaffSignIn(Get.find<AuthRepository>()));
    Get.create(() => GoogleSignIn(Get.find<AuthRepository>()));

    Get.put<LoginController>(
      LoginController(
        signinUser: Get.find<UserSignIn>(),
        signinStaff: Get.find<StaffSignIn>(),
        signinGoogle: Get.find<GoogleSignIn>(),
        commonGetImgUrlPublic: Get.find<CommonGetImgUrlPublic>(),
      ),
    );
  }
}
