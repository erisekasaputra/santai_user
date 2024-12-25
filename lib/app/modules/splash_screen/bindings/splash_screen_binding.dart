import 'package:get/get.dart';
import 'package:santai/app/data/datasources/common/common_remote_data_source.dart';
import 'package:santai/app/data/datasources/profile/profile_remote_data_source.dart';
import 'package:santai/app/data/repositories/common/common_repository_impl.dart';
import 'package:santai/app/data/repositories/profile/profile_repository_impl.dart';
import 'package:santai/app/domain/repository/common/common_repository.dart';
import 'package:santai/app/domain/repository/profile/profile_repository.dart';
import 'package:santai/app/domain/usecases/common/common_get_img_url_public.dart';
import 'package:santai/app/domain/usecases/profile/get_business_profile_user.dart';
import 'package:santai/app/domain/usecases/profile/get_profile_user.dart';
import 'package:santai/app/domain/usecases/profile/get_staff_profile_user.dart';
import 'package:santai/app/services/auth_http_client.dart';
import 'package:santai/app/services/secure_storage_service.dart';

import '../controllers/splash_screen_controller.dart';

import 'package:http/http.dart' as http;

class SplashScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.create<SecureStorageService>(() => SecureStorageService());
    Get.create<http.Client>(() => http.Client());
    Get.create<AuthHttpClient>(() => AuthHttpClient(
        Get.find<http.Client>(), Get.find<SecureStorageService>()));

    Get.create<CommonRemoteDataSource>(
      () => CommonRemoteDataSourceImpl(client: Get.find<http.Client>()),
    );
    Get.create<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(client: Get.find<AuthHttpClient>()),
    );

    Get.create<CommonRepository>(
      () => CommonRepositoryImpl(
          remoteDataSource: Get.find<CommonRemoteDataSource>()),
    );
    Get.create<ProfileRepository>(
      () => ProfileRepositoryImpl(
          remoteDataSource: Get.find<ProfileRemoteDataSource>()),
    );

    Get.create(() => CommonGetImgUrlPublic(Get.find<CommonRepository>()));
    Get.create(() => UserGetProfile(Get.find<ProfileRepository>()));
    Get.create(() => GetBusinessProfileUser(Get.find<ProfileRepository>()));
    Get.create(() => GetStaffProfileUser(Get.find<ProfileRepository>()));

    Get.put(SplashScreenController(
        commonGetImgUrlPublic: Get.find<CommonGetImgUrlPublic>(),
        getUserProfile: Get.find<UserGetProfile>(),
        getBusinessUserProfile: Get.find<GetBusinessProfileUser>(),
        getStaffUserProfile: Get.find<GetStaffProfileUser>()));
  }
}
