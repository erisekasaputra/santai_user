import 'package:santai/app/domain/entities/profile/profile_user.dart';

class ProfileUserReqModel extends ProfileUser {
  ProfileUserReqModel({
    required String timeZoneId,
    String? referralCode,
    required ProfileAddressModel address,
    required ProfilePersonalInfoModel personalInfo,
  }) : super(
          timeZoneId: timeZoneId,
          referralCode: referralCode,
          address: address,
          personalInfo: personalInfo,
        );

  factory ProfileUserReqModel.fromEntity(ProfileUser profileUser) {
    return ProfileUserReqModel(
      timeZoneId: profileUser.timeZoneId,
      referralCode: profileUser.referralCode,
      address: ProfileAddressModel.fromEntity(profileUser.address),
      personalInfo: ProfilePersonalInfoModel.fromEntity(profileUser.personalInfo),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timeZoneId': timeZoneId,
      'referralCode': referralCode,
      'address': (address as ProfileAddressModel).toJson(),
      'personalInfo': (personalInfo as ProfilePersonalInfoModel).toJson(),
    };
  }
}

class ProfileAddressModel extends ProfileAddress {
  ProfileAddressModel({
    required String addressLine1,
    String? addressLine2,
    String? addressLine3,
    required String city,
    required String state,
    required String postalCode,
    required String country,
  }) : super(
          addressLine1: addressLine1,
          addressLine2: addressLine2,
          addressLine3: addressLine3,
          city: city,
          state: state,
          postalCode: postalCode,
          country: country,
        );

  factory ProfileAddressModel.fromEntity(ProfileAddress address) {
    return ProfileAddressModel(
      addressLine1: address.addressLine1,
      addressLine2: address.addressLine2,
      addressLine3: address.addressLine3,
      city: address.city,
      state: address.state,
      postalCode: address.postalCode,
      country: address.country,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'addressLine3': addressLine3,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
    };
  }
}

class ProfilePersonalInfoModel extends ProfilePersonalInfo {
  ProfilePersonalInfoModel({
    required String firstName,
    String? middleName,
    String? lastName,
    required String dateOfBirth,
    required String gender,
    String? profilePictureUrl,
  }) : super(
          firstName: firstName,
          middleName: middleName,
          lastName: lastName,
          dateOfBirth: dateOfBirth,
          gender: gender,
          profilePictureUrl: profilePictureUrl,
        );

  factory ProfilePersonalInfoModel.fromEntity(ProfilePersonalInfo personalInfo) {
    return ProfilePersonalInfoModel(
      firstName: personalInfo.firstName,
      middleName: personalInfo.middleName,
      lastName: personalInfo.lastName,
      dateOfBirth: personalInfo.dateOfBirth,
      gender: personalInfo.gender,
      profilePictureUrl: personalInfo.profilePictureUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}