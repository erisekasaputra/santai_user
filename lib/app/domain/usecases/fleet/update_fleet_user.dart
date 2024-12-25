import 'package:santai/app/domain/entities/fleet/fleet_user.dart';
import 'package:santai/app/domain/entities/fleet/fleet_user_res.dart';
import 'package:santai/app/domain/repository/fleet/fleet_repository.dart';

class UserUpdateFleet {
  final FleetRepository repository;

  UserUpdateFleet(this.repository);

  Future<FleetUserResponse> call(FleetUser user, String fleetId) async {
    try {
      return await repository.updateFleetUser(user, fleetId);
    } catch (e) {
      rethrow;
    }
  }
}