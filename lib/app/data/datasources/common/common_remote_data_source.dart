import 'package:http/http.dart' as http;
import 'package:santai/app/config/api_config.dart';
import 'package:santai/app/data/models/common/common_banners_res_model.dart';
import 'package:santai/app/data/models/common/common_url_image_public_res.dart';
import 'dart:convert';

import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/utils/int_extension_method.dart';

abstract class CommonRemoteDataSource {
  Future<CommonUrlImagePublicResModel> getUrlImagePublic();
  Future<CommonBannersResModel> getBanners();
}

class CommonRemoteDataSourceImpl implements CommonRemoteDataSource {
  final http.Client client;
  final String baseUrl;
  final String masterUrl;

  CommonRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = ApiConfigUploadImage.baseUrl,
    this.masterUrl = ApiConfigMasterUrl.baseUrl,
  });

  @override
  Future<CommonUrlImagePublicResModel> getUrlImagePublic() async {
    final url = '$baseUrl/Files/images/public/url';
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      if (response.body.isEmpty) {
        throw CustomHttpException(response.statusCode, 'Internal server error');
      }
      return CommonUrlImagePublicResModel.fromJson(
        jsonDecode(response.body),
      );
    }

    if (response.statusCode.isHttpResponseInternalServerError()) {
      throw CustomHttpException(response.statusCode, 'Internal server error');
    }

    if (response.statusCode.isHttpResponseNotFound()) {
      throw CustomHttpException(
          response.statusCode, 'Oops, your data is not found');
    }

    throw CustomHttpException(
        response.statusCode, 'An unexpected error has occured');
  }

  @override
  Future<CommonBannersResModel> getBanners() async {
    final url = '$masterUrl/banners';
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      if (response.body.isEmpty) {
        throw CustomHttpException(response.statusCode, 'Internal server error');
      }
      var data = jsonDecode(response.body);
      return CommonBannersResModel.fromJson(data);
    }

    if (response.statusCode.isHttpResponseInternalServerError()) {
      throw CustomHttpException(response.statusCode, 'Internal server error');
    }

    if (response.statusCode.isHttpResponseNotFound()) {
      throw CustomHttpException(response.statusCode, 'Oops, data is not found');
    }

    throw CustomHttpException(
        response.statusCode, 'An unexpected error has occured');
  }
}
