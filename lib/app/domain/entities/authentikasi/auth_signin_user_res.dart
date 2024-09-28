import 'package:santai/app/domain/entities/authentikasi/auth_registered_user.dart';

class SigninUserResponse {
  final RegisteredUser user;
  final NextActionSigninUser next;

  SigninUserResponse({
    required this.user,
    required this.next,
  });
}

class NextActionSigninUser {
  final String link;
  final String action;
  final String method;
  final String otpRequestToken;
  final String otpRequestId;
  final List<String> otpProviderTypes;

  NextActionSigninUser({
    required this.link,
    required this.action,
    required this.method,
    required this.otpRequestToken,
    required this.otpRequestId,
    required this.otpProviderTypes,
  });
}