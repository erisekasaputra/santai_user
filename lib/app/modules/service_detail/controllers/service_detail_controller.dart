import 'package:get/get.dart';

class ServiceDetailController extends GetxController {
  late OrderDetails orderDetails;

  @override
  void onInit() {
    super.onInit();
   
    orderDetails = OrderDetails(
      orderId: '000228',
      date: '22/11/2024',
      location: 'Sunway Putra Tower, 100, Jalan Putra',
      technicianName: 'Brian Weaknes',
      status: 'Successful',
      updateDescription: 'Kenderaan dalam keadaan yang baik setelah menjalani service, pertukaran brek pad, minyak hitam, & spark plug. Rujukan tayar perlu ditukar di panel bengkel kami.',
      items: [
        {'name': 'F900 Fully Synthetic 5W-50', 'price': 'RM62.00'},
        {'name': 'Apido Front Brake Pads', 'price': 'RM18.50'},
        {'name': 'RCB RearBrake Pads', 'price': 'RM40.00'},
        {'name': 'SSS Chain & Sprocket Set 15/34', 'price': 'RM95.00'},
      ],
      totalItems: [
        {'name': 'Total', 'price': 'RM62.00'},
        {'name': 'Mechanic Fee', 'price': 'RM18.50'},
        {'name': 'Service Fee (5%)', 'price': 'RM40.00'},
        {'name': 'Promotion Code', 'price': 'RM95.00'},
        {'name': 'S-Care Reward', 'price': 'RM95.00'},
      ],
      grandTotal: 'RM95.00',
    );
  }
}

class OrderDetails {
  final String orderId;
  final String date;
  final String location;
  final String technicianName;
  final String status;
  final String updateDescription;
  final List<Map<String, String>> items;
  final List<Map<String, String>> totalItems;
  final String grandTotal;

  OrderDetails({
    required this.orderId,
    required this.date,
    required this.location,
    required this.technicianName,
    required this.status,
    required this.updateDescription,
    required this.items,
    required this.totalItems,
    required this.grandTotal,
  });
}