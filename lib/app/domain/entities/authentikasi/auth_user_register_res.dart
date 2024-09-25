class UserRegisterResponse {
  final RegisteredUser user;
  final NextAction next;

  UserRegisterResponse({
    required this.user,
    required this.next,
  });
}

class RegisteredUser {
  final String sub;
  final String username;
  final String phoneNumber;
  final String? email;
  final String userType;
  final String? businessCode;

  RegisteredUser({
    required this.sub,
    required this.username,
    required this.phoneNumber,
    this.email,
    required this.userType,
    this.businessCode,
  });
}

class NextAction {
  final String link;
  final String action;
  final String method;
  final String otpRequestToken;
  final String otpRequestId;
  final List<String> otpProviderTypes;

  NextAction({
    required this.link,
    required this.action,
    required this.method,
    required this.otpRequestToken,
    required this.otpRequestId,
    required this.otpProviderTypes,
  });
}