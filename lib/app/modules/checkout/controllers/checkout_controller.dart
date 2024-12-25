import 'dart:async';

import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/data/models/order/order_order_res_model.dart';
import 'package:santai/app/domain/entities/order/order_calculation_req.dart'
    as calc;
import 'package:santai/app/domain/entities/order/order_order_req.dart';
import 'package:santai/app/domain/usecases/order/cek_coupon.dart';
import 'package:santai/app/domain/usecases/order/create_order.dart';
import 'package:santai/app/domain/usecases/order/calculation_order.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/helpers/sqlite_db_helper.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/services/location_service.dart';
import 'package:santai/app/utils/http_error_handler.dart';
import 'package:santai/app/utils/logout_helper.dart';

class ItemStaging {
  String id;
  String name;
  String price;
  ItemStaging({required this.id, required this.name, required this.price});
}

class CheckoutController extends GetxController {
  final Logout logout = Logout();
  final isLoading = false.obs;

  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  final LocationService locationService = LocationService();

  final longitude = 0.0.obs;
  final latitude = 0.0.obs;
  final addressLine = ''.obs;

  final fleetId = ''.obs;
  final fleetModel = ''.obs;
  final items = RxList<ItemStaging>([]);

  final totalPrice = 0.0.obs;
  final grandTotal = 0.0.obs;

  final isScheduleOn = false.obs;
  final scheduledAt = ''.obs;
  final selectedDate = ''.obs;
  final selectedTime = ''.obs;

  final promotionCode = ''.obs;

  final discountAmount = 0.0.obs;
  final couponValidationMessage = ''.obs;
  final isCouponValid = false.obs;

  final fees = <FeeModel>[].obs;
  // Timer? _debounce;

  final CreateOrder createOrder;
  final CalculateOrder calculationOrder;
  final CheckCoupon checkCoupon;
  CheckoutController({
    required this.createOrder,
    required this.calculationOrder,
    required this.checkCoupon,
  });

  @override
  void onInit() async {
    super.onInit();

    // CALCULATE ORDER ITEMS
    if (Get.arguments != null) {
      if (Get.arguments['fleetId'] != null) {
        fleetId.value = Get.arguments['fleetId'];
      }

      if (Get.arguments['fleetModel'] != null) {
        fleetModel.value = Get.arguments['fleetModel'];
      }

      if (Get.arguments['selectedItems'] != null) {
        List<Map<String, dynamic>> selectedItems =
            Get.arguments['selectedItems'];

        items.clear();
        items.addAll(selectedItems
            .map((item) => ItemStaging(
                id: item['id'].toString(),
                name: item['name'].toString(),
                price: item['price'].toString()))
            .toList());

        calculateTotalPrice();
      }
    }

    // GET SELECTED ADDRESS
    final currentAddress = await dbHelper.getCurrentAddress();

    if (currentAddress == null) {
      CustomToast.show(
        message: 'There is no address has been set',
        type: ToastType.error,
      );
      return;
    }

    latitude.value = currentAddress['latitude'] as double;
    longitude.value = currentAddress['longitude'] as double;

    var (data, isError) = await locationService.translateCoordinatesToAddress(
        latitude.value, longitude.value);
    addressLine.value = data ?? '';

    // CALCULATE TOTAL ORDER
    await handleCalculateOrder();
  }

  void onCouponChanged(String value) {
    discountAmount.value = 0.0;
    couponValidationMessage.value = '';
    promotionCode.value = value;

    if (isCouponValid.value) {
      isCouponValid.value = false;
      handleCalculateOrder();
    }
  }

  void onCouponSubmitted() {
    validateCoupon();
  }

  Future<void> validateCoupon() async {
    isLoading.value = true;

    if (promotionCode.value.isEmpty) {
      couponValidationMessage.value = '';
      isCouponValid.value = false;
      discountAmount.value = 0.0;
      await handleCalculateOrder();
      return;
    }

    try {
      final response = await checkCoupon(promotionCode.value);
      final coupon = response?.data;

      if (coupon == null) {
        isCouponValid.value = false;
        couponValidationMessage.value = 'Invalid coupon code';
        discountAmount.value = 0.0;
        return;
      }

      final parameter = coupon.parameter;
      final valuePercentage = coupon.valuePercentage;
      final valueAmount = coupon.valueAmount;

      double discount = 0.0;
      switch (parameter) {
        case 'percentage':
          discount = grandTotal.value * (valuePercentage / 100);
          break;
        case 'value':
          discount = valueAmount;
          break;
        default:
          discount = 0.0;
      }

      discountAmount.value = discount;
      isCouponValid.value = true;
      couponValidationMessage.value = 'Coupon applied successfully';
    } catch (error) {
      if (error is CustomHttpException) {
        if (error.statusCode == 401) {
          await logout.doLogout();
          return;
        }
      }

      isCouponValid.value = false;
      discountAmount.value = 0.0;
      couponValidationMessage.value = 'Invalid coupon code';
    } finally {
      isLoading.value = false;
      await handleCalculateOrder();
      update();
    }
  }

  void calculateTotalPrice() {
    double total = 0.0;
    for (var item in items) {
      String priceString = item.price;
      double price = double.tryParse(priceString) ?? 0.0;
      total += price;
    }
    totalPrice.value = total;
  }

