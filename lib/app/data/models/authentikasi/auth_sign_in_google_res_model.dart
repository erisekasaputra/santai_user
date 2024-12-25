import 'package:santai/app/data/models/authentikasi/auth_registered_user_model.dart';
// import 'package:santai/app/data/models/common/common_respon_code_model.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_signin_google_res.dart';


class SigninGoogleResponseModel extends SigninGoogleResponse {
  // final ResponseCodeModel? responseCode;
  
  SigninGoogleResponseModel({
    required RegisteredUserModel user,
    required NextActionSigninGoogleModel next,
  }) : super(user: user, next: next);

  // SigninGoogleResponseModel({
  //   RegisteredUserModel? user, // Make user optional
  //   NextActionSigninGoogleModel? next, // Make next optional
  //   this.responseCode, // Add response code to constructor
  // }) : super(user: user ?? RegisteredUserModel(), next: next ?? NextActionSigninGoogleModel());

  factory SigninGoogleResponseModel.fromJson(Map<String, dynamic> json) {
    return SigninGoogleResponseModel(
      user: RegisteredUserModel.fromJson(json['user']),
      next: NextActionSigninGoogleModel.fromJson(json['next']),
    );
  }

  // factory SigninGoogleResponseModel.fromJson(Map<String, dynamic> json) {
  //   if (json.containsKey('responseCode')) {
  //     return SigninGoogleResponseModel(
  //       responseCode: ResponseCodeModel.fromJson(json['responseCode']),
  //       user: json.containsKey('user') ? RegisteredUserModel.fromJson(json['user']) : null,
  //       next: json.containsKey('next') ? NextActionSigninGoogleModel.fromJson(json['next']) : null,
  //     );
  //   }
  //   return SigninGoogleResponseModel(
  //     user: json.containsKey('user') ? RegisteredUserModel.fromJson(json['user']) : null,
  //     next: json.containsKey('next') ? NextActionSigninGoogleModel.fromJson(json['next']) : null,
  //   );
  // }
}


class NextActionSigninGoogleModel extends NextActionSigninGoogle {
  NextActionSigninGoogleModel({
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

  factory NextActionSigninGoogleModel.fromJson(Map<String, dynamic> json) {
    return NextActionSigninGoogleModel(
      link: json['link'],
      action: json['action'],
      method: json['method'],
      otpRequestToken: json['otpRequestToken'],
      otpRequestId: json['otpRequestId'],
      otpProviderTypes: List<String>.from(json['otpProviderTypes']),
    );
  }
}