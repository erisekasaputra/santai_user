// BusinessUserResponseDto Entity
import 'package:santai/app/domain/enumerations/loyalty_tier.dart';

class BusinessUserResponseDto {
  final String userId;
  final String? email;
  final String? phoneNumber;
  final String timeZoneId;
  final AddressResponseDto address;
  final String businessName;
  final String contactPerson;
  final String? taxId;
  final String? websiteUrl;
  final String? businessDescription;
  final LoyaltyProgramResponseDto? loyalty;
  final ReferralProgramResponseDto? referral;
  final List<FleetResponseDto> fleets;
  final List<BusinessLicenseResponseDto>? businessLicenses;
  final List<StaffResponseDto>? staffs;

  BusinessUserResponseDto({
    required this.userId,
    this.email,
    this.phoneNumber,
    required this.timeZoneId,
    required this.address,
    required this.businessName,
    required this.contactPerson,
    this.taxId,
    this.websiteUrl,
    this.businessDescription,
    this.loyalty,
    this.referral,
    required this.fleets,
    this.businessLicenses,
    this.staffs,
  });
}

// AddressResponseDto Entity
class AddressResponseDto {
  final String addressLine1;
  final String? addressLine2;
  final String? addressLine3;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  AddressResponseDto({
    required this.addressLine1,
    this.addressLine2,
    this.addressLine3,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });
}

// LoyaltyProgramResponseDto Entity
class LoyaltyProgramResponseDto {
  final String userId;
  final int points;
  final LoyaltyTier tier;

  LoyaltyProgramResponseDto({
    required this.userId,
    required this.points,
    required this.tier,
  });
}

// ReferralProgramResponseDto Entity
class ReferralProgramResponseDto {
  final String? referralCode;
  final int? rewardPoint;

  ReferralProgramResponseDto({
    this.referralCode,
    this.rewardPoint,
  });
}

// FleetResponseDto Entity
class FleetResponseDto {
  final String id;
  final String registrationNumber;
  final String vehicleType;
  final String brand;
  final String model;
  final int yearOfManufacture;
  final String chassisNumber;
  final String engineNumber;
  final String insuranceNumber;
  final bool isInsuranceValid;
  final DateTime lastInspectionDateLocal;
  final int odometerReading;
  final String fuelType;
  final String ownerName;
  final String ownerAddress;
  final String usageStatus;
  final String ownershipStatus;
  final String transmissionType;
  final String? imageUrl;

  FleetResponseDto({
    required this.id,
    required this.registrationNumber,
    required this.vehicleType,
    required this.brand,
    required this.model,
    required this.yearOfManufacture,
    required this.chassisNumber,
    required this.engineNumber,
    required this.insuranceNumber,
    required this.isInsuranceValid,
    required this.lastInspectionDateLocal,
    required this.odometerReading,
    required this.fuelType,
    required this.ownerName,
    required this.ownerAddress,
    required this.usageStatus,
    required this.ownershipStatus,
    required this.transmissionType,
    this.imageUrl,
  });
}

// BusinessLicenseResponseDto Entity
class BusinessLicenseResponseDto {
  final String id;
  final String licenseNumber;
  final String name;
  final String description;

  BusinessLicenseResponseDto({
    required this.id,
    required this.licenseNumber,
    required this.name,
    required this.description,
  });
}

// StaffResponseDto Entity
class StaffResponseDto {
  final String id;
  final String? email;
  final String? phoneNumber;
  final String name;
  final AddressResponseDto address;
  final String timeZoneId;
  final List<FleetResponseDto> fleets;

  StaffResponseDto({
    required this.id,
    this.email,
    this.phoneNumber,
    required this.name,
    required this.address,
    required this.timeZoneId,
    required this.fleets,
  });
}
