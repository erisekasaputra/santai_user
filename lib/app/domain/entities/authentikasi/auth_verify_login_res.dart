import 'package:santai/app/domain/entities/authentikasi/auth_registered_user.dart';

class VerifyLoginResponse {
  final String accessToken;
  final RefreshToken refreshToken;
  final RegisteredUser user;
  final NextAction next;

  VerifyLoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.next,
  });
}

class RefreshToken {
  final String token;
  final String expiryDateUtc;
  final String userId;

  RefreshToken({
    required this.token,
    required this.expiryDateUtc,
    required this.userId,
  });
}

class NextAction {
  final String action;

  NextAction({
    required this.action
  });
}