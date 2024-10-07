import 'package:santai/app/config/api_config.dart';
import 'package:santai/app/data/models/order/order_order_req_model.dart';
import 'package:santai/app/data/models/order/order_order_res_model.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/services/auth_http_client.dart';
// import 'package:santai/app/services/secure_storage_service.dart';

import 'package:uuid/uuid.dart';
import 'dart:convert';



abstract class OrderRemoteDataSource {
  Future<OrderResponseModel> createOrder(OrderRequestModel order);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final AuthHttpClient client;
  final String baseUrl;

  OrderRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = ApiConfigOrder.baseUrl,
  });

  @override
  Future<OrderResponseModel> createOrder(OrderRequestModel order) async {
    final uuid = Uuid();
    final idempotencyKey = uuid.v4();
    
    var response = await client.post(
      Uri.parse('$baseUrl/orders'),
      headers: {
        'Content-Type': 'application/json',
        'X-Idempotency-Key': idempotencyKey,
      },
      body: json.encode(order.toJson()),  
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return OrderResponseModel.fromJson(jsonDecode(response.body));
    } else {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw CustomHttpException(response.statusCode, responseBody['message'] ?? 'Failed to Create Order');
    }
  }
  // Future<OrderResponseModel> createOrder(OrderRequestModel order) async {
  //   final SecureStorageService secureStorage = SecureStorageService();
  //   final accessToken = await secureStorage.readSecureData('access_token');

  //   final uuid = Uuid();
  //   final idempotencyKey = uuid.v4();

  //   var response = await client.post(
  //     Uri.parse('$baseUrl/orders'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'X-Idempotency-Key': idempotencyKey,
  //       'Authorization': 'Bearer $accessToken',
  //     },
  //     body: json.encode(order.toJson()),  
      
  //   );

  //   if (response.statusCode >= 200 && response.statusCode < 300) {
  //     return OrderResponseModel.fromJson(jsonDecode(response.body));
  //   } else {
  //     final Map<String, dynamic> responseBody = json.decode(response.body);
  //     throw CustomHttpException(response.statusCode, responseBody['message'] ?? 'Failed to Create Order');
  //   }
  // }


}