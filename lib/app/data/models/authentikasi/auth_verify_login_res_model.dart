import 'package:santai/app/domain/entities/authentikasi/auth_verify_login_res.dart';


class VerifyLoginResponseModel extends VerifyLoginResponse {
  VerifyLoginResponseModel({
    required bool isSuccess,
    required Data data,
    required NextActionModel next,
    required String message,
    required String responseStatus,
    required List<dynamic> errors,
    required List<dynamic> links,
  }) : super(
    isSuccess: isSuccess,
    data: data, 
    next: next,
    message: message,
    responseStatus: responseStatus,
    errors: errors,
    links: links,
  );

  factory VerifyLoginResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyLoginResponseModel(
      isSuccess: json['isSuccess'],
      data: DataModel.fromJson(json['data']),
      next: NextActionModel.fromJson(json['next']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
    );
  }
}

class DataModel extends Data {
  DataModel({
    required String accessToken,
    required RefreshTokenModel refreshToken,
    required String sub,
    required String username,
    required String phoneNumber,
    required String? email,
    required String userType,
    required String? businessCode,
  }) : super(
    accessToken: accessToken,
    refreshToken: refreshToken,
    sub: sub,
    username: username,
    phoneNumber: phoneNumber,
    email: email,
    userType: userType,
    businessCode: businessCode,
  );

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      accessToken: json['accessToken'],
      refreshToken: RefreshTokenModel.fromJson(json['refreshToken']),
      sub: json['sub'],
      username: json['username'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      userType: json['userType'],
      businessCode: json['businessCode'],
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