import 'package:santai/app/data/models/fleet/fleet_user_res_model.dart';
import 'package:santai/app/domain/entities/fleet/fleet_list_fleet_user_res.dart';

class FleetListFleetUserResponseModel extends FleetListFleetUserResponse {
  FleetListFleetUserResponseModel({
    required bool isSuccess,
    required FleetUserPaginatedListModel data,
    required String message,
    required String responseStatus,
    required List<dynamic> errors,
    required List<dynamic> links,
  }) : super(
          isSuccess: isSuccess,
          data: data,
          message: message,
          responseStatus: responseStatus,
          errors: errors,
          links: links,
        );

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
    required int pageNumber,
    required int pageSize,
    required int pageCount,
    required int totalPages,
    required List<FleetUserDataModel> items,
  }) : super(
          pageNumber: pageNumber,
          pageSize: pageSize,
          pageCount: pageCount,
          totalPages: totalPages,
          items: items,
        );

  factory FleetUserPaginatedListModel.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<FleetUserDataModel> items = itemsList
        .map((item) => FleetUserDataModel.fromJson(item))
        .toList();

    return FleetUserPaginatedListModel(
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      pageCount: json['pageCount'],
      totalPages: json['totalPages'],
      items: items,
    );
  }
}

