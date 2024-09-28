class ProfileUser {
  final String timeZoneId;
  final String? referralCode;
  final ProfileAddress address;
  final ProfilePersonalInfo personalInfo;

  ProfileUser({
    required this.timeZoneId,
    this.referralCode,
    required this.address,
    required this.personalInfo,
  });
}

class ProfileAddress {
  final String addressLine1;
  final String? addressLine2;
  final String? addressLine3;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  ProfileAddress({
    required this.addressLine1,
    this.addressLine2,
    this.addressLine3,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });
}

class ProfilePersonalInfo {
  final String firstName;
  final String? middleName;
  final String? lastName;
  final DateTime dateOfBirth;
  final String gender;
  final String? profilePictureUrl;

  ProfilePersonalInfo({
    required this.firstName,
    this.middleName,
    this.lastName,
    required this.dateOfBirth,
    required this.gender,
    this.profilePictureUrl,
  });
}
