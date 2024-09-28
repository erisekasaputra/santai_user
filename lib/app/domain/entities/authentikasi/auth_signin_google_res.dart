import 'package:santai/app/domain/entities/authentikasi/auth_registered_user.dart';

class SigninGoogleResponse {
  final RegisteredUser user;
  final NextActionSigninGoogle next;

  SigninGoogleResponse({
    required this.user,
    required this.next,
  });
}

class NextActionSigninGoogle {
  final String link;
  final String action;
  final String method;
  final String otpRequestToken;
  final String otpRequestId;
  final List<String> otpProviderTypes;

  NextActionSigninGoogle({
    required this.link,
    required this.action,
    required this.method,
    required this.otpRequestToken,
    required this.otpRequestId,
    required this.otpProviderTypes,
  });
}