import 'package:santai/app/domain/entities/profile/profile_user_res.dart';
import 'package:santai/app/domain/entities/profile/profile_user.dart';

class ProfileUserResponseModel extends ProfileUserResponse {
  ProfileUserResponseModel({
    required bool isSuccess,
    required ProfileUserDataModel data,
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

  factory ProfileUserResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileUserResponseModel(
      isSuccess: json['isSuccess'],
      data: ProfileUserDataModel.fromJson(json['data']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
    );
  }
}

class ProfileUserDataModel extends ProfileUserData {
  ProfileUserDataModel({
    required String id,
    String? email,
    required String phoneNumber,
    required String timeZoneId,
    required ProfileAddressModel address,
    required LoyaltyProgramModel loyaltyProgram,
    required ReferralModel referral,
    required ProfilePersonalInfoModel personalInfo,
    required List<dynamic> fleets,
  }) : super(
          id: id,
          email: email,
          phoneNumber: phoneNumber,
          timeZoneId: timeZoneId,
          address: address,
          loyaltyProgram: loyaltyProgram,
          referral: referral,
          personalInfo: personalInfo,
          fleets: fleets,
        );

  factory ProfileUserDataModel.fromJson(Map<String, dynamic> json) {
    return ProfileUserDataModel(
      id: json['id'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      timeZoneId: json['timeZoneId'],
      address: ProfileAddressModel.fromJson(json['address']),
      loyaltyProgram: LoyaltyProgramModel.fromJson(json['loyaltyProgram']),
      referral: ReferralModel.fromJson(json['referral']),
      personalInfo: ProfilePersonalInfoModel.fromJson(json['personalInfo']),
      fleets: json['fleets'],
    );
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

  factory ProfileAddressModel.fromJson(Map<String, dynamic> json) {
    return ProfileAddressModel(
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      addressLine3: json['addressLine3'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postalCode'],
      country: json['country'],
    );
  }
}

class LoyaltyProgramModel extends LoyaltyProgram {
  LoyaltyProgramModel({
    required String userId,
    required int points,
    required String tier,
  }) : super(
          userId: userId,
          points: points,
          tier: tier,
        );

  factory LoyaltyProgramModel.fromJson(Map<String, dynamic> json) {
    return LoyaltyProgramModel(
      userId: json['userId'],
      points: json['points'],
      tier: json['tier'],
    );
  }
}

class ReferralModel extends Referral {
  ReferralModel({
    required String referralCode,
    required int rewardPoint,
  }) : super(
          referralCode: referralCode,
          rewardPoint: rewardPoint,
        );

  factory ReferralModel.fromJson(Map<String, dynamic> json) {
    return ReferralModel(
      referralCode: json['referralCode'],
      rewardPoint: json['rewardPoint'],
    );
  }
}

class ProfilePersonalInfoModel extends ProfilePersonalInfo {
  ProfilePersonalInfoModel({
    required String firstName,
    String? middleName,
    String? lastName,
    required DateTime dateOfBirth,
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

  factory ProfilePersonalInfoModel.fromJson(Map<String, dynamic> json) {
    return ProfilePersonalInfoModel(
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      gender: json['gender'],
      profilePictureUrl: json['profilePictureUrl'],
    );
  }
}