import 'package:santai/app/data/models/order/order_order_res_model.dart';
import 'package:santai/app/data/models/order/order_unprocessable_fleet_item_res_model.dart';
import 'package:santai/app/domain/entities/order/order_cek_coupons.dart';
import 'package:santai/app/domain/entities/order/order_order_req.dart';
import 'package:santai/app/domain/entities/order/order_order_res.dart';
import 'package:santai/app/domain/entities/order/order_calculation_req.dart';
import 'package:santai/app/domain/entities/order/order_calculation_res.dart';
import 'package:santai/app/domain/entities/order/order_service_active_res.dart';
import 'package:santai/app/domain/entities/order/paginated_order_response.dart';

abstract class OrderRepository {
  Future<
      (
        bool isSuccess,
        OrderResponseModel? orderResponseModel,
        OrderUnprocessableFleetItemResModel? unprocessableResponse
      )> createOrder(OrderRequest order);
  Future<OrderCalculationResponse> calculateOrder(
      OrderCalculationRequest order);
  Future<OrderCekCouponsResponse?> checkCoupon(String couponCode);
  Future<OrderActiveResponse?> getActiveOrders();
  Future<OrderResponse?> getSingleOrderDetail(String orderId);
  Future<PaginatedOrderResponse?> getPaginatedOrders(pageNumber, pageSize,
      {String? orderStatus});
  Future<bool> cancelOrder(String orderId);
  Future<bool> rateOrder(String orderId, int value, String comment);
}
