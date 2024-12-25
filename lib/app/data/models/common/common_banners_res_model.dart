import 'package:santai/app/core/base_response.dart';
import 'package:santai/app/domain/entities/common/common_banners_dto.dart';

class CommonBannersResModel extends BaseResponse<BannersDataModel> {
  CommonBannersResModel({
    required super.isSuccess,
    required super.data,
    required super.message,
    required super.responseStatus,
    required super.errors,
    required super.links,
  });

  factory CommonBannersResModel.fromJson(Map<String, dynamic> json) {
    return CommonBannersResModel(
      isSuccess: json['isSuccess'],
      data: BannersDataModel.fromJson(json['data']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
    );
  }
}

class BannersDataModel extends CommonBannersDto {
  BannersDataModel({required super.bannersUrl});

  factory BannersDataModel.fromJson(Map<String, dynamic> json) {
    return BannersDataModel(
      bannersUrl: json['banners'] is List && json['banners'] != null
          ? List<String>.from(json['banners'])
          : [],
    );
  }
}
