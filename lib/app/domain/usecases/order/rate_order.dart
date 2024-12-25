import 'package:santai/app/domain/repository/order/order_repository.dart';

class RateOrder {
  final OrderRepository repository;

  RateOrder(this.repository);

  Future<bool> call(String orderId, int value, String comment) async {
    try {
      return await repository.rateOrder(orderId, value, comment);
    } catch (e) {
      rethrow;
    }
  }
}
