import 'package:santai/app/domain/entities/order/order_order_res.dart';
import 'package:santai/app/domain/repository/order/order_repository.dart';

class SingleOrderDetail {
  final OrderRepository repository;

  SingleOrderDetail(this.repository);

  Future<OrderResponse?> call(String orderId) async {
    try {
      return await repository.getSingleOrderDetail(orderId);
    } catch (e) {
      rethrow;
    }
  }
}
