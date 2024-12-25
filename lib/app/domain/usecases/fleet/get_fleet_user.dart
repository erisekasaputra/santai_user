import 'package:santai/app/domain/entities/fleet/fleet_user_res.dart';
import 'package:santai/app/domain/repository/fleet/fleet_repository.dart';

class UserGetFleet {
  final FleetRepository repository;

  UserGetFleet(this.repository);

  Future<FleetUserResponse> call(String fleetId) async {
    try {
      return await repository.getFleetUserById(fleetId);
    } catch (e) {
      rethrow;
    }
  }
}