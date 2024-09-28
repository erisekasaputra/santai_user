import 'package:santai/app/domain/entities/profile/profile_user.dart';
import 'package:santai/app/domain/entities/profile/profile_user_res.dart';
import 'package:santai/app/domain/repository/profile/profile_repository.dart';


class UserInsertProfile {
  final ProfileRepository repository;

  UserInsertProfile(this.repository);

  Future<ProfileUserResponse> call(ProfileUser user) async {
    return await repository.insertProfileUser(user);
  }
}