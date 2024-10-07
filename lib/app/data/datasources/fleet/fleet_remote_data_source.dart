import 'package:http/http.dart' as http;
import 'package:santai/app/config/api_config.dart';
import 'package:santai/app/data/models/fleet/fleet_list_fleet_user_res_model.dart';
import 'package:santai/app/data/models/fleet/fleet_user_req_model.dart';
import 'package:santai/app/data/models/fleet/fleet_user_res_model.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/services/secure_storage_service.dart';

import 'package:uuid/uuid.dart';
import 'dart:convert';

abstract class FleetRemoteDataSource {
  Future<FleetUserResponseModel> insertFleetUser(FleetUserReqModel user);
  Future<FleetListFleetUserResponseModel> getListFleetUser();
}

class FleetRemoteDataSourceImpl implements FleetRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  FleetRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = ApiConfigAccount.baseUrl,
  });

  @override
  Future<FleetUserResponseModel> insertFleetUser(FleetUserReqModel user) async {
    final SecureStorageService secureStorage = SecureStorageService();
    final accessToken = await secureStorage.readSecureData('access_token');
    final userId = await secureStorage.readSecureData('user_id');

    final uuid = Uuid();
    final idempotencyKey = uuid.v4();

    final response = await client.post(
      Uri.parse('$baseUrl/users/$userId/fleet'),
      headers: {
        'Content-Type': 'application/json',
        'X-Idempotency-Key': idempotencyKey,
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode(user.toJson()),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return FleetUserResponseModel.fromJson(jsonDecode(response.body));
    } else {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw CustomHttpException(response.statusCode,
          responseBody['message'] ?? 'Failed to Insert Fleet');
    }
  }

  @override
  Future<FleetListFleetUserResponseModel> getListFleetUser() async {
    final SecureStorageService secureStorage = SecureStorageService();
    final accessToken = await secureStorage.readSecureData('access_token');
    final userId = await secureStorage.readSecureData('user_id');

    final response = await client.get(
      Uri.parse('$baseUrl/users/$userId/fleet?PageNumber=1&PageSize=10'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return FleetListFleetUserResponseModel.fromJson(
          jsonDecode(response.body));
    } else {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw CustomHttpException(response.statusCode,
          responseBody['message'] ?? 'Failed to Get Fleet');
    }
  }
}
