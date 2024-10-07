import 'package:get/get.dart';
import 'package:santai/app/data/datasources/catalog/catalog_remote_data_source.dart';

import 'package:santai/app/data/repositories/catalog/catalog_repository_impl.dart';
import 'package:santai/app/domain/repository/catalog/catalog_pository.dart';

import 'package:santai/app/domain/usecases/catalog/get_all_brand.dart';
import 'package:santai/app/domain/usecases/catalog/get_all_category.dart';
import 'package:santai/app/domain/usecases/catalog/get_all_item.dart';


import '../controllers/service_now_controller.dart';


import 'package:http/http.dart' as http;

class ServiceNowBinding extends Bindings {
  @override

  void dependencies() {

    // Register the http client
    Get.lazyPut<http.Client>(() => http.Client());

    // Register the remote data source
    Get.lazyPut<CatalogRemoteDataSource>(
      () => CatalogRemoteDataSourceImpl(client: Get.find<http.Client>()),
    );
    


    // Register the repository
    Get.lazyPut<CatalogRepository>(
      () => CatalogRepositoryImpl(remoteDataSource: Get.find<CatalogRemoteDataSource>()),
    );
    


    // Register the use cases
    Get.lazyPut(() => ItemGetAll(Get.find<CatalogRepository>()));
    Get.lazyPut(() => BrandGetAll(Get.find<CatalogRepository>()));
    Get.lazyPut(() => CategoryGetAll(Get.find<CatalogRepository>()));
   

    // Register the controller
    Get.lazyPut<ServiceNowController>(
      () => ServiceNowController(
        getAllItem: Get.find<ItemGetAll>(),
        getAllBrand: Get.find<BrandGetAll>(),
        getAllCategory: Get.find<CategoryGetAll>(),
      ),
    );
  }
}
