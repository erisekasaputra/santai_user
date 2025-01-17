import 'package:santai/app/domain/entities/profile/profile_user.dart';

class ProfileUserReqModel extends ProfileUser {
  ProfileUserReqModel({
    required super.email,
    required super.timeZoneId,
    super.referralCode,
    required ProfileAddressModel super.address,
    required ProfilePersonalInfoModel super.personalInfo,
  });

  factory ProfileUserReqModel.fromEntity(ProfileUser profileUser) {
    return ProfileUserReqModel(
      email: profileUser.email,
      timeZoneId: profileUser.timeZoneId,
      referralCode: profileUser.referralCode,
      address: ProfileAddressModel.fromEntity(profileUser.address),
      personalInfo:
          ProfilePersonalInfoModel.fromEntity(profileUser.personalInfo),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'timeZoneId': timeZoneId,
      'referralCode': referralCode,
      'address': (address as ProfileAddressModel).toJson(),
      'personalInfo': (personalInfo as ProfilePersonalInfoModel).toJson(),
    };
  }
}

class ProfileAddressModel extends ProfileAddress {
  ProfileAddressModel({
    required super.addressLine1,
    super.addressLine2,
    super.addressLine3,
    required super.city,
    required super.state,
    required super.postalCode,
    required super.country,
  });

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
    required super.firstName,
    super.middleName,
    super.lastName,
    required super.dateOfBirth,
    required super.gender,
    super.profilePicture,
  });

  factory ProfilePersonalInfoModel.fromEntity(
      ProfilePersonalInfo personalInfo) {
    return ProfilePersonalInfoModel(
      firstName: personalInfo.firstName,
      middleName: personalInfo.middleName,
      lastName: personalInfo.lastName,
      dateOfBirth: personalInfo.dateOfBirth,
      gender: personalInfo.gender,
      profilePicture: personalInfo.profilePicture,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'profilePictureUrl': profilePicture,
    };
  }
}
