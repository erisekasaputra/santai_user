import 'package:santai/app/domain/entities/authentikasi/auth_verify_login.dart';

class VerifyLoginModel extends VerifyLogin {
  VerifyLoginModel({
    required String deviceId,
    required String phoneNumber,
    required String token,
  }) : super(
          deviceId: deviceId,
          phoneNumber: phoneNumber,
          token: token,
        );

  factory VerifyLoginModel.fromEntity(VerifyLogin user) {
    return VerifyLoginModel(
      phoneNumber: user.phoneNumber,
      token: user.token,
      deviceId: user.deviceId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'token': token,
      'deviceId': deviceId,
    };
  }
}
