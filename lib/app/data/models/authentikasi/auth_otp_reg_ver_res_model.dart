import 'package:santai/app/data/models/authentikasi/auth_registered_user_model.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_otp_register_verify_res.dart';

class OtpRegisterVerifyResponseModel extends OtpRegisterVerifyResponse {
  OtpRegisterVerifyResponseModel({
    required bool isSuccess,
    required RegisteredUserModel data,
    required NextActionOtpRegisterVerifyResponseModel next,
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

  factory OtpRegisterVerifyResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpRegisterVerifyResponseModel(
      isSuccess: json['isSuccess'],
      data: RegisteredUserModel.fromJson(json['data']),
      next: NextActionOtpRegisterVerifyResponseModel.fromJson(json['next']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
    );
  }

  factory OtpRegisterVerifyResponseModel.defaultSuccess() {
    return OtpRegisterVerifyResponseModel(
      isSuccess: true,
      data: RegisteredUserModel(
        sub: '',
        username: '',
        phoneNumber: '',
        email: '',
        userType: '',
        businessCode: '',
        otp: '',
      ),
      next: NextActionOtpRegisterVerifyResponseModel(
        link: '',
        action: 'Success',
        method: '',
      ),
      message: 'Success',
      responseStatus: 'Success',
      errors: [],
      links: [],
    );
  }
}

class NextActionOtpRegisterVerifyResponseModel
    extends NextActionOtpRegisterVerifyResponse {
  NextActionOtpRegisterVerifyResponseModel(
      {required String link, required String action, required String method})
      : super(
          link: link,
          action: action,
          method: method,
        );

  factory NextActionOtpRegisterVerifyResponseModel.fromJson(
      Map<String, dynamic> json) {
    return NextActionOtpRegisterVerifyResponseModel(
      link: json['link'],
      action: json['action'],
      method: json['method'],
    );
  }
}
