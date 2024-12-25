import 'package:get/get.dart';
import 'package:santai/app/data/datasources/common/common_remote_data_source.dart';
import 'package:santai/app/data/datasources/order/order_remote_data_source.dart';
import 'package:santai/app/data/datasources/profile/profile_remote_data_source.dart';
import 'package:santai/app/data/repositories/common/common_repository_impl.dart';
import 'package:santai/app/data/repositories/order/order_repository_impl.dart';
import 'package:santai/app/data/repositories/profile/profile_repository_impl.dart';
import 'package:santai/app/domain/repository/common/common_repository.dart';
import 'package:santai/app/domain/repository/order/order_repository.dart';
import 'package:santai/app/domain/repository/profile/profile_repository.dart';
import 'package:santai/app/domain/usecases/common/common_get_banners.dart';
import 'package:santai/app/domain/usecases/common/common_get_img_url_public.dart';
import 'package:santai/app/domain/usecases/order/get_active_orders.dart';
import 'package:santai/app/domain/usecases/profile/get_business_profile_user.dart';
import 'package:santai/app/domain/usecases/profile/get_profile_user.dart';
import 'package:santai/app/domain/usecases/profile/get_staff_profile_user.dart';
import 'package:santai/app/services/auth_http_client.dart';
import 'package:santai/app/services/secure_storage_service.dart';

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
    Get.create<http.Client>(() => http.Client());
    Get.create<SecureStorageService>(() => SecureStorageService());
    Get.create<AuthHttpClient>(() => AuthHttpClient(
        Get.find<http.Client>(), Get.find<SecureStorageService>()));

    Get.create<FleetRemoteDataSource>(
      () => FleetRemoteDataSourceImpl(client: Get.find<AuthHttpClient>()),
    );
    Get.create<OrderRemoteDataSource>(
      () => OrderRemoteDataSourceImpl(client: Get.find<AuthHttpClient>()),
    );
    Get.create<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(client: Get.find<AuthHttpClient>()),
    );
    Get.create<CommonRemoteDataSource>(
      () => CommonRemoteDataSourceImpl(client: Get.find<http.Client>()),
    );

    Get.create<FleetRepository>(
      () => FleetRepositoryImpl(
          remoteDataSource: Get.find<FleetRemoteDataSource>()),
    );
    Get.create<OrderRepository>(
      () => OrderRepositoryImpl(
          remoteDataSource: Get.find<OrderRemoteDataSource>()),
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
    Get.create(() => CommonGetBanners(Get.find<CommonRepository>()));
    Get.create(() => UserListFleet(Get.find<FleetRepository>()));
    Get.create(() => ListActiveOrders(Get.find<OrderRepository>()));
    Get.create(() => UserGetProfile(Get.find<ProfileRepository>()));
    Get.create(() => GetBusinessProfileUser(Get.find<ProfileRepository>()));
    Get.create(() => GetStaffProfileUser(Get.find<ProfileRepository>()));

    Get.put<DashboardController>(
      DashboardController(
        listFleetUser: Get.find<UserListFleet>(),
        listActiveOrders: Get.find<ListActiveOrders>(),
        userGetProfile: Get.find<UserGetProfile>(),
        getBusinessUser: Get.find<GetBusinessProfileUser>(),
        getStaffUser: Get.find<GetStaffProfileUser>(),
        commonGetImgUrlPublic: Get.find<CommonGetImgUrlPublic>(),
        commonGetBanners: Get.find<CommonGetBanners>(),
      ),
    );
  }
}
