import 'package:get/get.dart';

class CheckoutController extends GetxController {
  final isScheduleOn = false.obs;
  final selectedDate = 'mm/dd/yyyy'.obs;
  final selectedTime = '10:00 PM'.obs;

  final promotionCode = ''.obs;
  final sCareRewardValue = 0.0.obs;


  final items = [
    {'name': 'F900 Fully Synthetic 5W-50', 'price': 'RM62.00'},
    {'name': 'Apido Front Brake Pads', 'price': 'RM18.50'},
    {'name': 'RCB RearBrake Pads', 'price': 'RM40.00'},
    {'name': 'SSS Chain & Sprocket Set 15/34', 'price': 'RM95.00'},
  ];

  final totalItems = [
    {'name': 'Total', 'price': 'RM62.00'},
    {'name': 'Mechanic Fee', 'price': 'RM18.50'},
    {'name': 'Service Fee (5%)', 'price': 'RM40.00'},
    {'name': 'Promotion Code', 'price': 'RM95.00'},
    {'name': 'S-Care Reward', 'price': 'RM95.00'},
  ];

  final tipOptions = [
    'RM 2.00',
    'RM 5.00',
    'RM 10.00'
  ];
}
