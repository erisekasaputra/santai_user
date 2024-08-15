import 'package:santai/app/domain/entities/user.dart';

abstract class UserRepository {
  Future<User> login(String phone, String password);
}

