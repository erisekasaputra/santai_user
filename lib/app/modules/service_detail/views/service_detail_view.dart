import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai/app/routes/app_pages.dart';
import '../controllers/service_detail_controller.dart';

class ServiceDetailView extends GetView<ServiceDetailController> {
  const ServiceDetailView({Key? key}) : super(key: key);

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
          'Service Detail',
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderInfo(),
              _buildTechnicianInfo(),
              _buildStatusInfo(),
              _buildTotalItems(),
              CustomElevatedButton(
                onPressed: () {
                    Get.toNamed(Routes.RATE_SERVICE);
                  },
                text: 'Rate',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Order ID', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('#${controller.orderDetails.orderId}', 
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            Text(controller.orderDetails.date, style: const TextStyle(fontSize: 20)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on, size: 25),
            const SizedBox(width: 4),
            Expanded(child: Text(controller.orderDetails.location, style: const TextStyle(fontSize: 14))),
          ],
        ),
      ],
    );
  }

  Widget _buildTechnicianInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey), 
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 35, child: Icon(Icons.person, size: 35)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Technician', style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  Text(controller.orderDetails.technicianName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  const Icon(Icons.star, size: 20, color: Colors.yellow),
                ],
              ),
            ],
          ),
          
        ],
      ),
    );
  }

  Widget _buildStatusInfo() {
  IconData statusIcon;
  Color statusColor;

  switch (controller.orderDetails.status.toLowerCase()) {
    case 'successful':
      statusIcon = Icons.check_circle;
      statusColor = Colors.green;
      break;
    case 'canceled':
      statusIcon = Icons.cancel;
      statusColor = Colors.red;
      break;
    case 'refunded':
      statusIcon = Icons.money_off;
      statusColor = Colors.orange;
      break;
    default:
      statusIcon = Icons.info;
      statusColor = Colors.blue;
  }

  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.grey),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(statusIcon, color: statusColor, size: 25),
            const SizedBox(width: 8),
            Text(controller.orderDetails.status,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        const Text('Motorcycle Update', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(controller.orderDetails.updateDescription, style: const TextStyle(fontSize: 14)),
      ],
    ),
  );
}

  Widget _buildTotalItems() {
    return 
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Total Item', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...controller.orderDetails.items.map((item) => _buildItemRow(item['name'] ?? '', item['price'] ?? '')),
            const Divider(),
            ...controller.orderDetails.totalItems.map((item) => _buildItemRow(item['name'] ?? '', item['price'] ?? '')),
            const Divider(),
            _buildItemRow('Grand Total', controller.orderDetails.grandTotal, isBold: true),
          ],
        ),
      );
  }

  Widget _buildItemRow(String name, String price, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(price, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

}