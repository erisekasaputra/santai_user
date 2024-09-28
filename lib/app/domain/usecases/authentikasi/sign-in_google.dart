import 'package:santai/app/domain/entities/authentikasi/auth_signin_google.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_signin_google_res.dart';

import '../../../domain/repository/authentikasi/auth_repository.dart';

class GoogleSignIn {
  final AuthRepository repository;

  GoogleSignIn(this.repository);

  Future<SigninGoogleResponse> call(SigninGoogle user) async {
    return await repository.signinGoogle(user);
  }
}