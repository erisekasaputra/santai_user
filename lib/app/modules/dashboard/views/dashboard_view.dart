import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/theme/app_theme.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: _buildCustomAppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImagePlaceholder(),
                  _buildServiceProgress(),
                  const SizedBox(height: 20),
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

    PreferredSize _buildCustomAppBar() {
      return PreferredSize(
        preferredSize: Size.fromHeight(190),
        child: Builder(
          builder: (BuildContext context) {
          final Color primary_200 = Theme.of(context).colorScheme.primary_200;
            return Container(
              padding: EdgeInsets.only(top: MediaQuery.of(Get.context!).padding.top),
              decoration: BoxDecoration(
                color: primary_200,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: Image.network('https://picsum.photos/200/200').image,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Good Morning', style: TextStyle(color: Colors.white, fontSize: 14)),
                                Text('Hello ${controller.userName}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        child: const Icon(Icons.qr_code, color: Colors.white, size: 40), 
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Obx(() => Text(
                              controller.address,
                              style: TextStyle(color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            )),
                          ),
                          const SizedBox(width: 8),
                          Obx(() => controller.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                              ),
                            )
                          : Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.map, color: Colors.grey[500]),
                                onPressed: () {
                                  controller.locationService.getCurrentLocation();
                                },
                              ),
                            ),
                        ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      );
  }

  Widget _buildImagePlaceholder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 150,
        width: double.infinity,
        color: Colors.grey[300],
        child: Image.network(
          'https://picsum.photos/200/200',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

Widget _buildServiceProgress() {
  return Builder(
    builder: (BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
                  'Service Progress', 
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold, 
              color: Colors.black
            )
          ),
          SizedBox(
            height: 80,
            child: PageView.builder(
              itemCount: controller.serviceProgresses.length,
              onPageChanged: (index) => controller.currentServiceIndex.value = index,
              itemBuilder: (context, index) {
                final service = controller.serviceProgresses[index];
                return _buildTimelineTiles(service);
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controller.serviceProgresses.length,
              (index) => Obx(() => Container(
                width: 11,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: controller.currentServiceIndex.value == index ? primary_300: Colors.grey,
                ),
              )),
            ),
          ),
        ],
      );
    }
  );
}

Widget _buildTimelineTiles(ServiceProgress service) {
  return Builder(
    builder: (BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    final Color warning_300 = Theme.of(context).colorScheme.warning_300;
      return Row(
        children: service.steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          final isActive = index <= service.currentStep;
          final isLast = index == service.steps.length - 1;
      
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
                  iconData: isActive ? Icons.check_circle_rounded: Icons.circle,
                  fontSize: 14,
                ),
              ),
              beforeLineStyle: LineStyle(
                color: isActive ? primary_300 : warning_300,
              ),
              endChild: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  step,
                  style: TextStyle(
                    color: isActive ? primary_300 : Colors.black,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      );
    }
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
  return Builder(
    builder: (BuildContext context) {
    final Color borderInput_01 = Theme.of(context).colorScheme.borderInput_01;
      return Card(
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
  );
}

Widget _buildMotorcycleItem(Motorcycle motorcycle, {bool isSelected = false}) {

  return Builder(
    builder: (BuildContext context) {
    final Color borderInput_01 = Theme.of(context).colorScheme.borderInput_01;
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;

      return Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          // color: isSelected ? primary_300 : Colors.white,
          gradient: isSelected 
              ? LinearGradient(
                  colors: [primary_300.withOpacity(0.6), primary_300.withOpacity(1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? null : Border.all(color: borderInput_01, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://picsum.photos/200/200',
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
                    motorcycle.plateNumber,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '${motorcycle.brand} ${motorcycle.model}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Next Service',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '01/12/2024', 
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  );
}

  Widget _buildBottomNavigationBar() {
  return Builder(
     builder: (BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    final Color primary_50 = Theme.of(context).colorScheme.primary_50;

      return Container(
        padding: const EdgeInsets.all(2),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!, width: 1),
          boxShadow: [
            BoxShadow(
              color: primary_300.withOpacity(0.3),
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
          selectedItemColor: primary_50,
          unselectedItemColor: primary_300,
          onTap: controller.navigateToPage,
          selectedFontSize: 14,
          unselectedFontSize: 14,
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
  );
}
}