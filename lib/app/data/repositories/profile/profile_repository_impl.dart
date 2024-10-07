import 'package:santai/app/data/datasources/profile/profile_remote_data_source.dart';

import 'package:santai/app/data/models/profile/profile_user_req_model.dart';
import 'package:santai/app/data/models/profile/profile_user_res_model.dart';

import 'package:santai/app/domain/entities/profile/profile_user.dart';
// import 'package:santai/app/domain/entities/profile/profile_user_res.dart';
import 'package:santai/app/domain/repository/profile/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ProfileUserResponseModel> insertProfileUser(ProfileUser user) async {
    final profileUserModel = ProfileUserReqModel.fromEntity(user);
    final response = await remoteDataSource.insertProfileUser(profileUserModel);
    return response;
  }

  @override
  Future<ProfileUserResponseModel> getProfileUser() async {
    final response = await remoteDataSource.getProfileUser();
    return response;
  }
}