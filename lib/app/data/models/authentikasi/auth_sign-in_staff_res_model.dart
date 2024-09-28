import 'package:santai/app/data/models/authentikasi/auth_registered_user_model.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_signin_staff_res.dart';


class SigninStaffResponseModel extends SigninStaffResponse {
  SigninStaffResponseModel({
    required RegisteredUserModel user,
    required NextActionSigninStaffModel next,
  }) : super(user: user, next: next);

  factory SigninStaffResponseModel.fromJson(Map<String, dynamic> json) {
    return SigninStaffResponseModel(
      user: RegisteredUserModel.fromJson(json['user']),
      next: NextActionSigninStaffModel.fromJson(json['next']),
    );
  }
}


class NextActionSigninStaffModel extends NextActionSigninStaff {
  NextActionSigninStaffModel({
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

  factory NextActionSigninStaffModel.fromJson(Map<String, dynamic> json) {
    return NextActionSigninStaffModel(
      link: json['link'],
      action: json['action'],
      method: json['method'],
      otpRequestToken: json['otpRequestToken'],
      otpRequestId: json['otpRequestId'],
      otpProviderTypes: List<String>.from(json['otpProviderTypes']),
    );
  }
}