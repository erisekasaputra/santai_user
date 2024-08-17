import 'package:santai/app/data/repositories/user_repository.dart';
import 'package:santai/app/domain/entities/user_profile_reg.dart';


class RegisterUserProfileUseCase {
  final UserRepository _userRepository;

  RegisterUserProfileUseCase(this._userRepository);

  Future<void> execute(UserProfile userProfile) {
    return _userRepository.registerUserProfile(userProfile);
  }
}