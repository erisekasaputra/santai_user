import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';
import 'package:santai/app/data/datasources/fleet/fleet_remote_data_source.dart';
import 'package:santai/app/data/repositories/fleet/fleet_repository_impl.dart';
import 'package:santai/app/domain/repository/fleet/fleet_repository.dart';

import 'package:http/http.dart' as http;
import 'package:santai/app/domain/usecases/fleet/list_fleet_user.dart';
class DashboardBinding extends Bindings {
  @override
  // void dependencies() {
  //   Get.lazyPut<DashboardController>(
  //     () => DashboardController(),
  //   );
  // }

  void dependencies() {
    // Register the http client
    Get.lazyPut<http.Client>(() => http.Client());

    // Register the remote data source
    Get.lazyPut<FleetRemoteDataSource>(
      () => FleetRemoteDataSourceImpl(client: Get.find<http.Client>()),
    );

     // Register the repository
    Get.lazyPut<FleetRepository>(
      () => FleetRepositoryImpl(remoteDataSource: Get.find<FleetRemoteDataSource>()),
    );

     // Register the use cases
    Get.lazyPut(() => UserListFleet(Get.find<FleetRepository>()));

    Get.lazyPut(() => DashboardController(
      listFleetUser: Get.find<UserListFleet>(),
    ));
  }
}
