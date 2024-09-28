import 'package:santai/app/domain/entities/profile/profile_user.dart';
import 'package:santai/app/domain/entities/profile/profile_user_res.dart';

abstract class ProfileRepository {
  Future<ProfileUserResponse> insertProfileUser(ProfileUser user);
}
