class UserStaff {
  final String businessCode;
  final String password;
  final String phoneNumber;
  final String regionCode;
  final String? returnUrl;

  UserStaff({
    required this.businessCode,
    required this.password,
    required this.phoneNumber,
    required this.regionCode,
    this.returnUrl,
  });
}