import 'package:santai/app/domain/entities/order/order_order_req.dart';

class OrderRequestModel extends OrderRequest {
  final List<LineItemModel> lineItemModels;
  final List<FleetModel> fleetModels;

  OrderRequestModel({
    required String addressLine,
    required double latitude,
    required double longitude,
    required String currency,
    required bool isScheduled,
    DateTime? scheduledAt,
    required String grandTotal,
    String couponCode = "",
    required List<LineItem> lineItems,
    required List<Fleet> fleets,
  }) : lineItemModels = lineItems.map((item) => LineItemModel.fromEntity(item)).toList(),
       fleetModels = fleets.map((fleet) => FleetModel.fromEntity(fleet)).toList(),
       super(
          addressLine: addressLine,
          latitude: latitude,
          longitude: longitude,
          currency: currency,
          isScheduled: isScheduled,
          scheduledAt: scheduledAt,
          grandTotal: grandTotal,
          couponCode: couponCode,
          lineItems: lineItems,
          fleets: fleets,
        );

  factory OrderRequestModel.fromEntity(OrderRequest orderRequest) {
    return OrderRequestModel(
      addressLine: orderRequest.addressLine,
      latitude: orderRequest.latitude,
      longitude: orderRequest.longitude,
      currency: orderRequest.currency,
      isScheduled: orderRequest.isScheduled,
      scheduledAt: orderRequest.scheduledAt,
      grandTotal: orderRequest.grandTotal,
      couponCode: orderRequest.couponCode,
      lineItems: orderRequest.lineItems,
      fleets: orderRequest.fleets,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addressLine': addressLine,
      'latitude': latitude,
      'longitude': longitude,
      'currency': currency,
      'isScheduled': isScheduled,
      'scheduledAt': scheduledAt?.toIso8601String(),
      'grandTotal': grandTotal,
      'couponCode': couponCode,
      'lineItems': lineItemModels.map((item) => item.toJson()).toList(),
      'fleets': fleetModels.map((fleet) => fleet.toJson()).toList(),
    };
  }
}

class LineItemModel extends LineItem {
  LineItemModel({
    required String id,
    required int quantity,
  }) : super(
          id: id,
          quantity: quantity,
        );

  factory LineItemModel.fromEntity(LineItem item) {
    return LineItemModel(
      id: item.id,
      quantity: item.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
    };
  }
}

class FleetModel extends Fleet {
  FleetModel({
    required String id,
  }) : super(id: id);

  factory FleetModel.fromEntity(Fleet fleet) {
    return FleetModel(
      id: fleet.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}