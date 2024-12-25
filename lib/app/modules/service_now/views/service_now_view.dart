import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_back_button.dart';
import 'package:santai/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai/app/common/widgets/custom_pagination.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/service_now_controller.dart';
import 'package:santai/app/theme/app_theme.dart';

class ServiceNowView extends GetView<ServiceNowController> {
  const ServiceNowView({super.key});

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
            onPressed: () => Get.back(closeOverlays: true),
          ),
        ),
        leadingWidth: 100,
        title: const Text(
          'Services',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
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
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Categories',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    _buildPartsTags(context),
                    const SizedBox(height: 10),
                    _buildPartsList(),
                    const SizedBox(height: 15),
                    Obx(() => CustomPagination(
                          pageNumber: controller.pageNumber.value,
                          pageSize: controller.pageSize, // Set sesuai kebutuhan
                          pageCount: controller.totalPages.value,
                          onPageChanged: (newPage) {
                            controller.loadPage(
                                newPage); // Memanggil controller untuk mengubah halaman
                          },
                        )),
                    const SizedBox(height: 10),
                    Obx(() => controller.selectedParts.isNotEmpty
                        ? CustomElevatedButton(
                            height: 48,
                            text: 'Check Out',
                            onPressed: controller.isLoading.value
                                ? null
                                : () => controller.checkoutSelectedParts(),
                            isLoading: controller.isLoading.value,
                          )
                        : const SizedBox.shrink()),
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
      builder: (controller) {
        if (controller.isLoadingCategories.value ||
            controller.isLoadingBrands.value ||
            controller.isLoadingItems.value) {
          return _buildSkeletonCategory(
              count: 3, width: double.infinity, height: 150);
        }

        if (controller.categories.isEmpty) {
          return const Center(
            // Membungkus Column dengan Center
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 5,
                ),
                Text(
                  'No categories available',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(controller.categories.length, (index) {
              final category = controller.categories[index];
              final isSelected =
                  controller.selectedCategoryId == category['id'];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () => controller.setSelectedCategory(category['id']),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: borderColor),
                    ),
                    child: Container(
                      width: 80, // Ukuran tetap untuk Card
                      height: 117, // Ukuran tetap untuk Card
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Menjaga posisi gambar dan teks di tengah
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(4, 15, 4, 15),
                            width: 80, // Ukuran tetap gambar (persegi)
                            height: 80, // Ukuran tetap gambar (persegi)
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, // Bentuk lingkaran
                              color: isSelected
                                  ? primary_300 // Warna saat dipilih
                                  : primary_50.withOpacity(
                                      0.8), // Warna saat tidak dipilih
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.1), // Bayangan halus
                                  blurRadius: 6.0, // Jarak bayangan
                                  offset: const Offset(0, 2), // Posisi bayangan
                                ),
                              ],
                              border: Border.all(
                                color: isSelected
                                    ? primary_300
                                    : Colors
                                        .transparent, // Border hanya terlihat saat dipilih
                                width: 2.0, // Lebar border
                              ),
                            ),
                            child: ClipOval(
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    5.0), // Padding di sekitar gambar, sesuaikan sesuai kebutuhan
                                child: Image.network(
                                  category['icon'],
                                  fit: BoxFit
                                      .contain, // Agar gambar tetap proporsional di dalam clip oval
                                ),
                              ),
                            ),
                          ),
                          // Membungkus teks dengan Flexible untuk mencegah overflow
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                category['name'],
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.black : Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
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
        );
      },
    );
  }

  Widget _buildPartsTags(BuildContext context) {
    return GetBuilder<ServiceNowController>(
      builder: (controller) {
        if (controller.isLoadingCategories.value ||
            controller.isLoadingBrands.value ||
            controller.isLoadingItems.value) {
          return _buildSkeletonBrand();
        }

        if (controller.brands.isEmpty) {
          return const SizedBox.shrink();
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: controller.brands.map((tag) {
              final isSelected = controller.selectedPartTagId == tag['id'];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () => controller.setSelectedPartTag(tag['id']),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary_300
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[300]!),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2))
                            ]
                          : [],
                    ),
                    child: Text(
                      tag['name'],
                      style: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.button_text_01
                            : Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildPartsList() {
    return GetBuilder<ServiceNowController>(
      builder: (controller) {
        if (controller.isLoadingCategories.value ||
            controller.isLoadingBrands.value ||
            controller.isLoadingItems.value) {
          return _buildSkeletonItem();
        }

        if (controller.items.isEmpty) {
          return const Center(
            // Membungkus Column dengan Center
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 5,
                ),
                Text(
                  'No items available',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          );
        }
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.items.length,
          itemBuilder: (context, index) =>
              _buildPartItem(controller.items[index], context),
        );
      },
    );
  }

  Widget _buildPartItem(Map<String, dynamic> part, BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;

    return GetBuilder<ServiceNowController>(
      builder: (controller) {
        final isSelected = controller.selectedParts.contains(part);
        return GestureDetector(
          onTap: () => Get.toNamed(Routes.DETAIL_PRODUCT, arguments: {
            'itemId': part['id'],
          }),
          child: Container(
            height: 900, // Sesuaikan tinggi agar tidak terlalu tinggi
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
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
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24),
                            bottom: Radius.circular(24)),
                      ),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            part['imageUrl'],
                            fit: BoxFit.contain,
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      part['name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          size: 16, color: Colors.amber),
                                      const SizedBox(width: 2),
                                      Text(
                                        part['rating'].toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Text(
                                part['description'],
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Flexible(
                              child: Text(
                                'RM${part['price'].toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12),
                              ),
                            ),
                            const SizedBox(height: 5)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 10,
                  left: 10,
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
                            ? Icon(Icons.radio_button_checked_outlined,
                                size: 20, color: primary_300)
                            : const Icon(Icons.radio_button_unchecked,
                                size: 20, color: Colors.grey),
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

  Widget _buildSkeletonBrand() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(4, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: const SizedBox(
                  width: 60,
                  height: 10,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSkeletonCategory(
      {required int count, required double width, required double height}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: Colors.grey[300]!),
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
                          color: Colors.grey[300],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: 60,
                        height: 10,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSkeletonItem() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 10,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 5),
                Container(
                  width: 50,
                  height: 10,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 10),
                Container(
                  width: 80,
                  height: 10,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
