import 'package:santai/app/domain/entities/fleet/fleet_user.dart';
import 'package:santai/app/domain/entities/fleet/fleet_user_res.dart';

class FleetUserResponseModel extends FleetUserResponse {
  FleetUserResponseModel({
    required bool isSuccess,
    required FleetUserDataModel data,
    required String message,
    required String responseStatus,
    required List<dynamic> errors,
    required List<dynamic> links,
  }) : super(
          isSuccess: isSuccess,
          data: data,
          message: message,
          responseStatus: responseStatus,
          errors: errors,
          links: links,
        );

  factory FleetUserResponseModel.fromJson(Map<String, dynamic> json) {
    return FleetUserResponseModel(
      isSuccess: json['isSuccess'],
      data: FleetUserDataModel.fromJson(json['data']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
    );
  }
}

class FleetUserDataModel extends FleetUser {
  FleetUserDataModel({
    required String id,
    required String registrationNumber,
    required String vehicleType,
    required String brand,
    required String model,
    required int yearOfManufacture,
    required String chassisNumber,
    required String engineNumber,
    required String insuranceNumber,
    required bool isInsuranceValid,
    required DateTime lastInspectionDateLocal,
    required int odometerReading,
    required String fuelType,
    required String ownerName,
    required String ownerAddress,
    required String usageStatus,
    required String ownershipStatus,
    required String transmissionType,
    String? imageUrl,
  }) : super(
          id: id,
          registrationNumber: registrationNumber,
          vehicleType: vehicleType,
          brand: brand,
          model: model,
          yearOfManufacture: yearOfManufacture,
          chassisNumber: chassisNumber,
          engineNumber: engineNumber,
          insuranceNumber: insuranceNumber,
          isInsuranceValid: isInsuranceValid,
          lastInspectionDateLocal: lastInspectionDateLocal,
          odometerReading: odometerReading,
          fuelType: fuelType,
          ownerName: ownerName,
          ownerAddress: ownerAddress,
          usageStatus: usageStatus,
          ownershipStatus: ownershipStatus,
          transmissionType: transmissionType,
          imageUrl: imageUrl,
        );

  factory FleetUserDataModel.fromJson(Map<String, dynamic> json) {
    return FleetUserDataModel(
      id: json['id'],
      registrationNumber: json['registrationNumber'],
      vehicleType: json['vehicleType'],
      brand: json['brand'],
      model: json['model'],
      yearOfManufacture: json['yearOfManufacture'],
      chassisNumber: json['chassisNumber'],
      engineNumber: json['engineNumber'],
      insuranceNumber: json['insuranceNumber'],
      isInsuranceValid: json['isInsuranceValid'],
      lastInspectionDateLocal: DateTime.parse(json['lastInspectionDateLocal']),
      odometerReading: json['odometerReading'],
      fuelType: json['fuelType'],
      ownerName: json['ownerName'],
      ownerAddress: json['ownerAddress'],
      usageStatus: json['usageStatus'],
      ownershipStatus: json['ownershipStatus'],
      transmissionType: json['transmissionType'],
      imageUrl: json['imageUrl'],
    );
  }
}