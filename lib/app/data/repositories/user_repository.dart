import 'package:santai/app/domain/entities/user.dart';
import 'package:santai/app/domain/entities/user_profile_reg.dart';

abstract class UserRepository {
  Future<User> login(String phone, String password);
  Future<void> registerUserProfile(UserProfile userProfile);
}



