import 'package:santai/app/domain/entities/order/order_order_req.dart';
import 'package:santai/app/domain/entities/order/order_order_res.dart';

abstract class OrderRepository {
  Future<OrderResponse> createOrder(OrderRequest order);
}
