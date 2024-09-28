class RegisteredUser {
  final String sub;
  final String username;
  final String phoneNumber;
  final String? email;
  final String userType;
  final String? businessCode;
  final String? token;
  RegisteredUser({
    required this.sub,
    required this.username,
    required this.phoneNumber,
    this.email,
    required this.userType,
    this.businessCode,
    this.token,
  });
}