  Future<void> handleCalculateOrder() async {
    isLoading.value = true;
    try {
      final dataCalculateOrder = calc.OrderCalculationRequest(
        addressLine: addressLine.value,
        latitude: latitude.value,
        longitude: longitude.value,
        currency: 'MYR',
        isScheduled: isScheduleOn.value,
        scheduledAt: scheduledAt.value.isNotEmpty
            ? DateTime.parse(scheduledAt.value)
            : null,
        grandTotal: totalPrice.value,
        couponCode: isCouponValid.value ? promotionCode.value : "",
        lineItems: items
            .map((item) => calc.LineItem(
                id: item.id,
                quantity: 1,
                price: double.parse(item.price.toString()),
                currency: 'MYR'))
            .toList(),
        fleets: [calc.Fleet(id: fleetId.value)],
      );

      final orderResponse = await calculationOrder(dataCalculateOrder);
      fees.assignAll(orderResponse.data.fees
          .map((fee) => FeeModel(
                parameter: fee.parameter,
                feeDescription: fee.feeDescription,
                currency: fee.currency,
                valuePercentage: fee.valuePercentage,
                valueAmount: fee.valueAmount,
                feeAmount: fee.feeAmount,
              ))
          .toList());

      grandTotal.value = totalPrice.value +
          orderResponse.data.fees.fold(0, (sum, fee) => sum + fee.feeAmount);

      grandTotal.value -= discountAmount.value;
    } catch (e) {
      if (e is CustomHttpException) {
        if (e.statusCode == 401) {
          await logout.doLogout();
          return;
        }

        if (e.errorResponse != null) {
          var messageError = parseErrorMessage(e.errorResponse!);

          if ('${e.message}$messageError'
              .toLowerCase()
              .contains('line items should not be empty')) {
            Get.offAllNamed(Routes.DASHBOARD);
          }

          CustomToast.show(
            message: '${e.message}\r\n$messageError',
            type: ToastType.error,
          );
          return;
        }
        if (e.message
            .toLowerCase()
            .contains('line items should not be empty')) {
          Get.offAllNamed(Routes.DASHBOARD);
        }
        CustomToast.show(message: e.message, type: ToastType.error);
        return;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createOrderButtonAction() async {
    isLoading.value = true;

    try {
      if (items.isEmpty) {
        Get.offAllNamed(Routes.DASHBOARD);
      }

      final dataCreateOrder = OrderRequest(
        addressLine: addressLine.value,
        latitude: latitude.value,
        longitude: longitude.value,
        currency: 'MYR',
        isScheduled: isScheduleOn.value,
        scheduledAt: (isScheduleOn.value
            ? scheduledAt.value.isNotEmpty
                ? DateTime.parse(scheduledAt.value)
                : null
            : null),
        grandTotal: grandTotal.value.toString(),
        couponCode: isCouponValid.value ? promotionCode.value : "",
        lineItems:
            items.map((item) => LineItem(id: item.id, quantity: 1)).toList(),
        fleets: [Fleet(id: fleetId.value)],
      );

      final (isSuccess, orderResponse, unprocessableEntity) =
          await createOrder(dataCreateOrder);

      if (isSuccess && orderResponse != null) {
        final paymentUrl = orderResponse.data.paymentUrl;
        final orderSecret = orderResponse.data.secret;

        if (!orderResponse.data.isPaid) {
          Get.toNamed(Routes.PAYMENT, arguments: {
            'paymentUrl': paymentUrl,
            'orderSecret': orderSecret
          });
          return;
        }
        Get.offAllNamed(Routes.PAYMENT_STATUS, arguments: {
          'status': '1',
          'orderId': orderResponse.data.orderId,
          'amount': orderResponse.data.grandTotal,
          'transactionId': '',
          'orderSecret': orderResponse.data.secret
        });
        return;
      }

      if (!isSuccess && unprocessableEntity != null) {
        if (unprocessableEntity.data.fleets != null &&
            unprocessableEntity.data.fleets!.isNotEmpty) {
          for (var fId in unprocessableEntity.data.fleets!) {
            if (fleetId.value == fId) {
              fleetId.value = '';
            }
          }

          if (fleetId.value == '') {
            Get.offAllNamed(Routes.DASHBOARD);
            return;
          }
        }

        if (unprocessableEntity.data.items != null &&
            unprocessableEntity.data.items!.isNotEmpty) {
          for (var itemId in unprocessableEntity.data.items!) {
            items.removeWhere((item) => item.id == itemId);
          }
          items.refresh();

          if (items.isEmpty) {
            Get.offAllNamed(Routes.DASHBOARD);
            return;
          }

          CustomToast.show(
              message:
                  'There ${unprocessableEntity.data.items!.length == 1 ? 'is' : 'are'} ${unprocessableEntity.data.items!.length} item(s) could not be processed',
              type: ToastType.error);

          calculateTotalPrice();
          await handleCalculateOrder();
          update();
        }
        return;
      }

      CustomToast.show(
        message: "Unknown error occurred",
        type: ToastType.error,
      );
    } catch (error) {
      if (error is CustomHttpException) {
        if (error.statusCode == 401) {
          await logout.doLogout();
          return;
        }

        if (error.errorResponse != null) {
          var messageError = parseErrorMessage(error.errorResponse!);
          CustomToast.show(
            message: '${error.message}$messageError',
            type: ToastType.error,
          );
          return;
        }

        CustomToast.show(message: error.message, type: ToastType.error);
        return;
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
