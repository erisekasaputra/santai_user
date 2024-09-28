import 'package:santai/app/domain/entities/authentikasi/auth_registered_user.dart';

class UserRegisterResponse {
  final RegisteredUser user;
  final NextAction next;

  UserRegisterResponse({
    required this.user,
    required this.next,
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