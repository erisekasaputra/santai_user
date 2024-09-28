import 'package:http/http.dart' as http;
import 'package:santai/app/config/api_config.dart';
import 'package:santai/app/services/secure_storage_service.dart';

import 'package:uuid/uuid.dart';
import 'dart:convert';

import 'package:santai/app/data/models/profile/profile_user_req_model.dart';
import 'package:santai/app/data/models/profile/profile_user_res_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileUserResponseModel> insertProfileUser(ProfileUserReqModel user);
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
    final SecureStorageService _secureStorage = SecureStorageService();
    final accessToken = await _secureStorage.readSecureData('access_token');
    final uuid = Uuid();
    final idempotencyKey = uuid.v4();

    final response = await client.post(
      Uri.parse('$ApiConfigAccount/users/regular'),
      headers: {
        'Content-Type': 'application/json',
        'X-Idempotency-Key': idempotencyKey,
        'Authorization': 'Bearer $accessToken',
      },
      body: user.toJson(),  
    );

    if (response.statusCode == 200) {
      return ProfileUserResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to insert profile user');
    }
  }
}