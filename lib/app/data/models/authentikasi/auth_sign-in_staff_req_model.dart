import 'package:santai/app/domain/entities/authentikasi/auth_signin_staff.dart';

class SigninStaffModel extends SigninStaff {
  SigninStaffModel({
    required String phoneNumber,
    required String password,
    required String regionCode,
    required String businessCode,
  }) : super(
          phoneNumber: phoneNumber,
          password: password,
          regionCode: regionCode,
          businessCode: businessCode,
        );

  factory SigninStaffModel.fromEntity(SigninStaff user) {
    return SigninStaffModel(
      phoneNumber: user.phoneNumber,
      password: user.password,
      regionCode: user.regionCode,
      businessCode: user.businessCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'password': password,
      'regionCode': regionCode,
      'businessCode': businessCode,
    };
  }
}
