// lib/data/data_sources/auth_remote_data_source.dart
import 'package:http/http.dart' as http;
import 'package:santai/app/config/api_config.dart';

import 'package:santai/app/data/models/authentikasi/auth_otp_reg_ver_req_model.dart';
import 'package:santai/app/data/models/authentikasi/auth_otp_reg_ver_res_model.dart';

import 'package:santai/app/data/models/authentikasi/auth_otp_req_req_model.dart';
import 'package:santai/app/data/models/authentikasi/auth_otp_req_res_model.dart';
import 'package:santai/app/data/models/authentikasi/auth_sign-in_google_req_model.dart';
import 'package:santai/app/data/models/authentikasi/auth_sign-in_google_res_model.dart';
import 'package:santai/app/data/models/authentikasi/auth_sign-out_model.dart';

import 'package:santai/app/data/models/authentikasi/auth_user_reg_req_model.dart';
import 'package:santai/app/data/models/authentikasi/auth_user_reg_res_model.dart';
import 'package:santai/app/data/models/authentikasi/auth_verify_login_req_model.dart';
import 'package:santai/app/data/models/authentikasi/auth_verify_login_res_model.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';

import 'package:uuid/uuid.dart';
import 'dart:convert';

import '../../../data/models/authentikasi/auth_sign-in_res_model.dart';
import '../../../data/models/authentikasi/auth_sign-in_req_model.dart';

import '../../../data/models/authentikasi/auth_sign-in_staff_req_model.dart';
import '../../../data/models/authentikasi/auth_sign-in_staff_res_model.dart';

abstract class AuthRemoteDataSource {
  Future<SigninUserResponseModel> signinUser(SigninUserModel user);
  Future<SigninStaffResponseModel> signinStaff(SigninStaffModel user);

  Future<UserRegisterResponseModel> registerUser(UserRegisterModel user);
  Future<SigninGoogleResponseModel> signinGoogle(SigninGoogleModel user);

  Future<OtpRequestResponseModel> sendOtp(OtpRequestModel request);
  Future<OtpRegisterVerifyResponseModel> otpRegisterVerify(
      OtpRegisterVerifyModel request);

  Future<VerifyLoginResponseModel> verifyLogin(VerifyLoginModel request);

  Future<void> signOut(SignOutModel request);

  Future<void> resetPassword(PasswordResetModel reset);
}

class PasswordResetModel {}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  AuthRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = ApiConfig.baseUrl,
  });

  @override
  Future<SigninUserResponseModel> signinUser(SigninUserModel request) async {
    final response = await client
        .post(
          Uri.parse('$baseUrl/Auth/signin-user'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(request.toJson()),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return SigninUserResponseModel.fromJson(json.decode(response.body));
    } else {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw CustomHttpException(
          response.statusCode, responseBody['message'] ?? 'Failed to Login');
    }
  }

  @override
  Future<SigninStaffResponseModel> signinStaff(SigninStaffModel request) async {
    final response = await client.post(
      Uri.parse('$baseUrl/Auth/signin-staff'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return SigninStaffResponseModel.fromJson(json.decode(response.body));
    } else {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw CustomHttpException(
          response.statusCode, responseBody['message'] ?? 'Failed to Login');
    }
  }

  @override
  Future<SigninGoogleResponseModel> signinGoogle(
      SigninGoogleModel request) async {
    final response = await client.post(
      Uri.parse('$baseUrl/Auth/signin-google'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return SigninGoogleResponseModel.fromJson(json.decode(response.body));
    } else {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw CustomHttpException(
          response.statusCode, responseBody['message'] ?? 'Failed to Login');
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
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw CustomHttpException(
          response.statusCode, responseBody['message'] ?? 'Failed to Login');
    }
  }

  @override
  Future<OtpRequestResponseModel> sendOtp(OtpRequestModel request) async {
    final response = await client.post(
      Uri.parse('$baseUrl/Auth/otp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return OtpRequestResponseModel.fromJson(json.decode(response.body));
    } else {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw CustomHttpException(
          response.statusCode, responseBody['message'] ?? 'Failed to Login');
    }
  }

  @override
  Future<OtpRegisterVerifyResponseModel> otpRegisterVerify(
      OtpRegisterVerifyModel request) async {
    final response = await client.patch(
      Uri.parse('$baseUrl/Auth/verify-phone-number'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return OtpRegisterVerifyResponseModel.defaultSuccess();
    } else {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw CustomHttpException(
          response.statusCode, responseBody['message'] ?? 'Failed to Login');
    }
  }

  @override
  Future<VerifyLoginResponseModel> verifyLogin(VerifyLoginModel request) async {
    final response = await client.patch(
      Uri.parse('$baseUrl/Auth/verify-login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return VerifyLoginResponseModel.fromJson(json.decode(response.body));
    } else {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw CustomHttpException(
          response.statusCode, responseBody['message'] ?? 'Failed to Login');
    }
  }

  @override
  Future<void> signOut(SignOutModel request) async {
    final response = await client.post(
      Uri.parse('$baseUrl/Auth/signout'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    } else {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw CustomHttpException(
      response.statusCode, responseBody['message'] ?? 'Failed to Login');
    }
  }

  @override
  Future<void> resetPassword(reset) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  // Similar methods for registerUser, sendOtp, and resetPassword
}
