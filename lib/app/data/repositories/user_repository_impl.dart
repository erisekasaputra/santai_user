import 'package:santai/app/data/repositories/user_repository.dart';
import 'package:santai/app/domain/entities/user.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<User> login(String phone, String password) async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 2));
    return User(phone: phone, password: password); // Return user data
  }
}