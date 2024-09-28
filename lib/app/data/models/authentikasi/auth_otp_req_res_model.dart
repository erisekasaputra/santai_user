import 'package:santai/app/data/models/authentikasi/auth_registered_user_model.dart';
import 'package:santai/app/domain/entities/authentikasi/otp_request_res.dart';


class OtpRequestResponseModel extends OtpRequestResponse {
  OtpRequestResponseModel({
    required RegisteredUserModel user,
    required NextActionOtpReqResModel next,
  }) : super(user: user, next: next);

  factory OtpRequestResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpRequestResponseModel(
      user: RegisteredUserModel.fromJson(json['user']),
      next: NextActionOtpReqResModel.fromJson(json['next']),
    );
  }
}


class NextActionOtpReqResModel extends NextActionOtpReqRes {
  NextActionOtpReqResModel({
    required String link,
    required String action,
    required String method
  }) : super(
          link: link,
          action: action,
          method: method,
        );

  factory NextActionOtpReqResModel.fromJson(Map<String, dynamic> json) {
    return NextActionOtpReqResModel(
      link: json['link'],
      action: json['action'],
      method: json['method'],
    );
  }
}