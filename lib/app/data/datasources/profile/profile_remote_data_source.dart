import 'package:santai/app/config/api_config.dart';
import 'package:santai/app/data/models/profile/business_profile_user_res_model.dart';
import 'package:santai/app/data/models/profile/staff_profile_user_res_model.dart';
import 'package:santai/app/domain/enumerations/user_types_enum.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/services/auth_http_client.dart';
import 'package:santai/app/utils/http_error_handler.dart';
import 'package:santai/app/utils/int_extension_method.dart';
import 'package:santai/app/utils/session_manager.dart';

import 'package:uuid/uuid.dart';
import 'dart:convert';

import 'package:santai/app/data/models/profile/profile_user_req_model.dart';
import 'package:santai/app/data/models/profile/profile_user_res_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileUserResponseModel> insertProfileUser(ProfileUserReqModel user);
  Future<ProfileUserResponseModel?> getProfileUser(String userId);
  Future<ProfileUserResponseModel> updateProfileUser(ProfileUserReqModel user);
  Future<StaffProfileUserResModel?> getStaffProfileUser(String userId);
  Future<BusinessProfileUserResModel?> getBusinessUserProfileUser(
      String userId);
  Future<bool> updateProfilePicture(String resourceName);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final AuthHttpClient client;
  final String baseUrl;
  final SessionManager sessionManager = SessionManager();

  ProfileRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = ApiConfigAccount.baseUrl,
  });

  @override
  Future<ProfileUserResponseModel> insertProfileUser(
      ProfileUserReqModel user) async {
    const uuid = Uuid();
    final idempotencyKey = uuid.v4();

    final response = await client.post(
      Uri.parse('$baseUrl/users/regular'),
      headers: {
        'Content-Type': 'application/json',
        'X-Idempotency-Key': idempotencyKey,
      },
      body: json.encode(user.toJson()),
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      if (response.body.isEmpty) {
        throw CustomHttpException(500, 'Internal server error');
      } else {
        return ProfileUserResponseModel.fromJson(json.decode(response.body));
      }
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Your access is forbidden');
    }

    handleError(response, 'Unable to create account. Please try again shortly');
    throw Exception();
  }

  @override
  Future<ProfileUserResponseModel?> getProfileUser(String userId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/users/regular/$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      if (response.body.isEmpty) {
        return null;
      } else {
        var data = json.decode(response.body);
        var result = ProfileUserResponseModel.fromJson(data);
        return result;
      }
    }

    if (response.statusCode.isHttpResponseNotFound()) {
      return null;
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Your access is forbidden');
    }

    handleError(
        response, 'Unable to fetch user profile. Please try again shortly');
    throw Exception();
  }

  @override
  Future<bool> updateProfilePicture(String resourceName) async {
    final response = await client.patch(
      Uri.parse('$baseUrl/users/regular/image/profile'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {'imageUrl': resourceName},
      ),
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      return true;
    }

    if (response.statusCode.isHttpResponseNotFound()) {
      return false;
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Your access is forbidden');
    }

    handleError(
        response, 'Unable to update profile picture. Please try again shortly');
    throw Exception();
  }

  @override
  Future<StaffProfileUserResModel?> getStaffProfileUser(String userId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/users/business/staffs/$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      if (response.body.isEmpty) {
        return null;
      } else {
        return StaffProfileUserResModel.fromJson(json.decode(response.body));
      }
    }

    if (response.statusCode.isHttpResponseNotFound()) {
      return null;
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Your access is forbidden');
    }

    handleError(
        response, 'Unable to fetch user profile. Please try again shortly');
    throw Exception();
  }

  @override
  Future<BusinessProfileUserResModel?> getBusinessUserProfileUser(
      String userId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/users/business/$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      if (response.body.isEmpty) {
        return null;
      } else {
        return BusinessProfileUserResModel.fromJson(json.decode(response.body));
      }
    }

    if (response.statusCode.isHttpResponseNotFound()) {
      return null;
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Your access is forbidden');
    }

    handleError(
        response, 'Unable to fetch user profile. Please try again shortly');
    throw Exception();
  }

  @override
  Future<ProfileUserResponseModel> updateProfileUser(
      ProfileUserReqModel user) async {
    String userType =
        await sessionManager.getSessionBy(SessionManagerType.userType);

    if (userType.isEmpty) {
      throw CustomHttpException(401,
          "There's an issue with your account that requires attention. Please log in again to resolve it");
    }

    if (userType == UserTypesEnum.staffUser ||
        userType == UserTypesEnum.businessUser ||
        userType == UserTypesEnum.administrator) {
      throw CustomHttpException(401,
          "Can not update your account from this mobile app. Use web application instead.");
    }

    final response = await client.put(
      Uri.parse('$baseUrl/users/regular'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(user.toJson()),
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      if (response.body.isEmpty) {
        return ProfileUserResponseModel.empty(user);
      } else {
        return ProfileUserResponseModel.fromJson(json.decode(response.body));
      }
    }

    if (response.statusCode.isHttpResponseNotFound()) {
      throw CustomHttpException(
          response.statusCode, 'You account is not found');
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Your access is forbidden');
    }

    handleError(
        response, 'Unable to update your profile. Please try again shortly');
    throw Exception();
  }
}
