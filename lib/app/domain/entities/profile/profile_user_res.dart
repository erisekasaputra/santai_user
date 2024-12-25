import 'package:santai/app/domain/entities/profile/profile_user.dart';
import 'package:santai/app/domain/enumerations/loyalty_tier.dart';

class ProfileUserResponse {
  final bool isSuccess;
  final ProfileUserData data;
  final String message;
  final String responseStatus;
  final List<dynamic> errors;
  final List<dynamic> links;

  ProfileUserResponse({
    required this.isSuccess,
    required this.data,
    required this.message,
    required this.responseStatus,
    required this.errors,
    required this.links,
  });
}

class ProfileUserData {
  final String id;
  final String? email;
  final String phoneNumber;
  final String timeZoneId;
  final ProfileAddress address;
  final LoyaltyProgram loyaltyProgram;
  final Referral referral;
  final ProfilePersonalInfo personalInfo;
  final List<dynamic> fleets;

  ProfileUserData({
    required this.id,
    this.email,
    required this.phoneNumber,
    required this.timeZoneId,
    required this.address,
    required this.loyaltyProgram,
    required this.referral,
    required this.personalInfo,
    required this.fleets,
  });
}

class LoyaltyProgram {
  final String userId;
  final int points;
  final LoyaltyTier tier;

  LoyaltyProgram({
    required this.userId,
    required this.points,
    required this.tier,
  });
}

class Referral {
  final String referralCode;
  final int rewardPoint;

  Referral({
    required this.referralCode,
    required this.rewardPoint,
  });
}
