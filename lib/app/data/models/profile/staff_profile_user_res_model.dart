import 'package:santai/app/core/base_response.dart';
import 'package:santai/app/domain/entities/profile/business_profile_user_res.dart';

class StaffProfileUserResModel
    extends BaseResponse<StaffProfileUserResDataModel> {
  StaffProfileUserResModel({
    required super.isSuccess,
    required super.data,
    required super.message,
    required super.responseStatus,
    required super.errors,
    required super.links,
  });

  factory StaffProfileUserResModel.fromJson(Map<String, dynamic> json) {
    return StaffProfileUserResModel(
      isSuccess: json['isSuccess'],
      data: StaffProfileUserResDataModel.fromJson(json['data']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
    );
  }
}

class StaffProfileUserResDataModel extends StaffResponseDto {
  StaffProfileUserResDataModel({
    required super.id,
    super.email,
    super.phoneNumber,
    required super.name,
    required super.address,
    required super.timeZoneId,
    required super.fleets,
  });

  factory StaffProfileUserResDataModel.fromJson(Map<String, dynamic> json) {
    return StaffProfileUserResDataModel(
      id: json['id'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      name: json['name'],
      address: AddressResDataModel.fromJson(json['address']),
      timeZoneId: json['timeZoneId'],
      fleets: (json['fleets'] as List)
          .map((item) => FleetResponseDataModel.fromJson(item))
          .toList(),
    );
  }
}

// FleetResponseModel - Model class that converts from JSON
class FleetResponseDataModel extends FleetResponseDto {
  FleetResponseDataModel({
    required super.id,
    required super.registrationNumber,
    required super.vehicleType,
    required super.brand,
    required super.model,
    required super.yearOfManufacture,
    required super.chassisNumber,
    required super.engineNumber,
    required super.insuranceNumber,
    required super.isInsuranceValid,
    required super.lastInspectionDateLocal,
    required super.odometerReading,
    required super.fuelType,
    required super.ownerName,
    required super.ownerAddress,
    required super.usageStatus,
    required super.ownershipStatus,
    required super.transmissionType,
    super.imageUrl,
  });

  factory FleetResponseDataModel.fromJson(Map<String, dynamic> json) {
    return FleetResponseDataModel(
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

// AddressResponseModel - Model class that converts from JSON
class AddressResDataModel extends AddressResponseDto {
  AddressResDataModel({
    required super.addressLine1,
    required super.city,
    required super.state,
    required super.postalCode,
    required super.country,
    super.addressLine2,
    super.addressLine3,
  });

  factory AddressResDataModel.fromJson(Map<String, dynamic> json) {
    return AddressResDataModel(
      addressLine1: json['addressLine1'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postalCode'],
      country: json['country'],
      addressLine2: json['addressLine2'],
      addressLine3: json['addressLine3'],
    );
  }
}
