import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_back_button.dart';
import 'package:santai/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai/app/theme/app_theme.dart';
import '../controllers/rate_service_controller.dart';

class RateServiceView extends GetView<RateServiceController> {
  const RateServiceView({Key? key}) : super(key: key);

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
          'Rate Service',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order ID',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            Text(
              '#${controller.orderId}',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            _buildTechnicianCard(context),
            _buildProcessCard(context),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: borderColor, width: 1),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRatingSection(context),
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

  Widget _buildTechnicianCard(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          CircleAvatar(
              radius: 35,
              backgroundImage:
                  Image.network('https://picsum.photos/200/200').image),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Technician', style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  Text(controller.technicianName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
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

  Widget _buildProcessCard(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 1),
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
                Text('Process',
                    style:
                        TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                Text('Services',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(controller.dummyDuration,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
            child: Text('Rate the technician',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
                  5,
                  (index) => Obx(() => IconButton(
                        icon: Icon(
                          controller.rating.value > index
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 40,
                        ),
                        onPressed: () => controller.setRating(index + 1),
                      )))
              .map((iconButton) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: iconButton,
                  ))
              .toList(),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller.commentController,
          decoration: InputDecoration(
            hintText: 'Leave your comment...',
            hintStyle: TextStyle(color: borderColor),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
        Text('Add more tip for ${controller.technicianName}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...controller.tipOptions.map((tip) => ElevatedButton(
                  onPressed: () => controller.setTip(tip),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey[300],
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(tip, style: const TextStyle(fontSize: 12)),
                )),
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
