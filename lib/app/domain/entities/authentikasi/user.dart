class User {
  final String phoneNumber;
  final String password;
  final String regionCode;
  final String? returnUrl;

  User({
    required this.phoneNumber,
    required this.password,
    required this.regionCode,
    this.returnUrl
  });
}