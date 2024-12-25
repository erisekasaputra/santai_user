import 'package:santai/app/data/datasources/profile/profile_remote_data_source.dart';
import 'package:santai/app/data/models/profile/business_profile_user_res_model.dart';

import 'package:santai/app/data/models/profile/profile_user_req_model.dart';
import 'package:santai/app/data/models/profile/profile_user_res_model.dart';
import 'package:santai/app/data/models/profile/staff_profile_user_res_model.dart';
import 'package:santai/app/domain/entities/profile/profile_user.dart';
import 'package:santai/app/domain/repository/profile/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ProfileUserResponseModel> insertProfileUser(ProfileUser user) async {
    try {
      final profileUserModel = ProfileUserReqModel.fromEntity(user);
      final response =
          await remoteDataSource.insertProfileUser(profileUserModel);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProfileUserResponseModel?> getProfileUser(String userId) async {
    try {
      final response = await remoteDataSource.getProfileUser(userId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProfileUserResponseModel> updateProfileUser(ProfileUser user) async {
    try {
      final profileUserModel = ProfileUserReqModel.fromEntity(user);
      final response =
          await remoteDataSource.updateProfileUser(profileUserModel);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BusinessProfileUserResModel?> getBusinessProfileUser(
      String userId) async {
    try {
      final response =
          await remoteDataSource.getBusinessUserProfileUser(userId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<StaffProfileUserResModel?> getStaffProfileUser(String userId) async {
    try {
      final response = await remoteDataSource.getStaffProfileUser(userId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> updateUserProfilePicture(String path) async {
    try {
      final response = await remoteDataSource.updateProfilePicture(path);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
