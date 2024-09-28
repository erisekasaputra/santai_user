import 'package:get/get.dart';
import 'package:santai/app/data/datasources/profile/profile_remote_data_source.dart';
import 'package:santai/app/data/repositories/profile/profile_repository_impl.dart';
import 'package:santai/app/domain/repository/profile/profile_repository.dart';
import 'package:santai/app/domain/usecases/profile/insert_profile_user.dart';
import '../controllers/reg_user_profile_controller.dart';



import 'package:http/http.dart' as http;

class RegUserProfileBinding extends Bindings {
  @override
  // void dependencies() {
  //   Get.lazyPut(() => RegUserProfileController());
  // }

  void dependencies() {
    // Register the http client
    Get.lazyPut<http.Client>(() => http.Client());

    // Register the remote data source
    Get.lazyPut<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(client: Get.find<http.Client>()),
    );

     // Register the repository
    Get.lazyPut<ProfileRepository>(
      () => ProfileRepositoryImpl(remoteDataSource: Get.find<ProfileRemoteDataSource>()),
    );

    // Register the use cases
    Get.lazyPut(() => UserInsertProfile(Get.find<ProfileRepository>()));

    Get.lazyPut(() => RegUserProfileController(
      insertProfileUser: Get.find<UserInsertProfile>(),
    ));
  }
}