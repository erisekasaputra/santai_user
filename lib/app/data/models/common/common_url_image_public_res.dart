import 'package:santai/app/domain/entities/common/common_url_image_public_res.dart';

class CommonUrlImagePublicResponseModel extends CommonUrlImagePublicRes {
  CommonUrlImagePublicResponseModel({
    required String url,
  }) : super(
          url: url,
        );

  factory CommonUrlImagePublicResponseModel.fromJson(Map<String, dynamic> json) {
    return CommonUrlImagePublicResponseModel(
      url: json['url'],
    );
  }
}
  