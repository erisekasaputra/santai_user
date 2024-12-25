import 'package:santai/app/domain/entities/profile/profile_user_res.dart';
import 'package:santai/app/domain/repository/profile/profile_repository.dart';

class UserGetProfile {
  final ProfileRepository repository;

  UserGetProfile(this.repository);

  Future<ProfileUserResponse?> call(String userId) async {
    try {
      return await repository.getProfileUser(userId);
    } catch (e) {
      rethrow;
    }
  }
}
