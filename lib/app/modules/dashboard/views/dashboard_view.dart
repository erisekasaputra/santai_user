import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/animation_background.dart';
import 'package:santai/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai/app/modules/dashboard/widget/location_picker_widget.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/theme/app_theme.dart';
import 'package:santai/app/utils/greetings.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  void _showLocationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LocationPickerWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: controller.reload,
        child: Stack(
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  child: _buildCustomAppBar(),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(10.0),
                    children: [
                      const SizedBox(height: 10),
                      Obx(() => controller.isBannerLoading.value
                          ? const Column(
                              children: [CircularProgressIndicator()],
                            )
                          : _buildImagePlaceholder(
                              controller.listImagesCoupon)),
                      const SizedBox(height: 15),
                      Obx(() {
                        // Kondisi Reaktif untuk Service Progress
                        if (controller.isLoadingServiceProgress.value) {
                          return _buildShimmerServiceProgress(context);
                        }
                        if (controller.listServiceProgress.isNotEmpty) {
                          return _buildServiceProgress(context);
                        }
                        return const SizedBox.shrink();
                      }),
                      Obx(() {
                        // Kondisi Reaktif untuk Service Progress
                        if (controller.isLoadingServiceProgress.value) {
                          return const SizedBox(height: 10);
                        }
                        if (controller.listServiceProgress.isNotEmpty) {
                          return const SizedBox(height: 10);
                        }
                        return const SizedBox.shrink();
                      }),
                      _buildMotorcycleList(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomNavigationBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Builder(builder: (BuildContext context) {
      return ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
          child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0078B5), // Biru muda lebih tua
                  Color(0xFF2A5F7E),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Animasi bintang melayang di belakang
                const Positioned.fill(
                  child: AnimatedFloatingStars(),
                ),
                // Konten utama, teks, gambar, dll
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () => CircleAvatar(
                              radius: 32,
                              backgroundImage:
                                  controller.profileImageUrl.value.isEmpty
                                      ? null
                                      : Image.network(
                                          '${controller.commonUrl}${controller.profileImageUrl.value}',
                                        ).image,
                              child: controller.profileImageUrl.value.isEmpty
                                  ? const Icon(
                                      Icons.person,
                                      size: 35,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(getGreeting(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16)),
                                Obx(
                                  () => Text(
                                    controller.userName.value,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Obx(
                            () => controller.listServiceProgress.isNotEmpty
                                ? GestureDetector(
                                    onTap: () => controller.showQR(),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10.0), // Padding di kanan
                                        child: Image.asset(
                                          'assets/icons/qris.png', // Path ke asset gambar
                                          width: 52,
                                          height: 52,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Obx(
                              () => GestureDetector(
                                onTap: () async {
                                  await controller.getCurrentLocation();
                                },
                                child: controller.isLocationLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.black),
                                        ),
                                      )
                                    : const Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                      ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Obx(() => Text(
                                    controller.currentAddress.value,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                    overflow: TextOverflow.ellipsis,
                                  )),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                controller.openMap();
                              },
                              child: const Icon(
                                Icons.map_sharp,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ],
            ),
          ));
    });
  }

  Widget _buildImagePlaceholder(List<String> imageUrls) {
    return imageUrls.isEmpty
        ? const SizedBox.shrink()
        : SizedBox(
            height: 180,
            child: PageView.builder(
              itemCount: imageUrls.length,
              controller: PageController(
                viewportFraction: 1.0,
              ), // Gambar tetap penuh
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ), // Tambahkan jarak antar gambar
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Container(
                      color: Colors.grey[300],
                      child: Image.network(
                        '${controller.commonUrl.value}${imageUrls[index]}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }

  Widget _buildShimmerServiceProgress(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: SizedBox(
          height: 70,
          child: PageView.builder(
            itemCount: 3, // Placeholder shimmer page count
            itemBuilder: (context, index) {
              return _buildShimmerTimelineTile(); // Placeholder shimmer tile
            },
          ),
        ),
      ),
    );
  }

  Widget _buildServiceProgress(BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    final Color warning_300 = Theme.of(context).colorScheme.warning_300;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Service Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          GestureDetector(
            onTap: () => controller.showServiceDetail(),
            child: Obx(
              () {
                final services = controller.listServiceProgress;
                if (services.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 100,
                    child: PageView.builder(
                      itemCount: services.length,
                      onPageChanged: (index) =>
                          controller.currentServiceIndex.value = index,
                      itemBuilder: (context, pageIndex) {
                        final service = services[pageIndex];
                        final steps = service.steps;

                        return Row(
                          children: steps.asMap().entries.map((entry) {
                            final index = entry.key;
                            final step = entry.value;
                            final isActive = index <= service.currentStep;
                            final isLast = index == steps.length - 1;

                            return Expanded(
                              child: TimelineTile(
                                axis: TimelineAxis.horizontal,
                                alignment: TimelineAlign.center,
                                isFirst: index == 0,
                                isLast: isLast,
                                indicatorStyle: IndicatorStyle(
                                  width: 20,
                                  color: isActive ? primary_300 : warning_300,
                                  iconStyle: IconStyle(
                                    color: Colors.white,
                                    iconData: isActive
                                        ? Icons.check_circle_rounded
                                        : Icons.circle,
                                    fontSize: 16,
                                  ),
                                ),
                                beforeLineStyle: LineStyle(
                                  thickness: 10,
                                  color: isActive ? primary_300 : warning_300,
                                ),
                                endChild: Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Text(
                                    step,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          isActive ? primary_300 : Colors.black,
                                      fontWeight: isActive
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildShimmerTimelineTile() {
    return Row(
      children: List.generate(5, (index) {
        return Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.center,
              isFirst: index == 0,
              isLast: index == 4,
              indicatorStyle: const IndicatorStyle(
                width: 18,
                color: Colors.grey,
              ),
              beforeLineStyle: const LineStyle(
                color: Colors.grey,
              ),
              endChild: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Container(
                  width: double.infinity,
                  height: 20,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMotorcycleList() {
    return Obx(() {
      if (controller.isLoadingMotorCycle.value) {
        return _buildShimmerMotorcycleList();
      }
      return Builder(builder: (BuildContext context) {
        final Color borderInput_01 =
            Theme.of(context).colorScheme.borderInput_01;
        return Padding(
          padding: const EdgeInsets.all(5), // Margin di luar Card
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: borderInput_01, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Choose your motorcycle',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                ),
                Obx(() {
                  if (controller.motorcycles.isEmpty) {
                    return const Center(
                        child: Text('No motorcycles are available'));
                  }
                  return Column(
                    children:
                        controller.motorcycles.asMap().entries.map((entry) {
                      final index = entry.key;
                      final motorcycle = entry.value;
                      return GestureDetector(
                        onTap: () => controller.selectMotorcycle(index),
                        child: _buildMotorcycleItem(motorcycle,
                            isSelected: index ==
                                controller.selectedMotorcycleIndex.value),
                      );
                    }).toList(),
                  );
                }),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Obx(() => CustomElevatedButton(
                        backgroundColor:
                            controller.selectedMotorcycleIndex.value == -1
                                ? Colors.grey.shade400
                                : null,
                        text: 'Services',
                        onPressed: controller.selectedMotorcycleIndex.value !=
                                -1
                            ? () {
                                final selectedMotorcycle = controller
                                        .motorcycles[
                                    controller.selectedMotorcycleIndex.value];
                                Get.toNamed(Routes.SERVICE_NOW, arguments: {
                                  'fleetId': selectedMotorcycle.id,
                                  'fleetModel': selectedMotorcycle.plateNumber
                                });
                              }
                            : null,
                      )),
                ),
              ],
            ),
          ),
        );
      });
    });
  }

  Widget _buildMotorcycleItem(Motorcycle motorcycle,
      {bool isSelected = false}) {
    return Builder(builder: (BuildContext context) {
      final Color borderInput_01 = Theme.of(context).colorScheme.borderInput_01;
      final Color primary_300 = Theme.of(context).colorScheme.primary_300;
      return Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    primary_300.withOpacity(0.6),
                    primary_300.withOpacity(1)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(16),
          border:
              isSelected ? null : Border.all(color: borderInput_01, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: Image.network(
                    motorcycle.image,
                    height: 72,
                    width: 72,
                  ).image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    motorcycle.plateNumber.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${motorcycle.brand.toUpperCase()} ${motorcycle.model.toUpperCase()}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white70 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white, size: 24),
          ],
        ),
      );
    });
  }

  Widget _buildBottomNavigationBar() {
    return Builder(builder: (BuildContext context) {
      final Color primary_300 = Theme.of(context).colorScheme.primary_300;

      return Container(
        padding: const EdgeInsets.all(2),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedItemColor: primary_300,
            unselectedItemColor: primary_300,
            onTap: controller.navigateToPage,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/motorbike.png', // Path ke asset gambar
                  width: 30,
                  height: 30,
                  fit: BoxFit.fitWidth,
                ),
                label: 'Garage',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/notification-text-square.png', // Path ke asset gambar
                  width: 30,
                  height: 30,
                  fit: BoxFit.fitWidth,
                ),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/notification-text-circle.png', // Path ke asset gambar
                  width: 30,
                  height: 30,
                  fit: BoxFit.fitWidth,
                ),
                label: 'Inbox',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/menu.png', // Path ke asset gambar
                  width: 30,
                  height: 30,
                  fit: BoxFit.fitWidth,
                ),
                label: 'Settings',
              ),
            ],
          ),
        ),
      );
    });
  }

  // Fungsi untuk menampilkan shimmer skeleton pada item motor
  Widget _buildShimmerMotorcycleList() {
    return Column(
      children: List.generate(5, (index) => _buildShimmerMotorcycleItem()),
    );
  }

  Widget _buildShimmerMotorcycleItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Placeholder untuk gambar motor
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 12),
              // Placeholder untuk detail motor
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150,
                      height: 16,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 100,
                      height: 14,
                      color: Colors.grey[400],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
