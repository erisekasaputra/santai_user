import 'package:get/get.dart';

class HistoryController extends GetxController {
  final orders = <Order>[].obs;
  final filteredOrders = <Order>[].obs;
  final selectedFilter = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Load dummy data
    orders.addAll([
      Order(
        orderId: '000228',
        date: '24/11/2024',
        status: 'Successful',
        description: 'Kenderaan dalam keadaan yang baik setelah menjalani service, pertukaran brek pad, minyak hitam, & spark plug. Rujukan tayar perlu ditukar di panel bengkel kami.',
      ),
      Order(
        orderId: '000227',
        date: '23/11/2024',
        status: 'Canceled',
        description: 'Kenderaan dalam keadaan yang baik setelah menjalani service, pertukaran brek pad, minyak hitam, & spark plug. Rujukan tayar perlu ditukar di panel bengkel kami.',
      ),
      Order(
        orderId: '000226',
        date: '22/11/2024',
        status: 'Refunded',
        description: 'Kenderaan dalam keadaan yang baik setelah menjalani service, pertukaran brek pad, minyak hitam, & spark plug. Rujukan tayar perlu ditukar di panel bengkel kami.',
      ),
    ]);
    filteredOrders.addAll(orders);
  }

  void filterOrders(String query) {
    if (query.isEmpty) {
      filteredOrders.value = orders;
    } else {
      filteredOrders.value = orders.where((order) =>
        order.orderId.toLowerCase().contains(query.toLowerCase()) ||
        order.description.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
  }

  void setFilter(String filter) {
    if (selectedFilter.value == filter) {
      selectedFilter.value = '';
      filteredOrders.value = orders;
    } else {
      selectedFilter.value = filter;
      filteredOrders.value = orders.where((order) => order.status == filter).toList();
    }
  }
}

class Order {
  final String orderId;
  final String date;
  final String status;
  final String description;

  Order({
    required this.orderId,
    required this.date,
    required this.status,
    required this.description,
  });
}