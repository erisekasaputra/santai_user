import 'package:santai/app/config/api_config.dart';
import 'package:santai/app/data/models/fleet/fleet_list_fleet_user_res_model.dart';
import 'package:santai/app/data/models/fleet/fleet_user_req_model.dart';
import 'package:santai/app/data/models/fleet/fleet_user_res_model.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/services/auth_http_client.dart';
import 'package:santai/app/utils/http_error_handler.dart';
import 'package:santai/app/utils/int_extension_method.dart';
import 'package:santai/app/utils/session_manager.dart';

import 'package:uuid/uuid.dart';
import 'dart:convert';

abstract class FleetRemoteDataSource {
  Future<FleetUserResponseModel> insertFleetUser(FleetUserReqModel user);
  Future<FleetListFleetUserResponseModel> getListFleetUser();
  Future<FleetUserResponseModel> getFleetUserById(String fleetId);
  Future<FleetUserResponseModel> updateFleetUser(
      FleetUserReqModel user, String fleetId);
}

class FleetRemoteDataSourceImpl implements FleetRemoteDataSource {
  final AuthHttpClient client;
  final String baseUrl;
  final SessionManager sessionManager = SessionManager();

  FleetRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = ApiConfigAccount.baseUrl,
  });

  @override
  Future<FleetUserResponseModel> insertFleetUser(FleetUserReqModel user) async {
    final userId = await sessionManager.getSessionBy(SessionManagerType.userId);

    const uuid = Uuid();
    final idempotencyKey = uuid.v4();

    final response = await client.post(
      Uri.parse('$baseUrl/users/$userId/fleet'),
      headers: {
        'Content-Type': 'application/json',
        'X-Idempotency-Key': idempotencyKey,
      },
      body: json.encode(user.toJson()),
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      if (response.body.isEmpty) {
        throw CustomHttpException(500, 'Incosistent state');
      }
      return FleetUserResponseModel.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Your access is forbidden');
    }

    handleError(response, 'Unable to create fleet. Please try again shortly');
    throw Exception();
  }

  @override
  Future<FleetListFleetUserResponseModel> getListFleetUser() async {
    final userId = await sessionManager.getSessionBy(SessionManagerType.userId);

    final response = await client.get(
      Uri.parse('$baseUrl/users/$userId/fleet?PageNumber=1&PageSize=20'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      return FleetListFleetUserResponseModel.fromJson(
          jsonDecode(response.body));
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Your access is forbidden');
    }

    handleError(response, 'Can not fetch fleet data. Please try again shortly');
    throw Exception();
  }

  @override
  Future<FleetUserResponseModel> getFleetUserById(String fleetId) async {
    final userId = await sessionManager.getSessionBy(SessionManagerType.userId);

    final response = await client.get(
      Uri.parse('$baseUrl/users/$userId/fleet/$fleetId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      return FleetUserResponseModel.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Your access is forbidden');
    }

    handleError(response, 'Can not fetch fleet data. Please try again shortly');
    throw Exception();
  }

  @override
  Future<FleetUserResponseModel> updateFleetUser(
      FleetUserReqModel user, String fleetId) async {
    final userId = await sessionManager.getSessionBy(SessionManagerType.userId);

    final response = await client.put(
      Uri.parse('$baseUrl/users/$userId/fleet/$fleetId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(user.toJson()),
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      if (response.body.isEmpty) {
        // Handle empty response body
        return FleetUserResponseModel(
          isSuccess: true,
          data: FleetUserDataModel(
            id: fleetId,
            registrationNumber: user.registrationNumber,
            vehicleType: user.vehicleType,
            brand: user.brand,
            model: user.model,
            yearOfManufacture: user.yearOfManufacture,
            chassisNumber: user.chassisNumber,
            engineNumber: user.engineNumber,
            insuranceNumber: user.insuranceNumber,
            isInsuranceValid: user.isInsuranceValid,
            lastInspectionDateLocal: user.lastInspectionDateLocal,
            odometerReading: user.odometerReading,
            fuelType: user.fuelType,
            ownerName: user.ownerName,
            ownerAddress: user.ownerAddress,
            usageStatus: user.usageStatus,
            ownershipStatus: user.ownershipStatus,
            transmissionType: user.transmissionType,
            imageUrl: user.imageUrl,
          ),
          message: 'Fleet updated successfully and is now up to date',
          responseStatus: 'Success',
          errors: [],
          links: [],
        );
      }
      return FleetUserResponseModel.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Your access is forbidden');
    }

    handleError(
        response, 'Unable to udpate fleet data. Please try again shortly');
    throw Exception();
  }
}
