import 'package:santai/app/domain/entities/authentikasi/auth_registered_user.dart';

class OtpRegisterVerifyResponse {
  final RegisteredUser user;
  final NextActionOtpRegisterVerifyResponse next;

  OtpRegisterVerifyResponse({
    required this.user,
    required this.next,
  });
}

class NextActionOtpRegisterVerifyResponse {
  final String link;
  final String action;
  final String method;

  NextActionOtpRegisterVerifyResponse({
    required this.link,
    required this.action,
    required this.method,
  });
}