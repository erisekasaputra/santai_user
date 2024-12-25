import 'package:santai/app/core/base_response.dart';
import 'package:santai/app/domain/entities/order/item_and_fleet_unprocessable.dart';

class OrderUnprocessableFleetItemResModel
    extends BaseResponse<OrderUnprocessableFleetItemDataResModel> {
  OrderUnprocessableFleetItemResModel({
    required super.isSuccess,
    required super.data,
    required super.message,
    required super.responseStatus,
    required super.errors,
    required super.links,
    super.next,
  });

  factory OrderUnprocessableFleetItemResModel.fromJson(
      Map<String, dynamic> json) {
    return OrderUnprocessableFleetItemResModel(
      isSuccess: json['isSuccess'],
      data: OrderUnprocessableFleetItemDataResModel.fromJson(json['data']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
      next: json['next'],
    );
  }
}

class OrderUnprocessableFleetItemDataResModel
    extends ItemAndFleetUnprocessable {
  OrderUnprocessableFleetItemDataResModel({super.fleets, super.items});

  factory OrderUnprocessableFleetItemDataResModel.fromJson(
      Map<String, dynamic> json) {
    return OrderUnprocessableFleetItemDataResModel(
      fleets: json['fleets'] != null
          ? List<String>.from(json['fleets'] as List)
          : null,
      items: json['items'] != null
          ? List<String>.from(json['items'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fleets': fleets,
      'items': items,
    };
  }
}
