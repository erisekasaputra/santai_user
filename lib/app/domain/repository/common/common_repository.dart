import 'package:santai/app/data/models/common/common_banners_res_model.dart';
import 'package:santai/app/domain/entities/common/common_url_image_public_res.dart';

abstract class CommonRepository {
  Future<CommonUrlImagePublicRes> getUrlImagePublic();
  Future<CommonBannersResModel> getBanners();
}
