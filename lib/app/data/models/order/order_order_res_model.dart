import 'package:santai/app/domain/entities/order/order_order_res.dart';

class OrderResponseModel extends OrderResponse {
  OrderResponseModel({
    required bool isSuccess,
    required OrderResponseDataModel data,
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

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      isSuccess: json['isSuccess'],
      data: OrderResponseDataModel.fromJson(json['data']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
      next: json['next'],
    );
  }
}

class OrderResponseDataModel extends OrderResponseData {
  OrderResponseDataModel({
    required String orderId,
    required String secret,
    required String addressLine,
    required double latitude,
    required double longitude,
    required BuyerModel buyer,
    MechanicModel? mechanic,
    required List<LineItemModel> lineItems,
    required List<FleetModel> fleets,
    required DateTime createdAtUtc,
    required bool isScheduled,
    DateTime? scheduledAtUtc,
    PaymentModel? payment,
    String? paymentUrl,
    required DateTime paymentExpiration,
    required String currency,
    required double orderAmount,
    DiscountModel? discount,
    required double grandTotal,
    RatingModel? orderRating,
    List<String>? ratingImages,
    required List<FeeModel> fees,
    CancellationModel? cancellation,
    required String orderStatus,
    required bool isPaid,
    required bool isRated,
    required bool isPaymentExpire,
  }) : super(
          orderId: orderId,
          secret: secret,
          addressLine: addressLine,
          latitude: latitude,
          longitude: longitude,
          buyer: buyer,
          mechanic: mechanic,
          lineItems: lineItems,
          fleets: fleets,
          createdAtUtc: createdAtUtc,
          isScheduled: isScheduled,
          scheduledAtUtc: scheduledAtUtc,
          payment: payment,
          paymentUrl: paymentUrl,
          paymentExpiration: paymentExpiration,
          currency: currency,
          orderAmount: orderAmount,
          discount: discount,
          grandTotal: grandTotal,
          orderRating: orderRating,
          ratingImages: ratingImages,
          fees: fees,
          cancellation: cancellation,
          orderStatus: orderStatus,
          isPaid: isPaid,
          isRated: isRated,
          isPaymentExpire: isPaymentExpire,
        );

  factory OrderResponseDataModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseDataModel(
      orderId: json['orderId'],
      secret: json['secret'],
      addressLine: json['addressLine'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      buyer: BuyerModel.fromJson(json['buyer']),
      mechanic: json['mechanic'] != null ? MechanicModel.fromJson(json['mechanic']) : null,
      lineItems: (json['lineItems'] as List)
          .map((item) => LineItemModel.fromJson(item))
          .toList(),
      fleets: (json['fleets'] as List)
          .map((fleet) => FleetModel.fromJson(fleet))
          .toList(),
      createdAtUtc: DateTime.parse(json['createdAtUtc']),
      isScheduled: json['isScheduled'],
      scheduledAtUtc: json['scheduledAtUtc'] != null ? DateTime.parse(json['scheduledAtUtc']) : null,
      payment: json['payment'] != null ? PaymentModel.fromJson(json['payment']) : null,
      paymentUrl: json['paymentUrl'],
      paymentExpiration: DateTime.parse(json['paymentExpiration']),
      currency: json['currency'],
      orderAmount: (json['orderAmount'] as num).toDouble(),
      discount: json['discount'] != null ? DiscountModel.fromJson(json['discount']) : null,
      grandTotal: (json['grandTotal'] as num).toDouble(),
      orderRating: json['orderRating'] != null ? RatingModel.fromJson(json['orderRating']) : null,
      ratingImages: (json['ratingImages'] as List?)?.cast<String>(),
      fees: (json['fees'] as List)
          .map((fee) => FeeModel.fromJson(fee))
          .toList(),
      cancellation: json['cancellation'] != null ? CancellationModel.fromJson(json['cancellation']) : null,
      orderStatus: json['orderStatus'],
      isPaid: json['isPaid'],
      isRated: json['isRated'],
      isPaymentExpire: json['isPaymentExpire'],
    );
  }
}

class BuyerModel extends Buyer {
  BuyerModel({
    required String buyerId,
    required String buyerName,
    String? email,
    String? phoneNumber,
  }) : super(
          buyerId: buyerId,
          buyerName: buyerName,
          email: email,
          phoneNumber: phoneNumber,
        );

