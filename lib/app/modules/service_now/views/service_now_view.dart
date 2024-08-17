import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai/app/routes/app_pages.dart';
import '../controllers/service_now_controller.dart';

class ServiceNowView extends GetView<ServiceNowController> {
  const ServiceNowView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        leadingWidth: 40,
        title: const Text(
          'Services',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildCategoryIcons(),
              const SizedBox(height: 20),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Choose your parts',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      _buildPartsTags(),
                      const SizedBox(height: 20),
                      _buildPartsList(),
                      const SizedBox(height: 20),
                      CustomElevatedButton(
                        text: 'Check Out',
                        onPressed: () {
                          controller.checkoutSelectedParts();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 Widget _buildCategoryIcons() {
  return GetBuilder<ServiceNowController>(
    builder: (controller) => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(controller.categories.length, (index) {
          final category = controller.categories[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: () => controller.setSelectedCategory(index),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: controller.selectedCategoryIndex == index
                          ? Colors.black
                          : Colors.grey[200],
                    ),
                    child: Icon(category['icon'],
                        color: controller.selectedCategoryIndex == index
                            ? Colors.white
                            : Colors.black,
                        size: 40),
                  ),
                  SizedBox(height: 5),
                  Text(
                    category['name'],
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    ),
  );
}

Widget _buildPartsTags() {
  return GetBuilder<ServiceNowController>(
    builder: (controller) => Wrap(
      spacing: 8,
      children: controller.partTags.map((tag) => GestureDetector(
        onTap: () => controller.setSelectedPartTag(tag),
        child: Chip(
          label: Text(tag),
          backgroundColor: tag == controller.selectedPartTag.value ? Colors.grey[400] : Colors.grey[100],
        ),
      )).toList(),
    ),
  );
}

 Widget _buildPartsList() {
  return GetBuilder<ServiceNowController>(
    builder: (controller) => GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: controller.currentParts.length,
      itemBuilder: (context, index) => _buildPartItem(controller.currentParts[index]),
    ),
  );
}

  Widget _buildPartItem(Map<String, dynamic> part) {
  return GetBuilder<ServiceNowController>(
    builder: (controller) => GestureDetector(
      onTap: () => Get.toNamed(Routes.DETAIL_PRODUCT, arguments: part['name']),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    child: Center(child: Icon(Icons.image, size: 40, color: Colors.grey[600])),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                part['name'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.star, size: 16, color: Colors.amber),
                                SizedBox(width: 2),
                                Text(part['rating'].toString()),
                              ],
                            ),
                          ],
                        ),
                        Text(part['description'], overflow: TextOverflow.ellipsis),
                        Text('RM${part['price'].toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 5,
              left: 5,
              child: GestureDetector(
                onTap: () => controller.togglePartSelection(part),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: controller.selectedParts.contains(part)
                        ? const Icon(Icons.check_circle, size: 20, color: Colors.amber)
                        : const Icon(Icons.radio_button_unchecked, size: 20, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

//  Widget _buildCheckoutButton() {
//   return Container(
//     width: double.infinity,
//     child: ElevatedButton(
//       child: Text('Check Out'),
//       style: ElevatedButton.styleFrom(
//         foregroundColor: Colors.black,
//         backgroundColor: Colors.grey[300],
//         padding: EdgeInsets.symmetric(vertical: 16),
//       ),
//       onPressed: () {
//         controller.checkoutSelectedParts();
//       },
//     ),
//   );
// }
}