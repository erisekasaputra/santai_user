import 'package:get/get.dart';

import 'package:santai/app/data/datasources/order/order_remote_data_source.dart';
import 'package:santai/app/services/auth_http_client.dart';
import 'package:santai/app/services/secure_storage_service.dart';

import '../controllers/checkout_controller.dart';
import 'package:santai/app/domain/repository/order/order_repository.dart';
import 'package:santai/app/data/repositories/order/order_repository_impl.dart';
import 'package:santai/app/domain/usecases/order/create_order.dart';

import 'package:http/http.dart' as http;

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {

    // Register the http client
    Get.lazyPut<http.Client>(() => http.Client());
    Get.lazyPut<SecureStorageService>(() => SecureStorageService());
    Get.lazyPut<AuthHttpClient>(() => AuthHttpClient(Get.find<http.Client>(), Get.find<SecureStorageService>()));

    Get.lazyPut<OrderRemoteDataSource>(
      () => OrderRemoteDataSourceImpl(client: Get.find<AuthHttpClient>()),
    );

    Get.lazyPut<OrderRepository>(
      () => OrderRepositoryImpl(remoteDataSource: Get.find<OrderRemoteDataSource>()),
    );

     Get.lazyPut(() => CreateOrder(Get.find<OrderRepository>()));

       Get.lazyPut<CheckoutController>(
      () => CheckoutController(
        createOrder: Get.find<CreateOrder>(),
      ),
    );
   
  }
}
