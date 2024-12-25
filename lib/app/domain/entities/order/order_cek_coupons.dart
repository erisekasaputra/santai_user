class OrderCekCouponsResponse {
  final bool isSuccess;
  final Coupon data;
  final String message;
  final String responseStatus;
  final List<dynamic> errors;
  final List<dynamic> links;
  final String? next;

  OrderCekCouponsResponse({
    required this.isSuccess,
    required this.data,
    required this.message,
    required this.responseStatus,
    required this.errors,
    required this.links,
    this.next,
  });
}

class CouponPaginatedList {
  final int pageNumber;
  final int pageSize;
  final int pageCount;
  final int totalPages;
  final List<Coupon> items;

  CouponPaginatedList({
    required this.pageNumber,
    required this.pageSize,
    required this.pageCount,
    required this.totalPages,
    required this.items,
  });
}

class Coupon {
  final String couponCode;
  final String parameter;
  final String currency;
  final double valuePercentage;
  final double valueAmount;
  final double minimumOrderValue;
  final int discountAmount;

  Coupon({
    required this.couponCode,
    required this.parameter,
    required this.currency,
    required this.valuePercentage,
    required this.valueAmount,
    required this.minimumOrderValue,
    required this.discountAmount,
  });
}
