import 'package:santai/app/data/models/order/order_order_res_model.dart';
import 'package:santai/app/data/models/order/order_unprocessable_fleet_item_res_model.dart';
import 'package:santai/app/domain/entities/order/order_order_req.dart';
import 'package:santai/app/domain/repository/order/order_repository.dart';

class CreateOrder {
  final OrderRepository repository;

  CreateOrder(this.repository);

  Future<
      (
        bool isSuccess,
        OrderResponseModel? orderResponseModel,
        OrderUnprocessableFleetItemResModel? unprocessableResponse
      )> call(OrderRequest order) async {
    try {
      return await repository.createOrder(order);
    } catch (e) {
      rethrow;
    }
  }
}
