import 'package:santai/app/data/models/authentikasi/auth_registered_user_model.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_verify_login_res.dart';


class VerifyLoginResponseModel extends VerifyLoginResponse {
  VerifyLoginResponseModel({
    required String accessToken,
    required RefreshTokenModel refreshToken,
    required RegisteredUserModel user,
    required NextActionModel next,
  }) : super(accessToken: accessToken, refreshToken: refreshToken, user: user, next: next);

  factory VerifyLoginResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyLoginResponseModel(
      accessToken: json['accessToken'],
      refreshToken: RefreshTokenModel.fromJson(json['refreshToken']),
      user: RegisteredUserModel.fromJson(json['user']),
      next: NextActionModel.fromJson(json['next']),
    );
  }
}

class RefreshTokenModel extends RefreshToken {
  RefreshTokenModel({
    required String token,
    required String expiryDateUtc,
    required String userId,
  }) : super(
          token: token,
          expiryDateUtc: expiryDateUtc,
          userId: userId,
        );

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenModel(
      token: json['token'],
      expiryDateUtc: json['expiryDateUtc'],
      userId: json['userId'],
    );
  }
}


class NextActionModel extends NextAction {
  NextActionModel({
    required String action,
  }) : super(
          action: action,
        );

  factory NextActionModel.fromJson(Map<String, dynamic> json) {
    return NextActionModel(
      action: json['action']
    );
  }
}