import 'package:santai/app/data/models/authentikasi/auth_registered_user_model.dart';
import 'package:santai/app/domain/entities/authentikasi/otp_request_res.dart';


class OtpRequestResponseModel extends OtpRequestResponse {
  OtpRequestResponseModel({
    required bool isSuccess,
    required RegisteredUserModel data,
    required NextActionOtpReqResModel next,
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

  factory OtpRequestResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpRequestResponseModel(
      isSuccess: json['isSuccess'],
      data: RegisteredUserModel.fromJson(json['data']),
      next: NextActionOtpReqResModel.fromJson(json['next']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
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