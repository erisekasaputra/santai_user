import 'package:santai/app/domain/entities/order/order_order_req.dart';
import 'package:santai/app/domain/entities/order/order_order_res.dart';
import 'package:santai/app/domain/repository/order/order_repository.dart';

class CreateOrder {
  final OrderRepository repository;

  CreateOrder(this.repository);

  Future<OrderResponse> call(OrderRequest order) async {
    // return await repository.createOrder(order);
    try {
      return await repository.createOrder(order);
    } catch (e) {
      rethrow;
    }
  }
}
