import 'package:santai/app/domain/entities/order/order_service_active_res.dart';

class OrderActivesResponseModel extends OrderActiveResponse {
  OrderActivesResponseModel({
    required super.isSuccess,
    required List<OrderActiveResponseDataModel>
        super.data, // Menggunakan List untuk data
    required super.message,
    required super.responseStatus,
    required super.errors,
    required super.links,
    super.next,
  });

  factory OrderActivesResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderActivesResponseModel(
      isSuccess: json['isSuccess'],
      data: (json['data'] as List)
          .map((item) => OrderActiveResponseDataModel.fromJson(item))
          .toList(),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'] as List<dynamic>,
      links: json['links'] as List<dynamic>,
      next: json['next'],
    );
  }
}

class OrderActiveResponseDataModel extends OrderActiveResponseData {
  OrderActiveResponseDataModel({
    required super.id,
    required super.secret,
    required super.status,
    required super.step,
    required super.statuses,
  });

  factory OrderActiveResponseDataModel.fromJson(Map<String, dynamic> json) {
    return OrderActiveResponseDataModel(
      id: json['id'],
      secret: json['secret'],
      status: json['status'],
      step: json['step'],
      statuses: (json['statuses'] is List)
          ? (json['statuses'] as List).whereType<String>().toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'secret': secret,
      'status': status,
      'step': step,
      'statuses': statuses,
    };
  }
}
