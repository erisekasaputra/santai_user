import 'package:santai/app/data/datasources/order/order_remote_data_source.dart';
import 'package:santai/app/data/models/order/order_order_req_model.dart';
import 'package:santai/app/data/models/order/order_order_res_model.dart';
import 'package:santai/app/data/models/order/order_unprocessable_fleet_item_res_model.dart';
import 'package:santai/app/domain/entities/order/order_cek_coupons.dart';
import 'package:santai/app/domain/entities/order/order_order_req.dart';
import 'package:santai/app/domain/entities/order/order_order_res.dart';
import 'package:santai/app/domain/entities/order/order_service_active_res.dart';
import 'package:santai/app/domain/entities/order/paginated_order_response.dart';
import 'package:santai/app/domain/repository/order/order_repository.dart';

import 'package:santai/app/data/models/order/order_calculation_req_model.dart';
import 'package:santai/app/domain/entities/order/order_calculation_req.dart';
import 'package:santai/app/domain/entities/order/order_calculation_res.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<
      (
        bool isSuccess,
        OrderResponseModel? orderResponseModel,
        OrderUnprocessableFleetItemResModel? unprocessableResponse
      )> createOrder(OrderRequest order) async {
    try {
      final orderModel = OrderRequestModel.fromEntity(order);
      final response = await remoteDataSource.createOrder(orderModel);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OrderCalculationResponse> calculateOrder(
      OrderCalculationRequest order) async {
    try {
      final orderModel = OrderCalculationRequestModel.fromEntity(order);
      final response = await remoteDataSource.calculateOrder(orderModel);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OrderCekCouponsResponse?> checkCoupon(String couponCode) async {
    try {
      final response = await remoteDataSource.checkCoupon(couponCode);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OrderActiveResponse?> getActiveOrders() async {
    try {
      final response = await remoteDataSource.getActiveOrders();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OrderResponse?> getSingleOrderDetail(String orderId) async {
    try {
      final response = await remoteDataSource.getSingleOrderDetail(orderId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedOrderResponse?> getPaginatedOrders(pageNumber, pageSize,
      {String? orderStatus}) async {
    try {
      final response = await remoteDataSource
          .getPaginatedOrders(pageNumber, pageSize, orderStatus: orderStatus);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> cancelOrder(String orderId) async {
    try {
      final response = await remoteDataSource.cancelOrder(orderId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> rateOrder(String orderId, int value, String comment) async {
    try {
      final response =
          await remoteDataSource.rateOrder(orderId, value, comment);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
