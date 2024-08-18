import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_elvbtn_001.dart';
import '../controllers/rate_service_controller.dart';

class RateServiceView extends GetView<RateServiceController> {
  const RateServiceView({Key? key}) : super(key: key);

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
          'Rate Service',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            Text(
              '#${controller.orderId}',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            _buildTechnicianCard(),
            _buildProcessCard(),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.grey, width: 1),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRatingSection(),
                    const SizedBox(height: 24),
                    _buildTipSection(),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: CustomElevatedButton(
                        onPressed: controller.submitRating,
                        text: 'Confirm',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnicianCard() {
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
                  Text(controller.technicianName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

  Widget _buildProcessCard() {
  return Card(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Process', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                  Text('Services', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(controller.dummyDuration, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
    ),
  );
}

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
                child: Text('Rate the technician', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))
              ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) => 
            Obx(() => IconButton(
              icon: Icon(
                controller.rating.value > index ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 40,
              ),
              onPressed: () => controller.setRating(index + 1),
            ))
          ).map((iconButton) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0), 
            child: iconButton,
          )).toList(),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller.commentController,
          decoration: InputDecoration(
            hintText: 'Leave your comment...',
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildTipSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Add more tip for ${controller.technicianName}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...controller.tipOptions.map((tip) => 
                ElevatedButton(
                  onPressed: () => controller.setTip(tip),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(tip, style: const TextStyle(fontSize: 12)),
                )
              ),
              ElevatedButton(
                onPressed: () => controller.setCustomTip(),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.grey[300],
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                ),
                child: const Text('Other', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
      ],
    );
  }
}