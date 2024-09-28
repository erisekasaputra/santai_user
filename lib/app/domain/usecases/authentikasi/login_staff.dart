// import '../../../domain/entities/authentikasi/user_staff.dart';
import '../../../domain/repository/authentikasi/auth_repository.dart';

class LoginStaff {
  final AuthRepository repository;

  LoginStaff(this.repository);

  // Future<void> call(UserStaff user) async {
  //   return await repository.loginStaff(user);
  // }
}