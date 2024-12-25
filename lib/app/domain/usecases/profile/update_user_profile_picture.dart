import 'package:santai/app/domain/repository/profile/profile_repository.dart';

class UpdateUserProfilePicture {
  final ProfileRepository repository;

  UpdateUserProfilePicture(this.repository);

  Future<bool> call(String path) async {
    try {
      return await repository.updateUserProfilePicture(path);
    } catch (e) {
      rethrow;
    }
  }
}
