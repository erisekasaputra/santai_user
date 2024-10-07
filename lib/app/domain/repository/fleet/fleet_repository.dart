import 'package:santai/app/domain/entities/fleet/fleet_list_fleet_user_res.dart';
import 'package:santai/app/domain/entities/fleet/fleet_user.dart';
import 'package:santai/app/domain/entities/fleet/fleet_user_res.dart';

abstract class FleetRepository {
  Future<FleetUserResponse> insertFleetUser(FleetUser user);
  Future<FleetListFleetUserResponse> getListFleetUser();
}
