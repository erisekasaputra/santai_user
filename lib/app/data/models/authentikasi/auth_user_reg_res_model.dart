import 'package:santai/app/data/models/authentikasi/auth_registered_user_model.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_user_register_res.dart';


class UserRegisterResponseModel extends UserRegisterResponse {
  UserRegisterResponseModel({
    required bool isSuccess,
    required RegisteredUserModel data,
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

  factory UserRegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return UserRegisterResponseModel(
      isSuccess: json['isSuccess'],
      data: RegisteredUserModel.fromJson(json['data']),
      next: NextActionModel.fromJson(json['next']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
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