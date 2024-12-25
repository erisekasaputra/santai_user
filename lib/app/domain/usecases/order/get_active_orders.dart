import 'package:santai/app/domain/entities/order/order_service_active_res.dart';
import 'package:santai/app/domain/repository/order/order_repository.dart';

class ListActiveOrders {
  final OrderRepository repository;

  ListActiveOrders(this.repository);

  Future<OrderActiveResponse?> call() async {
    try {
      return await repository.getActiveOrders();
    } catch (e) {
      rethrow;
    }
  }
}
