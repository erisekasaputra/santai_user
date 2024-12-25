import 'package:santai/app/domain/entities/fleet/fleet_list_fleet_user_res.dart';
import 'package:santai/app/domain/entities/fleet/fleet_user.dart';
import 'package:santai/app/domain/entities/fleet/fleet_user_res.dart';

abstract class FleetRepository {
  Future<FleetUserResponse> insertFleetUser(FleetUser user);
  Future<FleetListFleetUserResponse> getListFleetUser();
  Future<FleetUserResponse> getFleetUserById(String fleetId);
  Future<FleetUserResponse> updateFleetUser(FleetUser user, String fleetId);
}
