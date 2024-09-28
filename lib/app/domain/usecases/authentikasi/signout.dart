import 'package:santai/app/domain/entities/authentikasi/auth_signout.dart';
import '../../../domain/repository/authentikasi/auth_repository.dart';

class SignOutUser {
  final AuthRepository repository;

  SignOutUser(this.repository);

  Future<void> call(SignOut request) async {
    return await repository.signOut(request);
  }
}
