import 'package:get/get.dart';
import 'package:santai/app/data/datasources/catalog/catalog_remote_data_source.dart';

import 'package:santai/app/data/repositories/catalog/catalog_repository_impl.dart';
import 'package:santai/app/domain/repository/catalog/catalog_pository.dart';

import 'package:santai/app/domain/usecases/catalog/get_all_brand.dart';
import 'package:santai/app/domain/usecases/catalog/get_all_category.dart';
import 'package:santai/app/domain/usecases/catalog/get_all_item.dart';
import 'package:santai/app/services/auth_http_client.dart';
import 'package:santai/app/services/secure_storage_service.dart';

import '../controllers/service_now_controller.dart';

import 'package:http/http.dart' as http;

class ServiceNowBinding extends Bindings {
  @override
  void dependencies() {
    // Register the http client
    Get.create<http.Client>(() => http.Client());
    Get.create<SecureStorageService>(() => SecureStorageService());
    Get.create<AuthHttpClient>(() => AuthHttpClient(
        Get.find<http.Client>(), Get.find<SecureStorageService>()));

    // Register the remote data source
    Get.create<CatalogRemoteDataSource>(
      () => CatalogRemoteDataSourceImpl(client: Get.find<AuthHttpClient>()),
    );

    // Register the repository
    Get.create<CatalogRepository>(
      () => CatalogRepositoryImpl(
          remoteDataSource: Get.find<CatalogRemoteDataSource>()),
    );

    // Register the use cases
    Get.create(() => ItemGetAll(Get.find<CatalogRepository>()));
    Get.create(() => BrandGetAll(Get.find<CatalogRepository>()));
    Get.create(() => CategoryGetAll(Get.find<CatalogRepository>()));

    // Register the controller
    Get.put<ServiceNowController>(
      ServiceNowController(
        getAllItem: Get.find<ItemGetAll>(),
        getAllBrand: Get.find<BrandGetAll>(),
        getAllCategory: Get.find<CategoryGetAll>(),
      ),
    );
  }
}
