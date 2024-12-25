import 'package:santai/app/data/models/fleet/fleet_user_res_model.dart';
import 'package:santai/app/domain/entities/fleet/fleet_list_fleet_user_res.dart';

class FleetListFleetUserResponseModel extends FleetListFleetUserResponse {
  FleetListFleetUserResponseModel({
    required super.isSuccess,
    required FleetUserPaginatedListModel super.data,
    required super.message,
    required super.responseStatus,
    required super.errors,
    required super.links,
  });

  factory FleetListFleetUserResponseModel.fromJson(Map<String, dynamic> json) {
    return FleetListFleetUserResponseModel(
      isSuccess: json['isSuccess'],
      data: FleetUserPaginatedListModel.fromJson(json['data']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
    );
  }
}

class FleetUserPaginatedListModel extends FleetUserPaginatedList {
  FleetUserPaginatedListModel({
    required super.pageNumber,
    required super.pageSize,
    required super.pageCount,
    required super.totalPages,
    required List<FleetUserDataModel> super.items,
  });

  factory FleetUserPaginatedListModel.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<FleetUserDataModel> items =
        itemsList.map((item) => FleetUserDataModel.fromJson(item)).toList();

    return FleetUserPaginatedListModel(
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      pageCount: json['pageCount'],
      totalPages: json['totalPages'],
      items: items,
    );
  }
}
