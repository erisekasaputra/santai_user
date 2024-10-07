import 'package:santai/app/domain/entities/fleet/fleet_user.dart';

class FleetListFleetUserResponse {
  final bool isSuccess;
  final FleetUserPaginatedList data;
  final String message;
  final String responseStatus;
  final List<dynamic> errors;
  final List<dynamic> links;

  FleetListFleetUserResponse({
    required this.isSuccess,
    required this.data,
    required this.message,
    required this.responseStatus,
    required this.errors,
    required this.links,
  });
}

class FleetUserPaginatedList {
  final int pageNumber;
  final int pageSize;
  final int pageCount;
  final int totalPages;
  final List<FleetUser> items;

  FleetUserPaginatedList({
    required this.pageNumber,
    required this.pageSize,
    required this.pageCount,
    required this.totalPages,
    required this.items,
  });
}
