import 'package:santai/app/domain/entities/fleet/fleet_list_fleet_user_res.dart';
import 'package:santai/app/domain/repository/fleet/fleet_repository.dart';

class UserListFleet {
  final FleetRepository repository;

  UserListFleet(this.repository);

  Future<FleetListFleetUserResponse> call() async {
    try {
      return await repository.getListFleetUser();
    } catch (e) {
      rethrow;
    }
  }
}
