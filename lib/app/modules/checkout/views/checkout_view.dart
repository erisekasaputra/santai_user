import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:santai/app/common/widgets/custom_back_button.dart';
import 'package:santai/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai/app/routes/app_pages.dart';
import '../controllers/checkout_controller.dart';
import 'package:santai/app/theme/app_theme.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 0, 8),
          child: CustomBackButton(
            onPressed: () => Get.back(),
          ),
        ),
        leadingWidth: 100,
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Order ID #00024',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Text('SYM VF3i 185', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Divider(thickness: 1, color: Colors.grey[300]),
                _buildDateTimeSchedule(),
                Divider(thickness: 1, color: Colors.grey[300]),
                const SizedBox(height: 8),
                _buildItemsList(context),
                const SizedBox(height: 16),
                _buildPromotionAndReward(),
                // SizedBox(height: 16),
                // _buildTipOptions(),
                const SizedBox(height: 16),
                _buildTotalSection(),
                const SizedBox(height: 24),
                CustomElevatedButton(
                  text: 'Make Payment',
                  onPressed: () {
                    Get.toNamed(Routes.PAYMENT);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeSchedule() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildScheduleToggle(),
        Obx(() {
          if (controller.isScheduleOn.value &&
              controller.selectedDate.value.isNotEmpty) {
            return _buildScheduleItem(
                Icons.event,
                '${controller.selectedDate.value} ${controller.selectedTime.value}',
                _selectDateTime);
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  void _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.black,
            colorScheme: const ColorScheme.light(primary: Colors.black),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: Colors.black,
              colorScheme: const ColorScheme.light(primary: Colors.black),
              buttonTheme:
                  const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        final DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        final DateFormat dateFormat = DateFormat("MM/dd/yyyy");
        final DateFormat timeFormat = DateFormat("h:mm a");

        controller.selectedDate.value = dateFormat.format(combinedDateTime);
        controller.selectedTime.value = timeFormat.format(combinedDateTime);
      }
    }
  }

  Widget _buildScheduleItem(IconData icon, String text, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(text),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Order Later', style: TextStyle(fontSize: 18)),
          Obx(() => Transform.scale(
                scale: 0.7,
                child: Switch(
                  value: controller.isScheduleOn.value,
                  onChanged: (value) {
                    controller.isScheduleOn.value = value;
                    if (value) {
                      _selectDateTime();
                    } else {
                      controller.selectedDate.value = '';
                      controller.selectedTime.value = '';
                    }
                  },
                  activeColor: Colors.white,
                  activeTrackColor: Colors.green,
                  inactiveThumbColor: Colors.black,
                  inactiveTrackColor: Colors.grey[300],
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildItemsList(BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    final Color text_01 = Theme.of(context).colorScheme.text_01;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: primary_300,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Items',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: text_01)),
                Text('Price',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: text_01)),
              ],
            ),
          ),
          ...controller.items
              .map((item) => Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item['name']!,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14)),
                              Text(item['price']!,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14)),
                            ],
                          ),
                        ),
                        if (item != controller.items.last)
                          Divider(height: 1, color: Colors.grey[300]),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildPromotionAndReward() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text('Promotion Code', style: TextStyle(fontSize: 14)),
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 30,
                    child: TextField(
                      onChanged: (value) =>
                          controller.promotionCode.value = value,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'OPEN50',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 1),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text('S-Care Reward', style: TextStyle(fontSize: 14)),
                ),
                Expanded(
                  flex: 3,
                  child: Obx(() => Row(
                        children: [
                          Text('0', style: TextStyle(color: Colors.grey[600])),
                          Expanded(
                            child: Slider(
                              value: controller.sCareRewardValue.value,
                              max: 321,
                              onChanged: (value) {
                                controller.sCareRewardValue.value = value;
                              },
                              activeColor: Colors.black,
                              inactiveColor: Colors.grey[300],
                            ),
                          ),
                          Text('321',
                              style: TextStyle(color: Colors.grey[600])),
                        ],
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildTipOptions() {
  //   return Row(
  //     children: [
  //       Obx(() => Checkbox(
  //             value: controller.isTipChecked.value,
  //             onChanged: (bool? value) {
  //               controller.isTipChecked.value = value ?? false;
  //             },
  //           )),
  //       Text('Give tip Now or Later', style: TextStyle(fontSize: 14)),
  //       SizedBox(width: 8),
  //       Expanded(
  //         child: Wrap(
  //           spacing: 4,
  //           runSpacing: 4,
  //           alignment: WrapAlignment.end,
  //           children: controller.tipOptions
  //               .map((tip) => _buildTipButton(tip))
  //               .toList(),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildTipButton(String text) {
  //   return SizedBox(
  //     height: 30,
  //     child: ElevatedButton(
  //       onPressed: () {},
  //       child: Text(text, style: TextStyle(fontSize: 12, color: Colors.black)),
  //       style: ElevatedButton.styleFrom(
  //           foregroundColor: Colors.black,
  //           backgroundColor: Colors.white,
  //           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
  //           minimumSize: Size(0, 0),
  //           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(10),
  //             side: BorderSide(color: Colors.grey[300]!, width: 1),
  //           )),
  //     ),
  //   );
  // }

  Widget _buildTotalSection() {
    return Column(
      children: [
        ...controller.totalItems.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item['name']!, style: const TextStyle(fontSize: 14)),
                  Text(item['price']!, style: const TextStyle(fontSize: 14)),
                ],
              ),
            )),
        const SizedBox(height: 8),
        Divider(color: Colors.grey[300], thickness: 1),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Grand Total',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('RM95.00',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
