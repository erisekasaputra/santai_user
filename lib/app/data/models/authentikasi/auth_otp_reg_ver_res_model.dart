import 'package:santai/app/data/models/authentikasi/auth_registered_user_model.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_otp_register_verify_res.dart';

class OtpRegisterVerifyResponseModel extends OtpRegisterVerifyResponse {
  OtpRegisterVerifyResponseModel({
    required RegisteredUserModel user,
    required NextActionOtpRegisterVerifyResponseModel next,
  }) : super(user: user, next: next);

  factory OtpRegisterVerifyResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpRegisterVerifyResponseModel(
      user: RegisteredUserModel.fromJson(json['user']),
      next: NextActionOtpRegisterVerifyResponseModel.fromJson(json['next']),
    );
  }

  factory OtpRegisterVerifyResponseModel.defaultSuccess() {
    return OtpRegisterVerifyResponseModel(
      user: RegisteredUserModel(
        sub: '',
        username: '',
        phoneNumber: '',
        email: '',
        userType: '',
        businessCode: '',
        token: '',
      ),
      next: NextActionOtpRegisterVerifyResponseModel(
        link: '',
        action: 'Success',
        method: '',
      ),
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
