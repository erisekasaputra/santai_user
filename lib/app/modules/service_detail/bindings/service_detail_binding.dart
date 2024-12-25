import 'package:get/get.dart';
import 'package:santai/app/data/datasources/order/order_remote_data_source.dart';
import 'package:santai/app/data/repositories/order/order_repository_impl.dart';
import 'package:santai/app/domain/repository/order/order_repository.dart';
import 'package:santai/app/domain/usecases/order/cancel_order.dart';
import 'package:santai/app/domain/usecases/order/get_order_detail.dart';
import 'package:santai/app/services/auth_http_client.dart';

import 'package:http/http.dart' as http;
import 'package:santai/app/services/secure_storage_service.dart';
import '../controllers/service_detail_controller.dart';

class ServiceDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.create<http.Client>(() => http.Client());
    Get.create<SecureStorageService>(() => SecureStorageService());
    Get.create<AuthHttpClient>(() => AuthHttpClient(
        Get.find<http.Client>(), Get.find<SecureStorageService>()));
    Get.create<OrderRemoteDataSource>(
      () => OrderRemoteDataSourceImpl(client: Get.find<AuthHttpClient>()),
    );
    Get.create<OrderRepository>(
      () => OrderRepositoryImpl(
          remoteDataSource: Get.find<OrderRemoteDataSource>()),
    );
    Get.create(() => SingleOrderDetail(Get.find<OrderRepository>()));
    Get.create(() => CancelOrder(Get.find<OrderRepository>()));

    Get.put<ServiceDetailController>(
      ServiceDetailController(
          singleOrderDetail: Get.find<SingleOrderDetail>(),
          cancelOrder: Get.find<CancelOrder>()),
    );
  }
}
