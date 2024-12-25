import 'package:get/get.dart';

import 'package:santai/app/data/datasources/order/order_remote_data_source.dart';
import 'package:santai/app/services/auth_http_client.dart';
import 'package:santai/app/services/secure_storage_service.dart';

import '../controllers/checkout_controller.dart';
import 'package:santai/app/domain/repository/order/order_repository.dart';
import 'package:santai/app/data/repositories/order/order_repository_impl.dart';
import 'package:santai/app/domain/usecases/order/create_order.dart';
import 'package:santai/app/domain/usecases/order/calculation_order.dart';
import 'package:santai/app/domain/usecases/order/cek_coupon.dart';
import 'package:http/http.dart' as http;

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    // Register the http client
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

    Get.create(() => CreateOrder(Get.find<OrderRepository>()));
    Get.create(() => CalculateOrder(Get.find<OrderRepository>()));
    Get.create(() => CheckCoupon(Get.find<OrderRepository>()));

    Get.put<CheckoutController>(CheckoutController(
      createOrder: Get.find<CreateOrder>(),
      calculationOrder: Get.find<CalculateOrder>(),
      checkCoupon: Get.find<CheckCoupon>(),
    ));
  }
}
