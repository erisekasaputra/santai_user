import 'package:get/get.dart';
import 'package:santai/app/data/datasources/fleet/fleet_remote_data_source.dart';
import 'package:santai/app/data/repositories/fleet/fleet_repository_impl.dart';
import 'package:santai/app/domain/repository/fleet/fleet_repository.dart';
import 'package:santai/app/domain/usecases/fleet/insert_fleet_user.dart';
import 'package:santai/app/services/image_upload_service.dart';
import 'package:santai/app/services/secure_storage_service.dart';

import '../controllers/reg_motorcycle_controller.dart';

import 'package:http/http.dart' as http;

class RegMotorcycleBinding extends Bindings {
  @override
  // void dependencies() {
  //   Get.lazyPut<RegMotorcycleController>(
  //     () => RegMotorcycleController(),
  //   );
  // }

  void dependencies() {
    // Register the http client
    Get.lazyPut<http.Client>(() => http.Client());

    Get.lazyPut<FleetRemoteDataSource>(
      () => FleetRemoteDataSourceImpl(client: Get.find<http.Client>()),
    );

    Get.lazyPut<FleetRepository>(
      () => FleetRepositoryImpl(remoteDataSource: Get.find<FleetRemoteDataSource>()),
    );

    Get.lazyPut(() => UserInsertFleet(Get.find<FleetRepository>()));
    Get.lazyPut(() => SecureStorageService());
    Get.lazyPut(() => ImageUploadService());

    // Get.lazyPut(() => ImageUploadService(
    //   secureStorage: Get.find<SecureStorageService>(),
    // ));

    Get.lazyPut(() => RegMotorcycleController(
      insertFleetUser: Get.find<UserInsertFleet>(),
      imageUploadService: Get.find<ImageUploadService>(),
    ));

  }
}
