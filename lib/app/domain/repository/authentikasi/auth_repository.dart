import 'package:santai/app/domain/entities/authentikasi/auth_otp_register_verify.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_otp_register_verify_res.dart';

import 'package:santai/app/domain/entities/authentikasi/auth_signin_google.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_signin_google_res.dart';

import 'package:santai/app/domain/entities/authentikasi/auth_signin_staff.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_signin_staff_res.dart';

import 'package:santai/app/domain/entities/authentikasi/auth_signin_user.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_signin_user_res.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_signout.dart';

import 'package:santai/app/domain/entities/authentikasi/auth_user_register.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_user_register_res.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_verify_login.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_verify_login_res.dart';

import '../../entities/authentikasi/otp_request.dart';
import 'package:santai/app/domain/entities/authentikasi/otp_request_res.dart';

import '../../entities/authentikasi/password_reset.dart';

abstract class AuthRepository {

   Future<UserRegisterResponse> registerUser(UserRegister user);
  
  Future<SigninUserResponse> signinUser(SigninUser user);
  Future<SigninStaffResponse> signinStaff(SigninStaff user);
  Future<SigninGoogleResponse> signinGoogle(SigninGoogle user);

  Future<OtpRequestResponse> sendOtp(OtpRequest request);
  Future<OtpRegisterVerifyResponse> otpRegisterVerify(OtpRegisterVerify request);

  Future<VerifyLoginResponse> verifyLogin(VerifyLogin request);
  Future<void> signOut(SignOut request);

  Future<void> resetPassword(PasswordReset reset);
}