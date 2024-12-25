import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/domain/usecases/order/rate_order.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/utils/http_error_handler.dart';
import 'package:santai/app/utils/logout_helper.dart';

class RateServiceController extends GetxController {
  final Logout logout = Logout();
  final orderId = ''.obs;
  final technicianName = 'N/A'.obs;
  final duration = 0.obs;
  final rating = 0.obs;
  final commentController = TextEditingController();
  final tipOptions = ['RM 2.00', 'RM 5.00', 'RM 10.00'];
  final selectedTip = RxString('');
  final String dummyDuration = '00:45';
  final RateOrder rateOrder;

  RateServiceController({required this.rateOrder});

  @override
  void onInit() async {
    super.onInit();
    orderId.value = Get.arguments?['orderId'] ?? '';
    technicianName.value = Get.arguments?['mechanicName'] ?? '';
  }

  void setRating(int value) {
    rating.value = value;
  }

  void setTip(String tip) {
    selectedTip.value = tip;
  }

  void setCustomTip() {
    // Implement custom tip input logic
    Get.dialog(
      AlertDialog(
        title: const Text('Enter custom tip'),
        content: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixText: 'RM ',
          ),
          onSubmitted: (value) {
            selectedTip.value = 'RM $value';
            Get.back(closeOverlays: true);
          },
        ),
      ),
    );
  }

  Future<void> submitRating() async {
    try {
      if (orderId.value.isEmpty || rating.value <= 0) {
        return;
      }
      var result =
          await rateOrder(orderId.value, rating.value, commentController.text);

      if (result) {
        Get.offAllNamed(Routes.DASHBOARD);
        CustomToast.show(
          message: 'Thanks for your rating',
          type: ToastType.success,
        );
        return;
      }

      CustomToast.show(
        message: 'Uh-oh, There is an issue',
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
          message: '$error',
          type: ToastType.error,
        );
      }
    }
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}
