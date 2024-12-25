import 'package:get/get.dart';
import 'package:santai/app/data/datasources/fleet/fleet_remote_data_source.dart';
import 'package:santai/app/domain/repository/fleet/fleet_repository.dart';
import 'package:santai/app/data/repositories/fleet/fleet_repository_impl.dart';
import 'package:santai/app/domain/usecases/fleet/list_fleet_user.dart';
import 'package:santai/app/services/auth_http_client.dart';
import 'package:santai/app/services/secure_storage_service.dart';

import '../controllers/motorcycle_detail_controller.dart';

import 'package:http/http.dart' as http;

class MotorcycleDetailBinding extends Bindings {
  @override
  // void dependencies() {
  //   Get.lazyPut<MotorcycleDetailController>(
  //     () => MotorcycleDetailController(),
  //   );
  // }

  void dependencies() {
    // Register the http client
    Get.create<http.Client>(() => http.Client());
    Get.create<SecureStorageService>(() => SecureStorageService());
    Get.create<AuthHttpClient>(() => AuthHttpClient(
        Get.find<http.Client>(), Get.find<SecureStorageService>()));

    // Register the remote data source
    Get.create<FleetRemoteDataSource>(
      () => FleetRemoteDataSourceImpl(client: Get.find<AuthHttpClient>()),
    );

    // Register the repository
    Get.create<FleetRepository>(
      () => FleetRepositoryImpl(
          remoteDataSource: Get.find<FleetRemoteDataSource>()),
    );

    // Register the use cases
    Get.create(() => UserListFleet(Get.find<FleetRepository>()));

    Get.put(MotorcycleDetailController(
      listFleetUser: Get.find<UserListFleet>(),
    ));
  }
}
