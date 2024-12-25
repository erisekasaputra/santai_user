// The parent model extending from the domain class.
import 'package:santai/app/core/base_response.dart';
import 'package:santai/app/domain/entities/profile/business_profile_user_res.dart';
import 'package:santai/app/domain/enumerations/loyalty_tier.dart';

class BusinessProfileUserResModel
    extends BaseResponse<BusinessProfileUserResDataModel> {
  BusinessProfileUserResModel({
    required super.isSuccess,
    required super.data,
    required super.message,
    required super.responseStatus,
    required super.errors,
    required super.links,
  });

  factory BusinessProfileUserResModel.fromJson(Map<String, dynamic> json) {
    return BusinessProfileUserResModel(
      isSuccess: json['isSuccess'],
      data: BusinessProfileUserResDataModel.fromJson(json['data']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
    );
  }
}

class BusinessProfileUserResDataModel extends BusinessUserResponseDto {
  BusinessProfileUserResDataModel({
    required super.userId,
    required super.email,
    required super.phoneNumber,
    required super.timeZoneId,
    required AddressResponseModel super.address,
    required super.businessName,
    required super.contactPerson,
    required super.taxId,
    required super.websiteUrl,
    required super.businessDescription,
    required LoyaltyProgramResponseModel? super.loyalty,
    required ReferralProgramResponseModel? super.referral,
    required List<FleetResponseModel> super.fleets,
    required List<BusinessLicenseResponseModel>? super.businessLicenses,
    required List<StaffResponseModel>? super.staffs,
  });

  factory BusinessProfileUserResDataModel.fromJson(Map<String, dynamic> json) {
    return BusinessProfileUserResDataModel(
      userId: json['userId'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      timeZoneId: json['timeZoneId'],
      address: AddressResponseModel.fromJson(json['address']),
      businessName: json['businessName'],
      contactPerson: json['contactPerson'],
      taxId: json['taxId'],
      websiteUrl: json['websiteUrl'],
      businessDescription: json['businessDescription'],
      loyalty: json['loyalty'] != null
          ? LoyaltyProgramResponseModel.fromJson(json['loyalty'])
          : null,
      referral: json['referral'] != null
          ? ReferralProgramResponseModel.fromJson(json['referral'])
          : null,
      fleets: (json['fleets'] as List)
          .map((item) => FleetResponseModel.fromJson(item))
          .toList(),
      businessLicenses: json['businessLicenses'] != null
          ? (json['businessLicenses'] as List)
              .map((item) => BusinessLicenseResponseModel.fromJson(item))
              .toList()
          : null,
      staffs: json['staffs'] != null
          ? (json['staffs'] as List)
              .map((item) => StaffResponseModel.fromJson(item))
              .toList()
          : null,
    );
  }
}

class AddressResponseModel extends AddressResponseDto {
  AddressResponseModel({
    required super.addressLine1,
    required super.city,
    required super.state,
    required super.postalCode,
    required super.country,
    super.addressLine2,
    super.addressLine3,
  });

  factory AddressResponseModel.fromJson(Map<String, dynamic> json) {
    return AddressResponseModel(
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

class LoyaltyProgramResponseModel extends LoyaltyProgramResponseDto {
  LoyaltyProgramResponseModel({
    required super.userId,
    required super.points,
    required super.tier,
  });

  factory LoyaltyProgramResponseModel.fromJson(Map<String, dynamic> json) {
    return LoyaltyProgramResponseModel(
      userId: json['userId'],
      points: json['points'],
      tier: LoyaltyTier.values
          .firstWhere((e) => e.toString().split('.').last == json['tier']),
    );
  }
}

class ReferralProgramResponseModel extends ReferralProgramResponseDto {
  ReferralProgramResponseModel({
    required super.referralCode,
    required super.rewardPoint,
  });

  factory ReferralProgramResponseModel.fromJson(Map<String, dynamic> json) {
    return ReferralProgramResponseModel(
      referralCode: json['referralCode'],
      rewardPoint: json['rewardPoint'],
    );
  }
}

class FleetResponseModel extends FleetResponseDto {
  FleetResponseModel({
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

  factory FleetResponseModel.fromJson(Map<String, dynamic> json) {
    return FleetResponseModel(
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

class BusinessLicenseResponseModel extends BusinessLicenseResponseDto {
  BusinessLicenseResponseModel({
    required super.id,
    required super.licenseNumber,
    required super.name,
    required super.description,
  });

  factory BusinessLicenseResponseModel.fromJson(Map<String, dynamic> json) {
    return BusinessLicenseResponseModel(
      id: json['id'],
      licenseNumber: json['licenseNumber'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class StaffResponseModel extends StaffResponseDto {
  StaffResponseModel({
    required super.id,
    required super.name,
    required super.address,
    required super.timeZoneId,
    required super.fleets,
    super.email,
    super.phoneNumber,
  });

  factory StaffResponseModel.fromJson(Map<String, dynamic> json) {
    return StaffResponseModel(
      id: json['id'],
      name: json['name'],
      address: AddressResponseModel.fromJson(json['address']),
      timeZoneId: json['timeZoneId'],
      fleets: (json['fleets'] as List)
          .map((item) => FleetResponseModel.fromJson(item))
          .toList(),
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
