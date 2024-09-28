import 'package:santai/app/data/models/authentikasi/auth_registered_user_model.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_signin_user_res.dart';


class SigninUserResponseModel extends SigninUserResponse {
  SigninUserResponseModel({
    required RegisteredUserModel user,
    required NextActionSigninUserModel next,
  }) : super(user: user, next: next);

  factory SigninUserResponseModel.fromJson(Map<String, dynamic> json) {
    return SigninUserResponseModel(
      user: RegisteredUserModel.fromJson(json['user']),
      next: NextActionSigninUserModel.fromJson(json['next']),
    );
  }
}


class NextActionSigninUserModel extends NextActionSigninUser {
  NextActionSigninUserModel({
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

  factory NextActionSigninUserModel.fromJson(Map<String, dynamic> json) {
    return NextActionSigninUserModel(
      link: json['link'],
      action: json['action'],
      method: json['method'],
      otpRequestToken: json['otpRequestToken'],
      otpRequestId: json['otpRequestId'],
      otpProviderTypes: List<String>.from(json['otpProviderTypes']),
    );
  }
}