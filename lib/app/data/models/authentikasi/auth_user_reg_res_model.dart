import 'package:santai/app/domain/entities/authentikasi/auth_user_register_res.dart';


class UserRegisterResponseModel extends UserRegisterResponse {
  UserRegisterResponseModel({
    required RegisteredUserModel user,
    required NextActionModel next,
  }) : super(user: user, next: next);

  factory UserRegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return UserRegisterResponseModel(
      user: RegisteredUserModel.fromJson(json['user']),
      next: NextActionModel.fromJson(json['next']),
    );
  }
}

class RegisteredUserModel extends RegisteredUser {
  RegisteredUserModel({
    required String sub,
    required String username,
    required String phoneNumber,
    String? email,
    required String userType,
    String? businessCode,
  }) : super(
          sub: sub,
          username: username,
          phoneNumber: phoneNumber,
          email: email,
          userType: userType,
          businessCode: businessCode,
        );

  factory RegisteredUserModel.fromJson(Map<String, dynamic> json) {
    return RegisteredUserModel(
      sub: json['sub'],
      username: json['username'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      userType: json['userType'],
      businessCode: json['businessCode'],
    );
  }
}

class NextActionModel extends NextAction {
  NextActionModel({
    required String link,
    required String action,
    required String method,
    required String otpRequestToken,
    required String otpRequestId,
    required List<String> otpProviderTypes,
  }) : super(
          link: link,
          action: action,
          method: method,
          otpRequestToken: otpRequestToken,
          otpRequestId: otpRequestId,
          otpProviderTypes: otpProviderTypes,
        );

  factory NextActionModel.fromJson(Map<String, dynamic> json) {
    return NextActionModel(
      link: json['link'],
      action: json['action'],
      method: json['method'],
      otpRequestToken: json['otpRequestToken'],
      otpRequestId: json['otpRequestId'],
      otpProviderTypes: List<String>.from(json['otpProviderTypes']),
    );
  }
}