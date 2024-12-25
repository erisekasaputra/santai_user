import 'package:santai/app/data/models/profile/profile_user_req_model.dart';
import 'package:santai/app/domain/entities/profile/profile_user_res.dart';
import 'package:santai/app/domain/entities/profile/profile_user.dart';
import 'package:santai/app/domain/enumerations/loyalty_tier.dart';

class ProfileUserResponseModel extends ProfileUserResponse {
  ProfileUserResponseModel({
    required super.isSuccess,
    required ProfileUserDataModel super.data,
    required super.message,
    required super.responseStatus,
    required super.errors,
    required super.links,
  });

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

  factory ProfileUserResponseModel.empty(ProfileUserReqModel user) {
    return ProfileUserResponseModel(
      isSuccess: true,
      data: ProfileUserDataModel(
        id: '',
        email: '',
        phoneNumber: '',
        timeZoneId: '',
        address: ProfileAddressModel(
          addressLine1: '',
          addressLine2: '',
          addressLine3: '',
          city: '',
          state: '',
          postalCode: '',
          country: '',
        ),
        loyaltyProgram: LoyaltyProgramModel(
          userId: '',
          points: 0,
          tier: LoyaltyTier.basic,
        ),
        referral: ReferralModel(
          referralCode: '',
          rewardPoint: 0,
        ),
        personalInfo: ProfilePersonalInfoModel(
          firstName: '',
          middleName: '',
          lastName: '',
          dateOfBirth: '',
          gender: '',
          profilePicture: '',
        ),
        fleets: [],
      ),
      message: 'Profile updated successfully',
      responseStatus: 'Success',
      errors: [],
      links: [],
    );
  }
}

class ProfileUserDataModel extends ProfileUserData {
  ProfileUserDataModel({
    required super.id,
    super.email,
    required super.phoneNumber,
    required super.timeZoneId,
    required ProfileAddressModel super.address,
    required LoyaltyProgramModel super.loyaltyProgram,
    required ReferralModel super.referral,
    required ProfilePersonalInfoModel super.personalInfo,
    required super.fleets,
  });

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
    required super.addressLine1,
    super.addressLine2,
    super.addressLine3,
    required super.city,
    required super.state,
    required super.postalCode,
    required super.country,
  });

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
    required super.userId,
    required super.points,
    required super.tier,
  });

  factory LoyaltyProgramModel.fromJson(Map<String, dynamic> json) {
    return LoyaltyProgramModel(
      userId: json['userId'],
      points: json['points'],
      tier: LoyaltyTier.values
          .firstWhere((e) => e.toString().split('.').last == json['tier']),
    );
  }
}

class ReferralModel extends Referral {
  ReferralModel({
    required super.referralCode,
    required super.rewardPoint,
  });

  factory ReferralModel.fromJson(Map<String, dynamic> json) {
    return ReferralModel(
      referralCode: json['referralCode'],
      rewardPoint: json['rewardPoint'],
    );
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

  factory ProfilePersonalInfoModel.fromJson(Map<String, dynamic> json) {
    return ProfilePersonalInfoModel(
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      profilePicture: json['profilePicture'],
    );
  }
}
