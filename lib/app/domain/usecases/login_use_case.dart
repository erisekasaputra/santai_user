import 'package:santai/app/data/repositories/user_repository.dart';
import 'package:santai/app/domain/entities/user.dart';

class LoginUseCase {
  final UserRepository repository;

  LoginUseCase(this.repository);

  Future<User> execute(String email, String password) {
    return repository.login(email, password);
  }
}