// lib/data/data_sources/auth_remote_data_source.dart
import 'package:http/http.dart' as http;
import 'package:santai/app/config/api_config.dart';
import 'package:santai/app/data/models/authentikasi/auth_user_reg_req_model.dart';
import 'package:santai/app/data/models/authentikasi/auth_user_reg_res_model.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

import '../../../data/models/authentikasi/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> loginUser(UserModel user);
  Future<void> loginStaff(UserModel user);
  Future<UserRegisterResponseModel> registerUser(UserRegisterModel user);
  Future<void> sendOtp(OtpRequestModel request);
  Future<void> resetPassword(PasswordResetModel reset);
}

class PasswordResetModel {}

class OtpRequestModel {}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  AuthRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = ApiConfig.baseUrl,
  });

  @override
  Future<void> loginUser(UserModel user) async {
    final response = await client.post(
      Uri.parse('https://yourapi.com/api/v1/Auth/login/user'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to login user');
    }
  }

  @override
  Future<void> loginStaff(UserModel user) async {
    final response = await client.post(
      Uri.parse('https://yourapi.com/api/v1/Auth/login/user'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to login user');
    }
  }

  @override
  Future<UserRegisterResponseModel> registerUser(UserRegisterModel user) async {
    final uuid = Uuid();
    final idempotencyKey = uuid.v4();

    final response = await client.post(
      Uri.parse('$baseUrl/Auth/register'),
      headers: {
        'Content-Type': 'application/json',
        'X-Idempotency-Key': idempotencyKey,
      },
      body: json.encode(user.toJson()),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return UserRegisterResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to register user');
    }
  }




  @override
  Future<void> resetPassword(reset) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<void> sendOtp(request) {
    // TODO: implement sendOtp
    throw UnimplementedError();
  }

  // Similar methods for registerUser, sendOtp, and resetPassword
}
