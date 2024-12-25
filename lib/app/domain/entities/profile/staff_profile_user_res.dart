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
