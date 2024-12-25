import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_back_button.dart';
import '../controllers/detail_product_controller.dart';

class DetailProductView extends GetView<DetailProductController> {
  const DetailProductView({super.key});

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
            onPressed: () {
              if (Get.isDialogOpen ?? false) {
                Get.back(closeOverlays: true);
              } else {
                Get.back(closeOverlays: true);
              }
            },
          ),
        ),
        leadingWidth: 100,
        title: const Text(
          'Detail Product',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(controller.urlImgPublic.value +
                              (controller.items.value?.imageUrl ?? "")),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.items.value?.name ?? '',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${controller.items.value?.soldQuantity ?? '0'} Sold',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  Divider(
                    thickness: 2,
                    color: Colors.grey[200],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    controller.items.value?.description ?? '',
                    style: TextStyle(
                        fontSize: 16, color: Colors.grey[800], height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Santai Review',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 5),
                  ...controller.items.value?.ownerReviews.map((review) =>
                          _buildRatingRow(review.title, review.rating)) ??
                      [],
                  // const SizedBox(height: 16),
                  // _buildRatingRow('Price', controller.items.value?.price.toInt() ?? 0),
                  // const SizedBox(height: 5),

                  // _buildRatingRow(
                  //     'Price', controller.items.value?.price.toInt() ?? 0),
                ],
              ),
            ),
          );
        }
      }),
    );
  }

  Widget _buildRatingRow(String label, int rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700]),
            ),
          ),
          Expanded(
            child: Wrap(
              spacing: 2,
              runSpacing: 2,
              children: List.generate(
                10,
                (index) => Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  size: 20,
                  color: index < rating
                      ? const Color(0xFFFFD700)
                      : Colors.grey[300],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildRatingRow(String label, int rating) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(
  //           width: 100,
  //           child: Text(
  //             label,
  //             style: TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w500,
  //                 color: Colors.grey[700]),
  //           ),
  //         ),
  //         Expanded(
  //           child: Wrap(
  //             spacing: 2,
  //             runSpacing: 2,
  //             children: List.generate(
  //               10,
  //               (index) => Icon(
  //                 index < rating ? Icons.star : Icons.star_border,
  //                 size: 20,
  //                 color: index < rating
  //                     ? const Color(0xFFFFD700)
  //                     : Colors.grey[300],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
