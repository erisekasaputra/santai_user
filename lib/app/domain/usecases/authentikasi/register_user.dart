import 'package:santai/app/domain/entities/authentikasi/auth_user_register.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_user_register_res.dart';

import '../../../domain/repository/authentikasi/auth_repository.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<UserRegisterResponse> call(UserRegister user) async {
    return await repository.registerUser(user);
  }
}