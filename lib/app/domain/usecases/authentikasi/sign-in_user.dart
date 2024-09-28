import 'package:santai/app/domain/entities/authentikasi/auth_signin_user.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_signin_user_res.dart';

import '../../../domain/repository/authentikasi/auth_repository.dart';

class UserSignIn {
  final AuthRepository repository;

  UserSignIn(this.repository);

  Future<SigninUserResponse> call(SigninUser user) async {
    return await repository.signinUser(user);
  }
}