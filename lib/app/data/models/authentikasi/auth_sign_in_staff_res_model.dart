import 'package:santai/app/data/models/authentikasi/auth_registered_user_model.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_signin_staff_res.dart';

class SigninStaffResponseModel extends SigninStaffResponse {
  SigninStaffResponseModel({
    required RegisteredUserModel? data,
    required NextActionSigninStaffModel next,
  }) : super(data: data, next: next);

  factory SigninStaffResponseModel.fromJson(Map<String, dynamic> json) {
    return SigninStaffResponseModel(
      data: json['data'] == null
          ? null
          : RegisteredUserModel.fromJson(json['data']),
      next: NextActionSigninStaffModel.fromJson(json['next']),
    );
  }
}

class NextActionSigninStaffModel extends NextActionSigninStaff {
  NextActionSigninStaffModel({
    required super.link,
    required super.action,
    required super.method,
    required super.otpRequestToken,
    required super.otpRequestId,
    required super.otpProviderTypes,
  });

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
