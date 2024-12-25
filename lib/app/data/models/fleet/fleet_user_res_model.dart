import 'package:santai/app/domain/entities/fleet/fleet_user.dart';
import 'package:santai/app/domain/entities/fleet/fleet_user_res.dart';

class FleetUserResponseModel extends FleetUserResponse {
  FleetUserResponseModel({
    required super.isSuccess,
    required FleetUserDataModel super.data,
    required super.message,
    required super.responseStatus,
    required super.errors,
    required super.links,
  });

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
    String? registrationNumber,
    String? vehicleType,
    required String brand,
    required String model,
    int? yearOfManufacture,
    String? chassisNumber,
    String? engineNumber,
    String? insuranceNumber,
    bool? isInsuranceValid,
    DateTime? lastInspectionDateLocal,
    int? odometerReading,
    String? fuelType,
    String? ownerName,
    String? ownerAddress,
    String? usageStatus,
    String? ownershipStatus,
    String? transmissionType,
    required String imageUrl,
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
      lastInspectionDateLocal: json['lastInspectionDateLocal'] == null
          ? null
          : DateTime.parse(json['lastInspectionDateLocal']),
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
