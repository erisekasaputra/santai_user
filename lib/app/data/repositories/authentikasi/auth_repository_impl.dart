// lib/data/repositories/auth_repository_impl.dart


import 'package:santai/app/data/models/authentikasi/auth_user_reg_req_model.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_user_register.dart';
import 'package:santai/app/domain/entities/authentikasi/auth_user_register_res.dart';
import 'package:santai/app/domain/entities/authentikasi/otp_request.dart';
import 'package:santai/app/domain/entities/authentikasi/password_reset.dart';
import 'package:santai/app/domain/entities/authentikasi/user_staff.dart';

import '../../../domain/entities/authentikasi/user.dart';
import '../../../domain/repository/authentikasi/auth_repository.dart';
import '../../datasources/authentikasi/auth_remote_data_source.dart';
import '../../models/authentikasi/auth_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> loginUser(User user) async {
    return await remoteDataSource.loginUser(UserModel.fromEntity(user));
  }

  @override
  Future<void> loginStaff(UserStaff user) async {
    // return await remoteDataSource.loginStaff(UserModel.fromEntity(user));
  }

  @override
  Future<UserRegisterResponse> registerUser(UserRegister user) async {
    final userModel = UserRegisterModel.fromEntity(user);
    final response = await remoteDataSource.registerUser(userModel);
    return response;
  }
  
  @override
  Future<void> resetPassword(PasswordReset reset) {
    
    throw UnimplementedError();
  }
  
  @override
  Future<void> sendOtp(OtpRequest request) {
    // TODO: implement sendOtp
    throw UnimplementedError();
  }

  // Similar methods for registerUser, sendOtp, and resetPassword
}