import 'package:santai/app/domain/entities/order/paginated_order_response.dart';
import 'package:santai/app/domain/repository/order/order_repository.dart';

class GetOrders {
  final OrderRepository repository;

  GetOrders(this.repository);
  Future<PaginatedOrderResponse?> call(int pageNumber, int pageSize,
      {String? orderStatus}) async {
    try {
      return await repository.getPaginatedOrders(pageNumber, pageSize,
          orderStatus: orderStatus);
    } catch (e) {
      rethrow;
    }
  }
}
