import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_back_button.dart';
import 'package:santai/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/theme/app_theme.dart';
import '../controllers/service_detail_controller.dart';

class ServiceDetailView extends GetView<ServiceDetailController> {
  const ServiceDetailView({Key? key}) : super(key: key);

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
          'Service Detail',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderInfo(),
              _buildTechnicianInfo(context),
              _buildStatusInfo(context),
              _buildTotalItems(context),
              CustomElevatedButton(
                onPressed: () {
                    Get.toNamed(Routes.RATE_SERVICE);
                  },
                text: 'Rate',
              ),
              const SizedBox(height: 10),
              CustomElevatedButton(
                onPressed: () {
                    // Get.toNamed(Routes.RATE_SERVICE);
                  },
                text: 'Cancel',
                backgroundColor: Colors.red,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Order ID', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(controller.orderDetails.date, style: const TextStyle(fontSize: 16)),
          ],
        ),
       Text('#${controller.orderDetails.orderId}', 
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on, size: 25, color: Colors.red),
            const SizedBox(width: 4),
            Expanded(child: Text(controller.orderDetails.location, style: const TextStyle(fontSize: 14))),
          ],
        ),
      ],
    );
  }

  Widget _buildTechnicianInfo(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor), 
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 35, backgroundImage: Image.network('https://picsum.photos/200/200').image),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Technician', style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      Text(controller.orderDetails.technicianName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                      const Icon(Icons.flag, size: 20, color: Colors.red), 
                    ],
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
              onTap: () => Get.toNamed(Routes.CHAT),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary_300,
                ),
                child: const Icon(Icons.chat, color: Colors.white, size: 24),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusInfo(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
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
      border: Border.all(color: borderColor),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(statusIcon, color: statusColor, size: 30),
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

  Widget _buildTotalItems(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    return 
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(thickness: 1, color: borderColor),
            const Text('Total Item', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Divider(thickness: 1, color: borderColor),
            const SizedBox(height: 8),
            ...controller.orderDetails.items.map((item) => _buildItemRow(item['name'] ?? '', item['price'] ?? '')),
            Divider(thickness: 1, color: borderColor),
            ...controller.orderDetails.totalItems.map((item) => _buildItemRow(item['name'] ?? '', item['price'] ?? '')),
            Divider(thickness: 1, color: borderColor),
            _buildItemRow('Grand Total', controller.orderDetails.grandTotal, isBold: true),
            Divider(thickness: 1, color: borderColor),
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