import '../../../domain/entities/authentikasi/password_reset.dart';
import '../../../domain/repository/authentikasi/auth_repository.dart';

class ResetPassword {
  final AuthRepository repository;

  ResetPassword(this.repository);

  Future<void> call(PasswordReset reset) async {
    return await repository.resetPassword(reset);
  }
}