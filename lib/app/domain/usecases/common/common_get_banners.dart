import 'package:santai/app/data/models/common/common_banners_res_model.dart';
import 'package:santai/app/domain/repository/common/common_repository.dart';

class CommonGetBanners {
  final CommonRepository repository;

  CommonGetBanners(this.repository);

  Future<CommonBannersResModel> call() async {
    try {
      return await repository.getBanners();
    } catch (e) {
      rethrow;
    }
  }
}