  factory BuyerModel.fromJson(Map<String, dynamic> json) {
    return BuyerModel(
      buyerId: json['buyerId'],
      buyerName: json['buyerName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }
}

class MechanicModel extends Mechanic {
  MechanicModel({
    required String mechanicId,
    required String name,
    RatingModel? rating,
    required double performance,
    required bool isRated,
  }) : super(
          mechanicId: mechanicId,
          name: name,
          rating: rating,
          performance: performance,
          isRated: isRated,
        );

  factory MechanicModel.fromJson(Map<String, dynamic> json) {
    return MechanicModel(
      mechanicId: json['mechanicId'],
      name: json['name'],
      rating: json['rating'] != null ? RatingModel.fromJson(json['rating']) : null,
      performance: (json['performance'] as num).toDouble(),
      isRated: json['isRated'],
    );
  }
}

class LineItemModel extends LineItem {
  LineItemModel({
    required String lineItemId,
    required String name,
    required String sku,
    required double unitPrice,
    required String currency,
    required int quantity,
    double? taxPercentage,
    double? taxValue,
    required double subTotal,
  }) : super(
          lineItemId: lineItemId,
          name: name,
          sku: sku,
          unitPrice: unitPrice,
          currency: currency,
          quantity: quantity,
          taxPercentage: taxPercentage,
          taxValue: taxValue,
          subTotal: subTotal,
        );

  factory LineItemModel.fromJson(Map<String, dynamic> json) {
    return LineItemModel(
      lineItemId: json['lineItemId'],
      name: json['name'],
      sku: json['sku'],
      unitPrice: (json['unitPrice'] as num).toDouble(),
      currency: json['currency'],
      quantity: json['quantity'],
      taxPercentage: json['taxPercentage'] != null ? (json['taxPercentage'] as num).toDouble() : null,
      taxValue: json['taxValue'] != null ? (json['taxValue'] as num).toDouble() : null,
      subTotal: (json['subTotal'] as num).toDouble(),
    );
  }
}

class FleetModel extends Fleet {
  FleetModel({
    required String fleetId,
    required String brand,
    required String model,
    required String registrationNumber,
    String? imageUrl,
    required List<BasicInspectionModel> basicInspections,
    required List<PreServiceInspectionModel> preServiceInspections,
  }) : super(
          fleetId: fleetId,
          brand: brand,
          model: model,
          registrationNumber: registrationNumber,
          imageUrl: imageUrl,
          basicInspections: basicInspections,
          preServiceInspections: preServiceInspections,
        );

  factory FleetModel.fromJson(Map<String, dynamic> json) {
    return FleetModel(
      fleetId: json['fleetId'],
      brand: json['brand'],
      model: json['model'],
      registrationNumber: json['registrationNumber'],
      imageUrl: json['imageUrl'],
      basicInspections: (json['basicInspections'] as List)
          .map((inspection) => BasicInspectionModel.fromJson(inspection))
          .toList(),
      preServiceInspections: (json['preServiceInspections'] as List)
          .map((inspection) => PreServiceInspectionModel.fromJson(inspection))
          .toList(),
    );
  }
}

class PaymentModel extends Payment {
  PaymentModel({
    required String currency,
    required double amount,
    DateTime? paidAt,
    String? paymentMethod,
    String? bankReference,
  }) : super(
          currency: currency,
          amount: amount,
          paidAt: paidAt,
          paymentMethod: paymentMethod,
          bankReference: bankReference,
        );

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      currency: json['currency'],
      amount: (json['amount'] as num).toDouble(),
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
      paymentMethod: json['paymentMethod'],
      bankReference: json['bankReference'],
    );
  }
}

class DiscountModel extends Discount {
  DiscountModel({
    required String couponCode,
    required PercentageOrValueType parameter,
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
          discountAmount: discountAmount,
        );

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      couponCode: json['couponCode'],
      parameter: PercentageOrValueType.values.firstWhere((e) => e.toString() == 'PercentageOrValueType.${json['parameter']}'),
      currency: json['currency'],
      valuePercentage: (json['valuePercentage'] as num).toDouble(),
      valueAmount: (json['valueAmount'] as num).toDouble(),
      minimumOrderValue: (json['minimumOrderValue'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num).toDouble(),
    );
  }
}

class RatingModel extends Rating {
  RatingModel({
    required double value,
    String? comment,
  }) : super(
          value: value,
          comment: comment,
        );

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      value: (json['value'] as num).toDouble(),
      comment: json['comment'],
    );
  }
}

