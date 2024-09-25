import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_back_button.dart';
import 'package:santai/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai/app/routes/app_pages.dart';
import '../controllers/service_now_controller.dart';
import 'package:santai/app/theme/app_theme.dart';

class ServiceNowView extends GetView<ServiceNowController> {
  const ServiceNowView({Key? key}) : super(key: key);

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
          'Services',
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
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  'Categories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              _buildCategoryIcons(context),
               Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Choose your parts',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      _buildPartsTags(context),
                      const SizedBox(height: 20),
                      _buildPartsList(),
                      const SizedBox(height: 20),
                      Obx(() => CustomElevatedButton(
                        text: 'Check Out',
                        onPressed: controller.isLoading.value ? null : () => controller.checkoutSelectedParts(),
                        isLoading: controller.isLoading.value,
                      )),
                    ],
                  ),
                ),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcons(BuildContext context) {

    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    final Color primary_50 = Theme.of(context).colorScheme.primary_50;

  return GetBuilder<ServiceNowController>(
    builder: (controller) => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(controller.categories.length, (index) {
          final category = controller.categories[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => controller.setSelectedCategory(index),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: borderColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 25, 12, 25),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.selectedCategoryIndex == index
                                ? primary_300
                                : primary_50.withOpacity(0.8),
                        ),
                        child: Icon(category['icon'],
                            color: Colors.white,
                            size: 35),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        category['name'],
                        style: TextStyle(
                          fontSize: 14,
                          color: controller.selectedCategoryIndex == index
                              ? Colors.black
                              : Colors.grey[600],
                          fontWeight: controller.selectedCategoryIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    ),
  );
}


Widget _buildPartsTags(BuildContext context) {
  return GetBuilder<ServiceNowController>(
    builder: (controller) => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: controller.partTags.map((tag) {
          final isSelected = tag == controller.selectedPartTag.value;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => controller.setSelectedPartTag(tag),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary_300
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[300]!),
                  boxShadow: isSelected
                      ? [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 5, offset: Offset(0, 2))]
                      : [],
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: isSelected
                        ? Theme.of(context).colorScheme.button_text_01
                        : Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
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
      itemBuilder: (context, index) => _buildPartItem(controller.currentParts[index], context),
    ),
  );
}

Widget _buildPartItem(Map<String, dynamic> part, BuildContext context) {

  final Color primary_300 = Theme.of(context).colorScheme.primary_300;

  return GetBuilder<ServiceNowController>(
    builder: (controller) {
      final isSelected = controller.selectedParts.contains(part);
      return GestureDetector(
        onTap: () => Get.toNamed(Routes.DETAIL_PRODUCT, arguments: part['name']),
          child: Container(
          height: 900, 
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue[50] : Colors.grey[50],
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(20)),
                    ),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          'https://picsum.photos/200/200',
                          fit: BoxFit.contain,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                  ),
                  Expanded( 
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
                          SizedBox(height: 15),
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
                      child: isSelected
                          ? Icon(Icons.radio_button_checked_outlined, size: 20, color: primary_300)
                          : const Icon(Icons.radio_button_unchecked, size: 20, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

}