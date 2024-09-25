import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_back_button.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/theme/app_theme.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          'History',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchBar(context),
          _buildFilterChips(context),
          _buildOrderList(context),
        ],
      ),
    );
  }


  Widget _buildSearchBar(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search Order ID',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: borderColor),
          ),
        ),
        onChanged: controller.filterOrders,
      ),
    );
  }
  Widget _buildFilterChips(BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.display_settings, size: 40,),
              onPressed: () {
                
              },
            ),
            _buildFilterChip('Successful', primary_300, borderColor),
            const SizedBox(width: 8),
            _buildFilterChip('Canceled', primary_300, borderColor),
            const SizedBox(width: 8),
            _buildFilterChip('Refunded', primary_300, borderColor),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, Color primary_300, Color borderColor) {
  return Obx(() => FilterChip(
    label: Text(label),
    selected: controller.selectedFilter.value == label,
    onSelected: (selected) => controller.setFilter(label),
    backgroundColor: Colors.white,
    selectedColor: primary_300,
    checkmarkColor: Colors.white,
    labelStyle: TextStyle(
      color: controller.selectedFilter.value == label ? Colors.white : Colors.black,
    ),
    side: BorderSide(color: borderColor), 
  ));
}

  Widget _buildOrderList(BuildContext context) {
    return Expanded(
      child: Obx(() => ListView.builder(
        itemCount: controller.filteredOrders.length,
        itemBuilder: (context, index) {
          final order = controller.filteredOrders[index];
          return _buildOrderCard(context, order);
        },
      )),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(context, order),
            const SizedBox(height: 8),
            const Text('Motorcycle Update', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            const SizedBox(height: 8),
            Text(order.description),
            const SizedBox(height: 8),
            _buildOrderButtons(context, order),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader(BuildContext context, Order order) {
    IconData statusIcon;
    Color iconColor;

    switch (order.status) {
      case 'Successful':
        statusIcon = Icons.check_circle;
        iconColor = Colors.green;
        break;
      case 'Canceled':
        statusIcon = Icons.cancel;
        iconColor = Colors.red;
        break;
      default:
        statusIcon = Icons.info;
        iconColor = Colors.orange;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(statusIcon, color: iconColor, size: 30,),
            const SizedBox(width: 8),
            Text(
              order.status,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID #${order.orderId}', style: const TextStyle(fontSize: 12, color: Colors.black),),
            Text('Date: ${order.date}', style: const TextStyle(fontSize: 12, color: Colors.black),),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderButtons(BuildContext context, Order order) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            Get.toNamed(Routes.SERVICE_DETAIL);
          },
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(100, 40),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: borderColor, width: 1),
            ),
          ),
          child: const Text('Detail'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            Get.toNamed(Routes.RATE_SERVICE);
          },
          
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(100, 40),
            backgroundColor: primary_300,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
          ),
          ),
          child: const Text('Rate'),
        ),
      ],
    );
  }
}