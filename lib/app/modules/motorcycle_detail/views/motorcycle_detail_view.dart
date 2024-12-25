import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_back_button.dart';
import 'package:santai/app/domain/entities/fleet/fleet_user.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/theme/app_theme.dart';
import 'package:santai/app/utils/custom_date_extension.dart';
import '../controllers/motorcycle_detail_controller.dart';

class MotorcycleDetailView extends GetView<MotorcycleDetailController> {
  const MotorcycleDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    final Color buttonColor1 = Theme.of(context).colorScheme.button_text_01;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 0, 8),
          child: CustomBackButton(onPressed: () {
            if (Get.isDialogOpen ?? false) {
              Get.back(closeOverlays: true);
            } else {
              Get.back(closeOverlays: true);
            }
          }),
        ),
        leadingWidth: 100,
        title: const Text(
          'Garage',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Obx(
                      () => controller.isInitLoading.value
                          ? const SizedBox.shrink()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...controller.resultListFleetUser
                                    .map((motorcycle) {
                                  return _buildMotorcycleCard(context,
                                      motorcycle); // Ensure this returns a Widget
                                }),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Obx(
                      () => controller.userType.value == 'regularUser'
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                onPressed: () {
                                  Get.toNamed(Routes.REG_MOTORCYCLE);
                                },
                                icon: Icon(Icons.add_circle_outline,
                                    color: buttonColor1, size: 16),
                                label: Text(
                                  'Add more',
                                  style: TextStyle(
                                    color: buttonColor1,
                                    fontSize: 12,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: primary_300,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    Align(
                      alignment:
                          Alignment.centerLeft, // Menyelaraskan chips ke kiri
                      child: _buildMotorcycleChips(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotorcycleChips(BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;

    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: controller.scrollController,
          child: Wrap(
            spacing: 8,
            children: controller.resultListFleetUser.map((motorcycle) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 1),
                child: ChoiceChip(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  label: Text(
                    motorcycle.brand,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  selected: motorcycle == controller.selectedMotorcycle.value,
                  onSelected: (selected) {
                    if (selected) {
                      controller.selectedMotorcycle.value = motorcycle;
                      controller.scrollToMotorcycle(motorcycle.id!);
                    } else {
                      controller.selectedMotorcycle.value = null;
                    }
                  },
                  selectedColor: primary_300,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: motorcycle == controller.selectedMotorcycle.value
                        ? Colors.white
                        : Colors.black,
                  ),
                  checkmarkColor: Colors.white,
                  side: BorderSide(color: borderColor, width: 1),
                ),
              );
            }).toList(),
          ),
        ));
  }

  Widget _buildMotorcycleCard(BuildContext context, FleetUser fleet) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    final Color warning_300 = Theme.of(context).colorScheme.warning_300;

    return Obx(() {
      if (controller.resultListFleetUser.isEmpty ||
          controller.isInitLoading.value) {
        return const SizedBox.shrink();
      }

      return Column(
        children: [
          Card(
            key: controller.cardKeys[fleet.id],
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20), // Radius untuk border luar Card
              side: BorderSide(color: borderColor, width: 1),
            ),
            child: Obx(
              () => Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.zero,
                    ),
                    child: Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: fleet.imageUrl.isNotEmpty
                              ? Image.network(
                                  '${controller.urlImgPublic}${fleet.imageUrl}',
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(Icons.image,
                                        size: 60, color: Colors.grey),
                                  ),
                                ),
                        ),
                        if (controller.userType.value == 'regularUser') ...[
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.REG_MOTORCYCLE, arguments: {
                                  'fleetId': fleet.id,
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: warning_300,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.zero,
                                    bottomRight: Radius.zero,
                                    bottomLeft: Radius.zero,
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 8, 20, 8),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.edit_square,
                                          color: Colors.white, size: 18),
                                      const SizedBox(width: 5),
                                      Text(
                                        fleet.brand,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Registration Number',
                            fleet.registrationNumber ?? ''),
                        _buildDetailRow('Brand', fleet.brand),
                        _buildDetailRow('Model', fleet.model),
                        _buildDetailRow(
                            'Engine Number', fleet.engineNumber ?? ''),
                        _buildDetailRow(
                            'Chassis Number', fleet.chassisNumber ?? ''),
                        _buildDetailRow(
                            'Insurance Number', fleet.insuranceNumber ?? ''),
                        _buildDetailRow(
                            'Previous Service',
                            fleet.lastInspectionDateLocal
                                    ?.utcToLocal(controller.timeZone.value)
                                    .toHumanReadable(withTime: false) ??
                                ''),
                        _buildDetailRow('ODO Meter',
                            '${fleet.odometerReading == null ? '' : '${fleet.odometerReading}KM'} '),
                        _buildDetailRow('Year Manufacture',
                            '${fleet.yearOfManufacture ?? ''}'),
                        _buildDetailRow('Owner', fleet.ownerName ?? ''),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      );
    });
  }

  Widget _buildPreferenceRow(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: controller.preferenceItems.map((item) {
        return Expanded(
          child: Container(
            height: 150,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: borderColor.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                ClipOval(
                  child: Container(
                    color: Colors.white,
                    child: ClipOval(
                      child: Image.network('https://picsum.photos/200/200',
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Text(
                    item['title'] as String,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Flexible(
                  child: Text(
                    item['subtitle'] as String,
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.black, fontSize: 12),
              overflow:
                  TextOverflow.ellipsis, // Potong teks jika terlalu panjang
              softWrap: true, // Bungkus teks jika memungkinkan
            ),
          ),
          const SizedBox(width: 8), // Jarak antara teks kiri dan kanan
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black, fontSize: 12),
              textAlign: TextAlign.right, // Ratakan teks ke kanan
              overflow:
                  TextOverflow.ellipsis, // Potong teks jika terlalu panjang
              softWrap: true, // Bungkus teks jika memungkinkan
            ),
          ),
        ],
      ),
    );
  }
}
