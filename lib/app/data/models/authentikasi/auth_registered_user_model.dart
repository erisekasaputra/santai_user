import 'package:santai/app/domain/entities/authentikasi/auth_registered_user.dart';

class RegisteredUserModel extends RegisteredUser {
  RegisteredUserModel({
    required String sub,
    required String username,
    required String phoneNumber,
    String? email,
    required String userType,
    String? businessCode,
    String? otp,
  }) : super(
          sub: sub,
          username: username,
          phoneNumber: phoneNumber,
          email: email,
          userType: userType,
          businessCode: businessCode,
          token: otp,
        );

  factory RegisteredUserModel.fromJson(Map<String, dynamic> json) {
    return RegisteredUserModel(
      sub: json['sub'],
      username: json['username'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      userType: json['userType'],
      businessCode: json['businessCode'],
      otp: json['otp'],
    );
  }
}