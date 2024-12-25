import 'package:santai/app/domain/entities/authentikasi/user.dart';

class UserModel extends User {
  UserModel({
    required super.phoneNumber,
    required super.password,
    required super.regionCode,
    super.returnUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      phoneNumber: json['phoneNumber'],
      password: json['password'],
      regionCode: json['regionCode'],
      returnUrl: json['returnUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'password': password,
      'regionCode': regionCode,
      'returnUrl': returnUrl,
    };
  }

  static UserModel fromEntity(User user) {
    return UserModel(
      phoneNumber: user.phoneNumber,
      password: user.password,
      regionCode: user.regionCode,
      returnUrl: user.returnUrl,
    );
  }
}
