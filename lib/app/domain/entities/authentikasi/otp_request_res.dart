import 'package:santai/app/domain/entities/authentikasi/auth_registered_user.dart';

class OtpRequestResponse {
  final RegisteredUser user;
  final NextActionOtpReqRes next;

  OtpRequestResponse({
    required this.user,
    required this.next,
  });
}

class NextActionOtpReqRes {
  final String link;
  final String action;
  final String method;

  NextActionOtpReqRes({
    required this.link,
    required this.action,
    required this.method,
  });
}