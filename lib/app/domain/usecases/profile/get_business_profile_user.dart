import 'package:santai/app/data/models/profile/business_profile_user_res_model.dart';
import 'package:santai/app/domain/repository/profile/profile_repository.dart';

class GetBusinessProfileUser {
  final ProfileRepository repository;

  GetBusinessProfileUser(this.repository);

  Future<BusinessProfileUserResModel?> call(String userId) async {
    try {
      return await repository.getBusinessProfileUser(userId);
    } catch (e) {
      rethrow;
    }
  }
}
