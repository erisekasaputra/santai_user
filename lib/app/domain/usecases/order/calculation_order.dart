import 'package:santai/app/domain/repository/order/order_repository.dart';
import 'package:santai/app/domain/entities/order/order_calculation_req.dart';
import 'package:santai/app/domain/entities/order/order_calculation_res.dart';

class CalculateOrder {
  final OrderRepository repository;

  CalculateOrder(this.repository);

  Future<OrderCalculationResponse> call(OrderCalculationRequest order) async {
    try {
      return await repository.calculateOrder(order);
    } catch (e) {
      rethrow;
    }
  }
}
