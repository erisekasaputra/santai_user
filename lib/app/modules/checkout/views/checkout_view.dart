import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai/app/routes/app_pages.dart';
import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey[300]!, width: 1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order ID #00024', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('SYM VF3i 185', style: TextStyle(fontSize: 16)),
                SizedBox(height: 16),
                _buildDateTimeSchedule(),
                SizedBox(height: 16),
                _buildItemsList(),
                SizedBox(height: 16),
                _buildPromotionAndReward(),
                SizedBox(height: 16),
                _buildTipOptions(),
                SizedBox(height: 16),
                _buildTotalSection(),
                SizedBox(height: 24),
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
        _buildScheduleItem(Icons.calendar_today, controller.selectedDate.value, _selectDate),
        _buildScheduleItem(Icons.access_time, controller.selectedTime.value, _selectTime),
      _buildScheduleToggle(),
    ],
  );
}

Widget _buildScheduleItem(IconData icon, String text, Function() onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          SizedBox(width: 8),
          Text(text),
        ],
      ),
    ),
  );
}
void _selectDate() async {
  final DateTime? picked = await showDatePicker(
    context: Get.context!,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(Duration(days: 365)),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: Colors.black, 
          hintColor: Colors.white, 
          colorScheme: ColorScheme.light(primary: Colors.black), 
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary), 
        ),
        child: child!,
      );
    },
  );
  if (picked != null) {
    controller.selectedDate.value = "${picked.month}/${picked.day}/${picked.year}";
  }
}

void _selectTime() async {
  final TimeOfDay? picked = await showTimePicker(
    context: Get.context!,
    initialTime: TimeOfDay.now(),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: Colors.black, 
          hintColor: Colors.black, 
          colorScheme: ColorScheme.light(primary: Colors.black), 
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary), 
        ),
        child: child!,
      );
    },
  );
  if (picked != null) {
    controller.selectedTime.value = picked.format(Get.context!);
  }
}

Widget _buildScheduleToggle() {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Schedule On', style: TextStyle(fontSize: 12)),
        // SizedBox(width: 2),
        Obx(() => Transform.scale(
          scale: 0.7,
          child: Switch(
            value: controller.isScheduleOn.value,
            onChanged: (value) {
              controller.isScheduleOn.value = value;
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        )),
      ],
    ),
  );
}

  Widget _buildItemsList() {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Items', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              Text('Price', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            ],
          ),
        ),
        ...controller.items.map((item) => Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['name']!, style: TextStyle(color: Colors.black, fontSize: 14)),
                    Text(item['price']!, style: TextStyle(color: Colors.black, fontSize: 14)),
                  ],
                ),
              ),
              if (item != controller.items.last) Divider(height: 1, color: Colors.grey[300]),
            ],
          ),
        )).toList(),
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
                  child: Container(
                    height: 30, 
                    child: TextField(
                      onChanged: (value) => controller.promotionCode.value = value,
                      textAlign: TextAlign.right, 
                      decoration: InputDecoration(
                        hintText: 'OPEN50',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                      ),
                      style: TextStyle(fontSize: 14), // Opsional: menyesuaikan ukuran font
                    ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
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
                    Text('321', style: TextStyle(color: Colors.grey[600])),
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

Widget _buildTipOptions() {
  return Row(
    children: [
      Icon(Icons.monetization_on, size: 18, color: Colors.green),
      SizedBox(width: 4),
      Text('Give tip Now or Later', style: TextStyle(fontSize: 14)),
      SizedBox(width: 8),
      Expanded(
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          alignment: WrapAlignment.end,
          children: controller.tipOptions.map((tip) => _buildTipButton(tip)).toList(),
        ),
      ),
    ],
  );
}

Widget _buildTipButton(String text) {
  return Container(
    height: 30,
    child: ElevatedButton(
      onPressed: () {},
      child: Text(text, style: TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey[100],
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        minimumSize: Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4), // Reduced radius
        ),
      ),
    ),
  );
}

Widget _buildTotalSection() {
  return Column(
    children: [
      ...controller.totalItems.map((item) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item['name']!, style: TextStyle(fontSize: 14)),
            Text(item['price']!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      )),
      SizedBox(height: 8),
      Divider(color: Colors.grey[300], thickness: 1),
      SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Grand Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text('RM95.00', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    ],
  );
}

}