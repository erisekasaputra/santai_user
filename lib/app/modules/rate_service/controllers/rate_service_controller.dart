import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RateServiceController extends GetxController {
  final orderId = '00024';
  final technicianName = 'Brian Weaknes';
  final duration = 0.obs;
  final rating = 0.obs;
  final commentController = TextEditingController();
  final tipOptions = ['RM 2.00', 'RM 5.00', 'RM 10.00'];
  final selectedTip = RxString('');
  final String dummyDuration = '00:45';


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
            Get.back();
          },
        ),
      ),
    );
  }

  void submitRating() {
    // Implement rating submission logic
    print('Rating: ${rating.value}');
    print('Comment: ${commentController.text}');
    print('Tip: ${selectedTip.value}');
    Get.back(); // Return to previous screen
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}