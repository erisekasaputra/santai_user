import 'package:get/get.dart';
import 'package:santai/app/data/datasources/profile/profile_remote_data_source.dart';
import 'package:santai/app/data/repositories/profile/profile_repository_impl.dart';
import 'package:santai/app/domain/repository/profile/profile_repository.dart';
import 'package:santai/app/domain/usecases/authentikasi/signout.dart';
import 'package:santai/app/domain/usecases/profile/update_user_profile_picture.dart';
import 'package:santai/app/services/auth_http_client.dart';
import 'package:santai/app/services/image_upload_service.dart';
import 'package:santai/app/services/secure_storage_service.dart';

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
    Get.create<http.Client>(() => http.Client());
    Get.create<SecureStorageService>(() => SecureStorageService());
    Get.create<AuthHttpClient>(() => AuthHttpClient(
        Get.find<http.Client>(), Get.find<SecureStorageService>()));

    Get.create<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: Get.find<http.Client>()),
    );
    Get.create<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(client: Get.find<AuthHttpClient>()),
    );

    Get.create<AuthRepository>(
      () => AuthRepositoryImpl(
          remoteDataSource: Get.find<AuthRemoteDataSource>()),
    );
    Get.create<ProfileRepository>(
      () => ProfileRepositoryImpl(
          remoteDataSource: Get.find<ProfileRemoteDataSource>()),
    );

    Get.create(() => UpdateUserProfilePicture(Get.find<ProfileRepository>()));
    Get.create(() => SignOutUser(Get.find<AuthRepository>()));
    Get.create(() => ImageUploadService());

    Get.put<SettingsController>(
      SettingsController(
        signOutUser: Get.find<SignOutUser>(),
        imageUploadService: Get.find<ImageUploadService>(),
        updateUserProfilePicture: Get.find<UpdateUserProfilePicture>(),
      ),
    );
  }
}