class BasicInspectionModel extends BasicInspection {
  BasicInspectionModel({
    required String description,
    required String parameter,
    required int value,
  }) : super(
          description: description,
          parameter: parameter,
          value: value,
        );

  factory BasicInspectionModel.fromJson(Map<String, dynamic> json) {
    return BasicInspectionModel(
      description: json['description'],
      parameter: json['parameter'],
      value: json['value'],
    );
  }
}

class PreServiceInspectionModel extends PreServiceInspection {
  PreServiceInspectionModel({
    required String description,
    required String parameter,
    required int rating,
    required List<PreServiceInspectionResultModel> preServiceInspectionResults,
  }) : super(
          description: description,
          parameter: parameter,
          rating: rating,
          preServiceInspectionResults: preServiceInspectionResults,
        );

  factory PreServiceInspectionModel.fromJson(Map<String, dynamic> json) {
    return PreServiceInspectionModel(
      description: json['description'],
      parameter: json['parameter'],
      rating: json['rating'],
      preServiceInspectionResults: (json['preServiceInspectionResults'] as List)
          .map((result) => PreServiceInspectionResultModel.fromJson(result))
          .toList(),
    );
  }
}

class PreServiceInspectionResultModel extends PreServiceInspectionResult {
  PreServiceInspectionResultModel({
    required String description,
    required String parameter,
    required bool isWorking,
  }) : super(
          description: description,
          parameter: parameter,
          isWorking: isWorking,
        );

  factory PreServiceInspectionResultModel.fromJson(Map<String, dynamic> json) {
    return PreServiceInspectionResultModel(
      description: json['description'],
      parameter: json['parameter'],
      isWorking: json['isWorking'],
    );
  }
}

class FeeModel extends Fee {
  FeeModel({
    required PercentageOrValueType parameter,
    required String feeDescription,
    required String currency,
    required double valuePercentage,
    required double valueAmount,
    required double feeAmount,
  }) : super(
          parameter: parameter,
          feeDescription: feeDescription,
          currency: currency,
          valuePercentage: valuePercentage,
          valueAmount: valueAmount,
          feeAmount: feeAmount,
        );

  factory FeeModel.fromJson(Map<String, dynamic> json) {
    return FeeModel(
      parameter: PercentageOrValueType.values.firstWhere((e) => e.toString() == 'PercentageOrValueType.${json['parameter']}'),
      feeDescription: json['feeDescription'],
      currency: json['currency'],
      valuePercentage: (json['valuePercentage'] as num).toDouble(),
      valueAmount: (json['valueAmount'] as num).toDouble(),
      feeAmount: (json['feeAmount'] as num).toDouble(),
    );
  }
}

class CancellationModel extends Cancellation {
  CancellationModel({
    List<FeeModel>? cancellationCharges,
    double? cancellationRefundAmount,
    String? currency,
  }) : super(
          cancellationCharges: cancellationCharges,
          cancellationRefundAmount: cancellationRefundAmount,
          currency: currency,
        );

  factory CancellationModel.fromJson(Map<String, dynamic> json) {
    return CancellationModel(
      cancellationCharges: json['cancellationCharges'] != null
          ? (json['cancellationCharges'] as List).map((fee) => FeeModel.fromJson(fee)).toList()
          : null,
      cancellationRefundAmount: json['cancellationRefundAmount'] != null ? (json['cancellationRefundAmount'] as num).toDouble() : null,
      currency: json['currency'],
    );
  }
}