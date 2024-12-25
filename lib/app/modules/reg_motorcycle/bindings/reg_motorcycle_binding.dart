import 'package:get/get.dart';
import 'package:santai/app/data/datasources/fleet/fleet_remote_data_source.dart';
import 'package:santai/app/data/repositories/fleet/fleet_repository_impl.dart';
import 'package:santai/app/domain/repository/fleet/fleet_repository.dart';
import 'package:santai/app/domain/usecases/fleet/insert_fleet_user.dart';
import 'package:santai/app/domain/usecases/fleet/get_fleet_user.dart';
import 'package:santai/app/domain/usecases/fleet/update_fleet_user.dart';
import 'package:santai/app/services/auth_http_client.dart';
import 'package:santai/app/services/image_upload_service.dart';
import 'package:santai/app/services/secure_storage_service.dart';

import '../controllers/reg_motorcycle_controller.dart';

import 'package:http/http.dart' as http;

class RegMotorcycleBinding extends Bindings {
  @override
  void dependencies() {
    // Register the http client
    Get.create<http.Client>(() => http.Client());
    Get.create<SecureStorageService>(() => SecureStorageService());
    Get.create<AuthHttpClient>(() => AuthHttpClient(
        Get.find<http.Client>(), Get.find<SecureStorageService>()));

    Get.create<FleetRemoteDataSource>(
      () => FleetRemoteDataSourceImpl(client: Get.find<AuthHttpClient>()),
    );

    Get.create<FleetRepository>(
      () => FleetRepositoryImpl(
          remoteDataSource: Get.find<FleetRemoteDataSource>()),
    );

    Get.create(() => UserInsertFleet(Get.find<FleetRepository>()));
    Get.create(() => UserGetFleet(Get.find<FleetRepository>()));
    Get.create(() => UserUpdateFleet(Get.find<FleetRepository>()));
    Get.create(() => SecureStorageService());
    Get.create(() => ImageUploadService());

    // Get.lazyPut(() => ImageUploadService(
    //   secureStorage: Get.find<SecureStorageService>(),
    // ));

    Get.put(RegMotorcycleController(
      insertFleetUser: Get.find<UserInsertFleet>(),
      imageUploadService: Get.find<ImageUploadService>(),
      getFleetUserById: Get.find<UserGetFleet>(),
      updateFleetUser: Get.find<UserUpdateFleet>(),
    ));
  }
}
