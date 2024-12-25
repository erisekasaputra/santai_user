import 'package:santai/app/data/models/profile/business_profile_user_res_model.dart';
import 'package:santai/app/data/models/profile/staff_profile_user_res_model.dart';
import 'package:santai/app/domain/entities/profile/profile_user.dart';
import 'package:santai/app/domain/entities/profile/profile_user_res.dart';

abstract class ProfileRepository {
  Future<ProfileUserResponse> insertProfileUser(ProfileUser user);
  Future<ProfileUserResponse?> getProfileUser(String userId);
  Future<ProfileUserResponse> updateProfileUser(ProfileUser user);
  Future<BusinessProfileUserResModel?> getBusinessProfileUser(String userId);
  Future<StaffProfileUserResModel?> getStaffProfileUser(String userId);
  Future<bool> updateUserProfilePicture(String path);
}
