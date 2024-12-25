import 'package:santai/app/domain/entities/authentikasi/auth_signout.dart';

class SignOutModel extends SignOut {
  SignOutModel(
      {required super.accessToken,
      required super.refreshToken,
      required super.deviceId});

  factory SignOutModel.fromEntity(SignOut user) {
    return SignOutModel(
      accessToken: user.accessToken,
      refreshToken: user.refreshToken,
      deviceId: user.deviceId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'deviceId': deviceId,
    };
  }
}
