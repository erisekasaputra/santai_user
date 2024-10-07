import 'package:santai/app/domain/entities/fleet/fleet_user.dart';

class FleetUserResponse {
  final bool isSuccess;
  final FleetUser data;
  final String message;
  final String responseStatus;
  final List<dynamic> errors;
  final List<dynamic> links;

  FleetUserResponse({
    required this.isSuccess,
    required this.data,
    required this.message,
    required this.responseStatus,
    required this.errors,
    required this.links,
  });
}
