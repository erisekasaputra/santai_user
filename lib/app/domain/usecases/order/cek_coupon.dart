import 'package:santai/app/domain/repository/order/order_repository.dart';
import 'package:santai/app/domain/entities/order/order_cek_coupons.dart';

class CheckCoupon {
  final OrderRepository repository;

  CheckCoupon(this.repository);

  Future<OrderCekCouponsResponse?> call(String couponCode) async {
    try {
      return await repository.checkCoupon(couponCode);
    } catch (e) {
      rethrow;
    }
  }
}
