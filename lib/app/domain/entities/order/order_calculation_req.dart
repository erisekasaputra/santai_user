class OrderCalculationRequest {
  final String addressLine;
  final double latitude;
  final double longitude;
  final String currency;
  final bool isScheduled;
  final DateTime? scheduledAt;
  final double grandTotal;
  final String couponCode;
  final List<LineItem> lineItems;
  final List<Fleet> fleets;

  OrderCalculationRequest({
    required this.addressLine,
    required this.latitude,
    required this.longitude,
    required this.currency,
    required this.isScheduled,
    this.scheduledAt,
    required this.grandTotal,
    this.couponCode = "",
    required this.lineItems,
    required this.fleets,
  });
}

class LineItem {
  final String id;
  final int quantity;
  final double price;
  final String currency;

  LineItem({
    required this.id,
    required this.quantity,
    required this.price,
    required this.currency,
  });
}

class Fleet {
  final String id;

  Fleet({required this.id});
}