import 'package:santai/app/data/models/profile/staff_profile_user_res_model.dart';
import 'package:santai/app/domain/repository/profile/profile_repository.dart';

class GetStaffProfileUser {
  final ProfileRepository repository;

  GetStaffProfileUser(this.repository);

  Future<StaffProfileUserResModel?> call(String userId) async {
    try {
      return await repository.getStaffProfileUser(userId);
    } catch (e) {
      rethrow;
    }
  }
}
