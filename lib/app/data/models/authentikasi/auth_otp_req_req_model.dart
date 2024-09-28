import 'package:santai/app/domain/entities/authentikasi/otp_request.dart';

class OtpRequestModel extends OtpRequest {
  OtpRequestModel({
    required String otpRequestId,
    required String otpRequestToken,
    required String otpProviderType,
  }) : super(
          otpRequestId: otpRequestId,
          otpRequestToken: otpRequestToken,
          otpProviderType: otpProviderType,
        );

  factory OtpRequestModel.fromEntity(OtpRequest otpRequest) {
    return OtpRequestModel(
      otpRequestId: otpRequest.otpRequestId,
      otpRequestToken: otpRequest.otpRequestToken,
      otpProviderType: otpRequest.otpProviderType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'otpRequestId': otpRequestId,
      'otpRequestToken': otpRequestToken,
      'otpProviderType': otpProviderType,
    };
  }
}