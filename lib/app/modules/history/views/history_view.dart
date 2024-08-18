import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/routes/app_pages.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({Key? key}) : super(key: key);

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
          'History',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          _buildOrderList(),
        ],
      ),
    );
  }


  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search Order ID',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onChanged: controller.filterOrders,
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _buildFilterChip('Successful'),
          const SizedBox(width: 8),
          _buildFilterChip('Canceled'),
          const SizedBox(width: 8),
          _buildFilterChip('Refunded'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
  return Obx(() => FilterChip(
    label: Text(label),
    selected: controller.selectedFilter.value == label,
    onSelected: (selected) => controller.setFilter(label),
    backgroundColor: Colors.grey[300],
    selectedColor: Colors.grey[600],
    labelStyle: TextStyle(
      color: controller.selectedFilter.value == label ? Colors.white : Colors.black,
    ),
  ));
}

  Widget _buildOrderList() {
    return Expanded(
      child: Obx(() => ListView.builder(
        itemCount: controller.filteredOrders.length,
        itemBuilder: (context, index) {
          final order = controller.filteredOrders[index];
          return _buildOrderCard(order);
        },
      )),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(order),
            const SizedBox(height: 8),
            const Text('Motorcycle Update', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            const SizedBox(height: 8),
            Text(order.description),
            const SizedBox(height: 8),
            _buildOrderButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader(Order order) {
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
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID #${order.orderId}'),
            Text('Date: ${order.date}'),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderButtons() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            Get.toNamed(Routes.SERVICE_DETAIL);
          },
          child: const Text('Detail'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            Get.toNamed(Routes.RATE_SERVICE);
          },
          child: const Text('Rate'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[600],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}