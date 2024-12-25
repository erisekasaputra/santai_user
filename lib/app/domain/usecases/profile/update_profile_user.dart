import 'package:santai/app/domain/entities/profile/profile_user.dart';
import 'package:santai/app/domain/entities/profile/profile_user_res.dart';
import 'package:santai/app/domain/repository/profile/profile_repository.dart';


class UserUpdateProfile {
  final ProfileRepository repository;

  UserUpdateProfile(this.repository);

  Future<ProfileUserResponse> call(ProfileUser user) async {
    try {
      return await repository.updateProfileUser(user);
    } catch (e) {
      rethrow;
    }
  }
}