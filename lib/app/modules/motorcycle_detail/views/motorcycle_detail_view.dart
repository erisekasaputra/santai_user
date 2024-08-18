import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/routes/app_pages.dart';
import '../controllers/motorcycle_detail_controller.dart';

class MotorcycleDetailView extends GetView<MotorcycleDetailController> {
  const MotorcycleDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Motorcycle',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Get.toNamed(Routes.REG_MOTORCYCLE);
            },
            icon: const Icon(Icons.add, color: Colors.black),
            label: const Text(
              'Add more',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey[100],
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMotorcycleChips(),
              const SizedBox(height: 10),
              _buildMotorcycleCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMotorcycleChips() {
  return Obx(() => Wrap(
    spacing: 8,
    children: controller.motorcycles.map((motorcycle) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 1),
        child: ChoiceChip(
          label: Text(
            motorcycle,
            style: const TextStyle(fontSize: 12), 
          ),
          selected: motorcycle == controller.selectedMotorcycle.value,
          onSelected: (selected) {
            if (selected) {
              controller.updateSelectedMotorcycle(motorcycle);
            }
          },
          selectedColor: Colors.grey[600],
          backgroundColor: Colors.grey[300], 
          labelStyle: TextStyle(
            color: motorcycle == controller.selectedMotorcycle.value ? Colors.white : Colors.black,
          ),
        ),
      );
    }).toList(),
  ));
}

  Widget _buildMotorcycleCard() {
  return Obx(() => Card(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
      side: BorderSide(color: Colors.grey, width: 1),
    ),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Icon(Icons.image, size: 60, color: Colors.grey),
                  ),
                ),
              ),
              Positioned(
                left: 5,
                bottom: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.MOTORCYCLE_INFORMATION);
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Icon(Icons.edit, color: Colors.black, size: 18),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          controller.selectedMotorcycle.value,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Preference', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildPreferenceRow(),
          const SizedBox(height: 16),
          ...controller.currentMotorcycleDetails.entries.map(
            (entry) => _buildDetailRow(entry.key, entry.value),
          ),
        ],
      ),
    ),
  ));
}

Widget _buildPreferenceRow() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: controller.preferenceItems.map((item) {
      return Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6), // Add horizontal spacing
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Icon(item['icon'] as IconData, color: Colors.grey[600], size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                item['title'] as String,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                item['subtitle'] as String,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }).toList(),
  );
}

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}