import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai/app/routes/app_pages.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10), // Add bottom padding
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildAddressBar(),
                  _buildImagePlaceholder(),
                  _buildServiceProgress(),
                  _buildMotorcycleList(),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 40, // Adjusted size
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.grey[600], size: 30), // Adjusted icon size
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Good Morning', style: TextStyle(color: Colors.black, fontSize: 14)),
                Text('Hello ${controller.userName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            // Add your onTap functionality here
          },
          child: Icon(Icons.qr_code, color: Colors.grey[600]),
        ),
      ],
    );
  }

 Widget _buildAddressBar() {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 16),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Icon(Icons.location_on_outlined, color: Colors.black),
        const SizedBox(width: 8),
        Expanded(
          child: Obx(() => Text(
            controller.address.value,
            style: TextStyle(color: Colors.black),
          )),
        ),
        const SizedBox(width: 5),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: IconButton(
            icon: Icon(Icons.refresh, color: Colors.black),
            onPressed: () => controller.getCurrentLocation(),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildImagePlaceholder() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.image, color: Colors.grey[400], size: 50),
    );
  }


  Widget _buildServiceProgress() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 16),
      const Text('Service Progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
      const SizedBox(height: 8),
      SizedBox(
        height: 50,
        child: PageView.builder(
          itemCount: controller.serviceProgresses.length,
          onPageChanged: (index) => controller.currentServiceIndex.value = index,
          itemBuilder: (context, index) {
            final service = controller.serviceProgresses[index];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: service.steps.asMap().entries.map((entry) {
                final isActive = entry.key <= service.currentStep;
                return _buildProgressStep(entry.value, isActive: isActive);
              }).toList(),
            );
          },
        ),
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          controller.serviceProgresses.length,
          (index) => Obx(() => Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: controller.currentServiceIndex.value == index ? Colors.black : Colors.grey,
            ),
          )),
        ),
      ),
    ],
  );
}

  Widget _buildProgressStep(String title, {bool isActive = false}) {
  return Column(
    children: [
      Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? Colors.black : Colors.grey[300],
        ),
      ),
      const SizedBox(height: 4),
      Text(
        title,
        style: TextStyle(fontSize: 10, color: Colors.black),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

  Widget _buildMotorcycleList() {
  return Card(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Choose your motorcycle',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        GetBuilder<DashboardController>(
          builder: (controller) {
            final currentService = controller.serviceProgresses[controller.currentServiceIndex.value];
            return Column(
              children: currentService.motorcycles.asMap().entries.map((entry) {
                final index = entry.key;
                final motorcycle = entry.value;
                final isSelected = index == currentService.selectedMotorcycleIndex;
                return GestureDetector(
                  onTap: () => controller.selectMotorcycle(controller.currentServiceIndex.value, index),
                  child: _buildMotorcycleItem(motorcycle, isSelected: isSelected),
                );
              }).toList(),
            );
          },
        ),

        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(10),
          child: CustomElevatedButton(
          text: 'Services',
          onPressed: () {
            Get.toNamed(Routes.SERVICE_NOW);
          },
        ),
        ),
      ],
    ),
  );
}

 Widget _buildMotorcycleItem(Motorcycle motorcycle, {bool isSelected = false}) {
  return Container(
    margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.grey[200],
      borderRadius: BorderRadius.circular(8),
      border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
    ),
    child: Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.motorcycle, color: Colors.grey[400]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(motorcycle.plateNumber, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              Text('${motorcycle.brand} ${motorcycle.model}', style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
        if (isSelected)
          Icon(Icons.check_circle, color: Colors.blue),
      ],
    ),
  );
}


  // Widget _buildServicesButton() {
  //   return Container(
  //     width: double.infinity,
  //     margin: const EdgeInsets.symmetric(vertical: 16),
  //     child: ElevatedButton(
  //       onPressed: () {},
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: Colors.grey[300],
  //         foregroundColor: Colors.black,
  //         padding: const EdgeInsets.symmetric(vertical: 16),
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //       ),
  //       child: const Text('Services', style: TextStyle(color: Colors.black)),
  //     ),
  //   );
  // }

  Widget _buildBottomNavigationBar() {
  return Container(
    padding: const EdgeInsets.all(5),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.grey[300]!, width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, -3),
        ),
      ],
    ),
    child: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.transparent,
      elevation: 0,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      onTap: controller.navigateToPage,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.motorcycle),
          label: 'Motorcycle',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Inbox',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
    ),
  );
}
}