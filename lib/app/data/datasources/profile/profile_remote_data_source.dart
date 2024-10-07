import 'package:http/http.dart' as http;
import 'package:santai/app/config/api_config.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/services/secure_storage_service.dart';

import 'package:uuid/uuid.dart';
import 'dart:convert';

import 'package:santai/app/data/models/profile/profile_user_req_model.dart';
import 'package:santai/app/data/models/profile/profile_user_res_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileUserResponseModel> insertProfileUser(ProfileUserReqModel user);
  Future<ProfileUserResponseModel> getProfileUser();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ProfileRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = ApiConfigAccount.baseUrl,
  });

  @override
  Future<ProfileUserResponseModel> insertProfileUser(ProfileUserReqModel user) async {
    final SecureStorageService secureStorage = SecureStorageService();
    final accessToken = await secureStorage.readSecureData('access_token');
    final uuid = Uuid();
    final idempotencyKey = uuid.v4();

    final response = await client.post(
      Uri.parse('$baseUrl/users/regular'),
      headers: {
        'Content-Type': 'application/json',
        'X-Idempotency-Key': idempotencyKey,
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode(user.toJson()),  
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ProfileUserResponseModel.fromJson(jsonDecode(response.body));
    } else {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw CustomHttpException(response.statusCode, responseBody['message'] ?? 'Failed to Insert Profile User');
    }
  }

  @override
  Future<ProfileUserResponseModel> getProfileUser() async {
    final SecureStorageService secureStorage = SecureStorageService();
    final accessToken = await secureStorage.readSecureData('access_token');

    final response = await client.get(
      Uri.parse('$baseUrl/users/regular'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ProfileUserResponseModel.fromJson(jsonDecode(response.body));
    } else {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw CustomHttpException(response.statusCode, responseBody['message'] ?? 'Failed to Get Profile User');
    }
  }
}
