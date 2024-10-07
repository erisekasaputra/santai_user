import 'package:santai/app/domain/entities/fleet/fleet_user.dart';
import 'package:santai/app/domain/entities/fleet/fleet_user_res.dart';
import 'package:santai/app/domain/repository/fleet/fleet_repository.dart';

class UserInsertFleet {
  final FleetRepository repository;

  UserInsertFleet(this.repository);

  Future<FleetUserResponse> call(FleetUser user) async {
    return await repository.insertFleetUser(user);
  }
}