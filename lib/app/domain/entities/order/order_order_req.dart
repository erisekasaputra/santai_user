class OrderRequest {
  final String addressLine;
  final double latitude;
  final double longitude;
  final String currency;
  final bool isScheduled;
  final DateTime? scheduledAt;
  final String grandTotal;
  final String couponCode;
  final List<LineItem> lineItems;
  final List<Fleet> fleets;

  OrderRequest({
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

  LineItem({
    required this.id,
    required this.quantity,
  });
}

class Fleet {
  final String id;

  Fleet({required this.id});
}
