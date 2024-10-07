import 'package:get/get.dart';
import 'package:santai/app/data/datasources/common/common_remote_data_source.dart';
import 'package:santai/app/data/repositories/common/common_repository_impl.dart';
import 'package:santai/app/domain/repository/common/common_repository.dart';
import 'package:santai/app/domain/usecases/common/common_get_img_url_public.dart';

import '../controllers/splash_screen_controller.dart';

import 'package:http/http.dart' as http;

class SplashScreenBinding extends Bindings {
  @override
  // void dependencies() {
  //   Get.put(SplashScreenController());
  // }

  void dependencies() {
    Get.lazyPut<http.Client>(() => http.Client());

    Get.lazyPut<CommonRemoteDataSource>(
      () => CommonRemoteDataSourceImpl(client: Get.find<http.Client>()),
    );

    Get.lazyPut<CommonRepository>(
      () => CommonRepositoryImpl(
          remoteDataSource: Get.find<CommonRemoteDataSource>()),
    );

    Get.lazyPut(() => CommonGetImgUrlPublic(Get.find<CommonRepository>()));

    Get.put(SplashScreenController(
      commonGetImgUrlPublic: Get.find<CommonGetImgUrlPublic>(),
    ));
  }
}
