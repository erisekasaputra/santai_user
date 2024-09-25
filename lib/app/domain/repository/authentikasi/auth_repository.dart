import 'package:santai/app/domain/entities/authentikasi/auth_user_register.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_user_register_res.dart';

import '../../entities/authentikasi/user.dart';
import '../../entities/authentikasi/user_staff.dart';
import '../../entities/authentikasi/otp_request.dart';
import '../../entities/authentikasi/password_reset.dart';

abstract class AuthRepository {
  Future<void> loginUser(User user);
  Future<void> loginStaff(UserStaff user);
  Future<UserRegisterResponse> registerUser(UserRegister user);
  Future<void> sendOtp(OtpRequest request);
  Future<void> resetPassword(PasswordReset reset);
}