import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_snackbar.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/domain/entities/order/order_order_req.dart';
import 'package:santai/app/domain/usecases/order/create_order.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/helpers/sqlite_db_helper.dart';
import 'package:santai/app/routes/app_pages.dart';

class CheckoutController extends GetxController {
  final isLoading = false.obs;
  final DatabaseHelper dbHelper = DatabaseHelper.instance;


  final fleetId = ''.obs;
  final selectedItems = <Map<String, dynamic>>[].obs;
  final totalPrice = 0.0.obs;

  final isScheduleOn = false.obs;
  final selectedDate = ''.obs;
  final selectedTime = ''.obs;

  final promotionCode = ''.obs;
  final sCareRewardValue = 0.0.obs;

  final isTipChecked = false.obs;

  final CreateOrder createOrder;
  CheckoutController({
    required this.createOrder,
  });

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      if (Get.arguments['fleetId'] != null) {
        fleetId.value = Get.arguments['fleetId'];
      }
      if (Get.arguments['selectedItems'] != null) {
        selectedItems.assignAll(Get.arguments['selectedItems']);
        calculateTotalPrice();
      }
    }


  }

   void calculateTotalPrice() {
    double total = 0.0;
    for (var item in selectedItems) {
      String priceString = item['price'].toString();
      double price = double.tryParse(priceString) ?? 0.0;
      total += price;
    }
    totalPrice.value = total;
  }

   List<Map<String, String>> get items {
    return selectedItems.map((item) => {
      'id': item['id'].toString(),
      'name': item['name'].toString(),
      'price': item['price'].toString()
    }).toList();
  }

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


  Future<void> createOrderButtonAction() async {
    isLoading.value = true;

    final currentAddress = await dbHelper.getCurrentAddress();
    final latitude = currentAddress!['latitude'] as double;
    final longitude = currentAddress['longitude'] as double;

    try {
      final dataCreateOrder = OrderRequest(
        addressLine: 'Jalan Sultan Ismail',
        latitude: latitude,
        longitude: longitude,
        currency: 'MYR',
        isScheduled: false,
        scheduledAt: null,
        grandTotal: "65.0000",
        couponCode: "",
        lineItems: items.map((item) => LineItem(id: item['id'] ?? '', quantity: 1)).toList(),
        fleets: [Fleet(id: fleetId.value)],
      );


      final orderResponse = await createOrder(dataCreateOrder);
    
      final paymentUrl = orderResponse.data.paymentUrl;
      CustomToast.show(
        message: "Successfully Create Order!",
        type: ToastType.success,
      );

      Get.toNamed(Routes.PAYMENT, arguments: {
        'paymentUrl': paymentUrl,
      });
    } catch (error) {
      if (error is CustomHttpException) {
        // CustomToast.show(
        //   message: error.message,
        //   type: ToastType.error,
        // );
        ModernSnackbar.show(
          message: error.message,
          type: SnackbarType.error,
        );
      } else {
        CustomToast.show(
          message: "An unexpected error occurred",
          type: ToastType.error,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
