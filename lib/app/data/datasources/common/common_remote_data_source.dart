import 'package:http/http.dart' as http;
import 'package:santai/app/config/api_config.dart';
import 'package:santai/app/data/models/common/common_url_image_public_res.dart';
// import 'package:santai/app/services/secure_storage_service.dart';

import 'dart:convert';

abstract class CommonRemoteDataSource {
  Future<CommonUrlImagePublicResponseModel> getUrlImagePublic();
}

class CommonRemoteDataSourceImpl implements CommonRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  CommonRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = ApiConfigUploadImage.baseUrl,
  });

  @override
  Future<CommonUrlImagePublicResponseModel> getUrlImagePublic() async {
    final response = await client.get(
      Uri.parse('$baseUrl/Files/images/public/url'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return CommonUrlImagePublicResponseModel.fromJson(
          jsonDecode(response.body));
    } else {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw Exception(responseBody['message']);
    }
  }
}
