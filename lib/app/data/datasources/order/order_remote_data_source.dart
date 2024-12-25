import 'package:santai/app/config/api_config.dart';
import 'package:santai/app/data/models/order/order_actives_res_model.dart';
import 'package:santai/app/data/models/order/order_cek_coupon_res.dart';
import 'package:santai/app/data/models/order/order_order_req_model.dart';
import 'package:santai/app/data/models/order/order_order_res_model.dart';

import 'package:santai/app/data/models/order/order_calculation_req_model.dart';
import 'package:santai/app/data/models/order/order_calculation_res_model.dart';
import 'package:santai/app/data/models/order/order_unprocessable_fleet_item_res_model.dart';
import 'package:santai/app/data/models/order/orders_model.dart';
import 'package:santai/app/domain/entities/order/order_service_active_res.dart';
import 'package:santai/app/domain/entities/order/paginated_order_response.dart';

import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/services/auth_http_client.dart';
import 'package:santai/app/utils/http_error_handler.dart';
import 'package:santai/app/utils/int_extension_method.dart';

import 'package:uuid/uuid.dart';
import 'dart:convert';

abstract class OrderRemoteDataSource {
  Future<
      (
        bool isSuccess,
        OrderResponseModel? orderResponseModel,
        OrderUnprocessableFleetItemResModel? unprocessableResponse
      )> createOrder(OrderRequestModel order);
  Future<OrderCalculationResponseModel> calculateOrder(
      OrderCalculationRequestModel order);
  Future<OrderCekCouponsResponseModel?> checkCoupon(String couponCode);
  Future<OrderActiveResponse?> getActiveOrders();
  Future<OrderResponseModel?> getSingleOrderDetail(String orderId);
  Future<PaginatedOrderResponse?> getPaginatedOrders(
      int pageNumber, int pageSiz,
      {String? orderStatus});
  Future<bool> cancelOrder(String orderId);
  Future<bool> rateOrder(String orderId, int value, String comment);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final AuthHttpClient client;
  final String baseUrl;

  OrderRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = ApiConfigOrder.baseUrl,
  });

  @override
  Future<
      (
        bool isSuccess,
        OrderResponseModel? orderResponseModel,
        OrderUnprocessableFleetItemResModel? unprocessableResponse
      )> createOrder(OrderRequestModel order) async {
    const uuid = Uuid();
    final idempotencyKey = uuid.v4();

    var response = await client.post(
      Uri.parse('$baseUrl/orders'),
      headers: {
        'Content-Type': 'application/json',
        'X-Idempotency-Key': idempotencyKey,
      },
      body: json.encode(order.toJson()),
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      if (response.body.isEmpty) {
        throw CustomHttpException(500, 'Internal server error');
      } else {
        return (
          true,
          OrderResponseModel.fromJson(jsonDecode(response.body)),
          null
        );
      }
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Your access is forbidden');
    }

    if (response.statusCode.isHttpResponseUnprocessableEntity()) {
      if (response.body.isEmpty) {
        throw CustomHttpException(500, 'Internal server error');
      } else {
        return (
          false,
          null,
          OrderUnprocessableFleetItemResModel.fromJson(
              jsonDecode(response.body))
        );
      }
    }

    handleError(response, 'Unable to create order. Please try again shortly');
    throw Exception();
  }

  @override
  Future<OrderCalculationResponseModel> calculateOrder(
      OrderCalculationRequestModel order) async {
    const uuid = Uuid();
    final idempotencyKey = uuid.v4();

    var response = await client.post(
      Uri.parse('$baseUrl/orders/calculate'),
      headers: {
        'Content-Type': 'application/json',
        'X-Idempotency-Key': idempotencyKey,
      },
      body: json.encode(order.toJson()),
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      if (response.body.isEmpty) {
        throw CustomHttpException(500, 'Internal server error');
      } else {
        return OrderCalculationResponseModel.fromJson(
            jsonDecode(response.body));
      }
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Your access is forbidden');
    }

    handleError(
        response, 'Unable to calculate order. Please try again shortly');
    throw Exception();
  }

  @override
  Future<OrderCekCouponsResponseModel?> checkCoupon(String couponCode) async {
    var response = await client.get(
      Uri.parse('$baseUrl/coupons/code?code=$couponCode'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode.isHttpResponseNotFound()) {
      return null;
    }

    if (response.statusCode.isHttpResponseSuccess()) {
      return OrderCekCouponsResponseModel.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Your access is forbidden');
    }

    handleError(
        response, 'Unable to validate coupon code. Please try again shortly');
    return null;
  }

  @override
  Future<OrderActiveResponse?> getActiveOrders() async {
    var response = await client.get(
      Uri.parse('$baseUrl/orders/active'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode.isHttpResponseNotFound()) {
      return null;
    }

    if (response.statusCode.isHttpResponseSuccess()) {
      var body = jsonDecode(response.body);
      return OrderActivesResponseModel.fromJson(body);
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Your access is forbidden');
    }

    handleError(
        response, 'Unable to get active orders. Please try again shortly');
    return null;
  }

  @override
  Future<OrderResponseModel?> getSingleOrderDetail(String orderId) async {
    var response = await client.get(Uri.parse('$baseUrl/orders/$orderId'),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode.isHttpResponseNotFound()) {
      return null;
    }

    if (response.statusCode.isHttpResponseSuccess()) {
      return OrderResponseModel.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Your access is forbidden');
    }

    handleError(response, 'Unable to get order data. Please try again shortly');
    return null;
  }

  @override
  Future<PaginatedOrderResponse?> getPaginatedOrders(
      int pageNumber, int pageSize,
      {String? orderStatus}) async {
    var response = await client.get(
        Uri.parse(
            '$baseUrl/orders?pageNumber=$pageNumber&pageSize=$pageSize${orderStatus == null ? '&orderStatus=' : '&orderStatus=$orderStatus'}'),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode.isHttpResponseNotFound()) {
      return null;
    }

    if (response.statusCode.isHttpResponseSuccess()) {
      var responseBody = jsonDecode(response.body);
      var data = PaginatedOrderResponseModel.fromJson(responseBody);
      return data;
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Your access is forbidden');
    }

    handleError(response, 'Unable to get order data. Please try again shortly');
    return null;
  }

  @override
  Future<bool> cancelOrder(String orderId) async {
    var response = await client.patch(
        Uri.parse('$baseUrl/orders/$orderId/buyer/cancel'),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode.isHttpResponseSuccess()) {
      return true;
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Your access is forbidden');
    }

    handleError(
        response, 'Unable to cancel the order. Please try again shortly');
    return false;
  }

  @override
  Future<bool> rateOrder(String orderId, int value, String comment) async {
    var response = await client.put(
        Uri.parse('$baseUrl/orders/$orderId/rating'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'value': value, 'comment': comment, 'images': null}));

    if (response.statusCode.isHttpResponseSuccess()) {
      return true;
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Your access is forbidden');
    }

    handleError(response, 'Unable to rate the order. Please try again shortly');
    return false;
  }
}
