import 'package:santai/app/domain/entities/authentikasi/auth_registered_user.dart';

class SigninStaffResponse {
  final RegisteredUser? data;
  final NextActionSigninStaff next;

  SigninStaffResponse({
    required this.data,
    required this.next,
  });
}

class NextActionSigninStaff {
  final String link;
  final String action;
  final String method;
  final String otpRequestToken;
  final String otpRequestId;
  final List<String> otpProviderTypes;

  NextActionSigninStaff({
    required this.link,
    required this.action,
    required this.method,
    required this.otpRequestToken,
    required this.otpRequestId,
    required this.otpProviderTypes,
  });
}
