import 'package:santai/app/domain/entities/order/order_cek_coupons.dart';

class OrderCekCouponsResponseModel extends OrderCekCouponsResponse {
  OrderCekCouponsResponseModel({
    required bool isSuccess,
    required Coupon data,
    required String message,
    required String responseStatus,
    required List<dynamic> errors,
    required List<dynamic> links,
    dynamic next,
  }) : super(
          isSuccess: isSuccess,
          data: data,
          message: message,
          responseStatus: responseStatus,
          errors: errors,
          links: links,
          next: next,
        );

  factory OrderCekCouponsResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderCekCouponsResponseModel(
      isSuccess: json['isSuccess'],
      data: CouponItemModel.fromJson(json['data']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
      next: json['next'],
    );
  }
}

class CouponPaginatedListModel extends CouponPaginatedList {
  CouponPaginatedListModel({
    required int pageNumber,
    required int pageSize,
    required int pageCount,
    required int totalPages,
    required List<CouponItemModel> items,
  }) : super(
          pageNumber: pageNumber,
          pageSize: pageSize,
          pageCount: pageCount,
          totalPages: totalPages,
          items: items,
        );

  factory CouponPaginatedListModel.fromJson(Map<String, dynamic> json) {
    return CouponPaginatedListModel(
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      pageCount: json['pageCount'],
      totalPages: json['totalPages'],
      items: (json['items'] as List)
          .map((item) => CouponItemModel.fromJson(item))
          .toList(),
    );
  }
}

class CouponItemModel extends Coupon {
  CouponItemModel({
    required String couponCode,
    required String parameter,
    required String currency,
    required double valuePercentage,
    required double valueAmount,
    required double minimumOrderValue,
    required double discountAmount,
  }) : super(
          couponCode: couponCode,
          parameter: parameter,
          currency: currency,
          valuePercentage: valuePercentage,
          valueAmount: valueAmount,
          minimumOrderValue: minimumOrderValue,
          discountAmount: discountAmount.toInt(),
        );

  factory CouponItemModel.fromJson(Map<String, dynamic> json) {
    return CouponItemModel(
      couponCode: json['couponCode'],
      parameter: json['parameter'],
      currency: json['currency'],
      valuePercentage: (json['valuePercentage'] as num).toDouble(),
      valueAmount: (json['valueAmount'] as num).toDouble(),
      minimumOrderValue: (json['minimumOrderValue'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num).toDouble(),
    );
  }
}
