class PasswordReset {
  final String identity;
  final String newPassword;
  final String otpCode;

  PasswordReset({
    required this.identity,
    required this.newPassword,
    required this.otpCode,
  });
}