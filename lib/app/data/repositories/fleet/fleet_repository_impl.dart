import 'package:santai/app/data/datasources/fleet/fleet_remote_data_source.dart';
import 'package:santai/app/data/models/fleet/fleet_list_fleet_user_res_model.dart';
import 'package:santai/app/data/models/fleet/fleet_user_res_model.dart';
import 'package:santai/app/data/models/fleet/fleet_user_req_model.dart';
import 'package:santai/app/domain/entities/fleet/fleet_user.dart';
import 'package:santai/app/domain/repository/fleet/fleet_repository.dart';

class FleetRepositoryImpl implements FleetRepository {
  final FleetRemoteDataSource remoteDataSource;

  FleetRepositoryImpl({required this.remoteDataSource});

  @override
  Future<FleetUserResponseModel> insertFleetUser(FleetUser user) async {
    final fleetUserModel = FleetUserReqModel.fromEntity(user);
    final response = await remoteDataSource.insertFleetUser(fleetUserModel);
    return response;
  }

  @override
  Future<FleetListFleetUserResponseModel> getListFleetUser() async {
    final response = await remoteDataSource.getListFleetUser();
    return response;
  }
}
  