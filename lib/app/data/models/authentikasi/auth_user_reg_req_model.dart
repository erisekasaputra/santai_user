import 'package:santai/app/domain/entities/authentikasi/auth_user_register.dart';

class UserRegisterModel extends UserRegister {
  UserRegisterModel({
    required String phoneNumber,
    required String password,
    required String regionCode,
    required String userType,
  }) : super(
          phoneNumber: phoneNumber,
          password: password,
          regionCode: regionCode,
          userType: userType,
        );

  factory UserRegisterModel.fromEntity(UserRegister user) {
    return UserRegisterModel(
      phoneNumber: user.phoneNumber,
      password: user.password,
      regionCode: user.regionCode,
      userType: user.userType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'password': password,
      'regionCode': regionCode,
      'userType': userType,
    };
  }
}