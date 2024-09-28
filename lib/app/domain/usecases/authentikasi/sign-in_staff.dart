import 'package:santai/app/domain/entities/authentikasi/auth_signin_staff.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_signin_staff_res.dart';

import '../../../domain/repository/authentikasi/auth_repository.dart';

class StaffSignIn {
  final AuthRepository repository;

  StaffSignIn(this.repository);

  Future<SigninStaffResponse> call(SigninStaff user) async {
    return await repository.signinStaff(user);
  }
}