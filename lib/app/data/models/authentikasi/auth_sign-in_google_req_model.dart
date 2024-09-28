import 'package:santai/app/domain/entities/authentikasi/auth_signin_google.dart';

class SigninGoogleModel extends SigninGoogle {
  SigninGoogleModel({
    required String googleIdToken,
  }) : super(
          googleIdToken: googleIdToken,
        );

  factory SigninGoogleModel.fromEntity(SigninGoogle user) {
    return SigninGoogleModel(
      googleIdToken: user.googleIdToken,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'googleIdToken': googleIdToken,
    };
  }
}
