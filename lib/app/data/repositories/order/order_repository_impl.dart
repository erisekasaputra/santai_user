import 'package:santai/app/data/datasources/order/order_remote_data_source.dart';
import 'package:santai/app/data/models/order/order_order_req_model.dart';
import 'package:santai/app/domain/entities/order/order_order_req.dart';
import 'package:santai/app/domain/entities/order/order_order_res.dart';
import 'package:santai/app/domain/repository/order/order_repository.dart';
// import 'package:santai/app/domain/usecases/order/create_order.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<OrderResponse> createOrder(OrderRequest order) async {
    // final orderModel = OrderRequestModel.fromEntity(order);
    // final response = await remoteDataSource.createOrder(orderModel);
    // return response;
    try {
      final orderModel = OrderRequestModel.fromEntity(order);
      final response = await remoteDataSource.createOrder(orderModel);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
