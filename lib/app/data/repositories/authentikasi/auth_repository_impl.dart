import 'package:santai/app/data/models/authentikasi/auth_forgot_password_res_model.dart';
import 'package:santai/app/data/models/authentikasi/auth_otp_req_req_model.dart';
import 'package:santai/app/data/models/authentikasi/auth_sign_out_model.dart';
import 'package:santai/app/data/models/authentikasi/auth_sign_in_req_model.dart';
import 'package:santai/app/data/models/authentikasi/auth_user_reg_req_model.dart';

import 'package:santai/app/data/models/authentikasi/auth_otp_reg_ver_req_model.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_otp_register_verify.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_otp_register_verify_res.dart';

import 'package:santai/app/domain/entities/authentikasi/auth_signin_google.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_signin_google_res.dart';
import 'package:santai/app/data/models/authentikasi/auth_sign_in_google_req_model.dart';

import 'package:santai/app/domain/entities/authentikasi/auth_signin_staff.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_signin_staff_res.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_signout.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_verify_login.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_verify_login_res.dart';

import 'package:santai/app/domain/entities/authentikasi/auth_signin_user.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_signin_user_res.dart';

import 'package:santai/app/data/models/authentikasi/auth_verify_login_req_model.dart';

import 'package:santai/app/domain/entities/authentikasi/auth_user_register.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_user_register_res.dart';
import 'package:santai/app/domain/entities/authentikasi/otp_request.dart';
import 'package:santai/app/domain/entities/authentikasi/otp_request_res.dart';
import 'package:santai/app/domain/entities/authentikasi/password_reset.dart';

import 'package:santai/app/data/models/authentikasi/auth_sign_in_staff_req_model.dart';

import '../../../domain/repository/authentikasi/auth_repository.dart';
import '../../datasources/authentikasi/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SigninUserResponse?> signinUser(SigninUser user) async {
    final signinUserModel = SigninUserModel.fromEntity(user);
    final response = await remoteDataSource.signinUser(signinUserModel);
    return response;
  }

  @override
  Future<SigninStaffResponse?> signinStaff(SigninStaff user) async {
    final signinStaffModel = SigninStaffModel.fromEntity(user);
    final response = await remoteDataSource.signinStaff(signinStaffModel);
    return response;
  }

  @override
  Future<SigninGoogleResponse?> signinGoogle(SigninGoogle user) async {
    final signinGoogleModel = SigninGoogleModel.fromEntity(user);
    final response = await remoteDataSource.signinGoogle(signinGoogleModel);
    return response;
  }

  @override
  Future<UserRegisterResponse?> registerUser(UserRegister user) async {
    final userModel = UserRegisterModel.fromEntity(user);
    final response = await remoteDataSource.registerUser(userModel);
    return response;
  }

  @override
  Future<OtpRequestResponse?> sendOtp(OtpRequest request) async {
    final otpRequestModel = OtpRequestModel.fromEntity(request);
    final response = await remoteDataSource.sendOtp(otpRequestModel);
    return response;
  }

  @override
  Future<OtpRegisterVerifyResponse?> otpRegisterVerify(
      OtpRegisterVerify request) async {
    final otpRegisterVerifyModel = OtpRegisterVerifyModel.fromEntity(request);
    final response =
        await remoteDataSource.otpRegisterVerify(otpRegisterVerifyModel);
    return response;
  }

  @override
  Future<VerifyLoginResponse?> verifyLogin(VerifyLogin request) async {
    final verifyLoginModel = VerifyLoginModel.fromEntity(request);
    final response = await remoteDataSource.verifyLogin(verifyLoginModel);
    return response;
  }

  @override
  Future<void> signOut(SignOut request) async {
    final signOutModel = SignOutModel.fromEntity(request);
    await remoteDataSource.signOut(signOutModel);
  }

  @override
  Future<bool> resetPassword(PasswordReset reset) async {
    final response = await remoteDataSource.resetPassword(
        reset.identity, reset.otpCode, reset.newPassword);
    return response;
  }

  @override
  Future<ForgotPasswordResponseModel?> forgotPassword(
      String phoneNumber) async {
    final response = await remoteDataSource.forgotPassword(phoneNumber);
    return response;
  }

  // Similar methods for registerUser, sendOtp, and resetPassword
}
