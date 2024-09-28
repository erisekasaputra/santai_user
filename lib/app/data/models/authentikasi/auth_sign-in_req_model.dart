import 'package:santai/app/domain/entities/authentikasi/auth_signin_user.dart';

class SigninUserModel extends SigninUser {
  SigninUserModel({
    required String phoneNumber,
    required String password,
    required String regionCode
  }) : super(
          phoneNumber: phoneNumber,
          password: password,
          regionCode: regionCode
        );

  factory SigninUserModel.fromEntity(SigninUser user) {
    return SigninUserModel(
      phoneNumber: user.phoneNumber,
      password: user.password,
      regionCode: user.regionCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'password': password,
      'regionCode': regionCode,
    };
  }
}
