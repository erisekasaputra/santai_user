import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_back_button.dart';
import 'package:santai/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai/app/domain/enumerations/order_status.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/theme/app_theme.dart';
import 'package:santai/app/utils/string_splitter.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/service_detail_controller.dart';

class ServiceDetailView extends GetView<ServiceDetailController> {
  const ServiceDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 0, 8),
            child: CustomBackButton(
              onPressed: () => controller.backToDashboard(),
            ),
          ),
          leadingWidth: 100,
          title: const Text(
            'Service Detail',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: controller.orderDetails.value == null &&
                !controller.isLoading.value
            ? _notFoundOrderDetail()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOrderInfo(),
                      _buildTechnicianInfo(context),
                      _buildStatusInfo(context),
                      _buildTotalItems(context),
                      if (!controller.isLoading.value &&
                          (controller.orderDetails.value?.isRated ?? false) &&
                          (controller.orderDetails.value?.isCancelled ??
                              false)) ...[
                        CustomElevatedButton(
                          onPressed: () {
                            Get.toNamed(Routes.RATE_SERVICE, arguments: {
                              'orderId': controller.orderId.value,
                              'mechanicId':
                                  controller.orderDetails.value?.mechanicId ??
                                      "",
                              'mechanicName':
                                  controller.orderDetails.value?.mechanicName ??
                                      "",
                              'mechanicImageUrl': controller
                                      .orderDetails.value?.mechanicImageUrl ??
                                  ""
                            });
                          },
                          text: 'Rate',
                        ),
                      ],
                      const SizedBox(height: 10),
                      if (!controller.isLoading.value &&
                          !(controller.orderDetails.value?.isCancelled ??
                              false) &&
                          controller.orderDetails.value?.status !=
                              OrderStatus.serviceCompleted &&
                          controller.orderDetails.value?.status !=
                              OrderStatus.serviceIncompleted) ...[
                        CustomElevatedButton(
                          onPressed: () {
                            Get.defaultDialog(
                              title: 'Cancel Order',
                              middleText:
                                  'Are you sure you want to cancel the order?',
                              textConfirm: 'Yes',
                              textCancel: 'No',
                              confirmTextColor: Colors.white,
                              cancelTextColor: Colors.black,
                              buttonColor:
                                  Colors.red, // Button color for confirm button
                              onConfirm: () async {
                                await controller.processCancelOrder();
                              },
                              onCancel: () {},
                            );
                          },
                          text: 'Cancel Order',
                          backgroundColor: Colors.red.shade700,
                        ),
                      ],
                      if (!controller.isLoading.value &&
                          controller.orderDetails.value?.status ==
                              OrderStatus.paymentPending) ...[
                        const SizedBox(
                          height: 10,
                        ),
                        CustomElevatedButton(
                          onPressed: () {
                            if (controller.orderDetails.value == null ||
                                controller.orderDetails.value?.paymentUrl ==
                                    null ||
                                controller.orderDetails.value?.orderSecret ==
                                    null) {
                              return;
                            }
                            Get.toNamed(Routes.PAYMENT, arguments: {
                              'paymentUrl':
                                  controller.orderDetails.value?.paymentUrl,
                              'orderSecret':
                                  controller.orderDetails.value?.orderSecret
                            });
                          },
                          text: 'Make Payment',
                        ),
                      ],
                      if (controller.orderDetails.value != null &&
                          !controller.orderDetails.value!.isRated &&
                          (controller.orderDetails.value!.status ==
                                  OrderStatus.serviceCompleted ||
                              controller.orderDetails.value!.status ==
                                  OrderStatus.serviceIncompleted)) ...[
                        const SizedBox(
                          height: 10,
                        ),
                        CustomElevatedButton(
                          onPressed: () {
                            Get.toNamed(Routes.RATE_SERVICE, arguments: {
                              'orderId': controller.orderId.value,
                              'mechanicId':
                                  controller.orderDetails.value?.mechanicId ??
                                      "",
                              'mechanicName':
                                  controller.orderDetails.value?.mechanicName ??
                                      "",
                              'mechanicImageUrl': controller
                                      .orderDetails.value?.mechanicImageUrl ??
                                  ""
                            });
                          },
                          text: 'Rate',
                        ),
                      ]
                    ],
                  ),
                ),
              ),
      );
    });
  }

  Widget _notFoundOrderDetail() {
    return const SizedBox.shrink();
  }

  Widget _buildOrderInfo() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 16,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Container(
                width: 150,
                height: 24,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 22, color: Colors.grey),
                  const SizedBox(width: 4),
                  Container(
                    width: 200,
                    height: 14,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Order ID',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              Text(controller.orderDetails.value?.date ?? '',
                  style: const TextStyle(fontSize: 14)),
            ],
          ),
          Text(
              '#${controller.orderDetails.value?.orderId.substring(0, 8).toUpperCase() ?? ''}',
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 22, color: Colors.red),
              const SizedBox(width: 4),
              Expanded(
                  child: Text(controller.orderDetails.value?.location ?? '',
                      style: const TextStyle(fontSize: 14))),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildTechnicianInfo(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    return Obx(() {
      if (controller.isLoading.value) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const CircleAvatar(radius: 35, backgroundColor: Colors.white),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 80, height: 16, color: Colors.white),
                    const SizedBox(height: 4),
                    Container(width: 120, height: 20, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        );
      }

      if (controller.orderDetails.value?.mechanicName == null) {
        return const SizedBox.shrink();
      }
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Obx(
                  () => CircleAvatar(
                      radius: 35,
                      backgroundImage: controller
                                  .orderDetails.value?.mechanicImageUrl ==
                              null
                          ? Image.asset('assets/images/mechanic-user.png').image
                          : Image.network(
                                  '${controller.commonImageUrl.value}${controller.orderDetails.value!.mechanicImageUrl}')
                              .image),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Technician', style: TextStyle(fontSize: 16)),
                    Row(
                      children: [
                        Text(controller.orderDetails.value?.mechanicName ?? "",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 4),
                        const Icon(Icons.flag, size: 20, color: Colors.red),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () => Get.toNamed(Routes.CHAT, arguments: {
                'orderId': controller.orderId.value,
                'mechanicId': controller.orderDetails.value?.mechanicId ?? "",
                'mechanicName':
                    controller.orderDetails.value?.mechanicName ?? "",
                "mechanicImageUrl":
                    controller.orderDetails.value?.mechanicImageUrl ?? ""
              }),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary_300,
                ),
                child: const Icon(Icons.chat, color: Colors.white, size: 24),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatusInfo(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    IconData statusIcon;
    Color statusColor;

    return Obx(() {
      if (controller.isLoading.value) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Container(width: 150, height: 30, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 8),
                Container(width: 100, height: 16, color: Colors.white),
                const SizedBox(height: 8),
                Container(
                    width: double.infinity, height: 14, color: Colors.white),
              ],
            ),
          ),
        );
      }

      // PaymentPaid = 1,
      // FindingMechanic = 2,
      // MechanicAssigned = 4,
      // MechanicDispatched = 5,
      // MechanicArrived = 6,
      // ServiceInProgress = 7,
      // ServiceCompleted = 8,
      // ServiceIncompleted = 9,
      // OrderCancelledByUser = 20,
      // OrderCancelledByMechanic = 21,

      switch (controller.orderDetails.value?.status) {
        case OrderStatus.paymentPending:
          statusIcon = Icons.info;
          statusColor = Colors.orange;
          break;
        case OrderStatus.orderCancelledByUser ||
              OrderStatus.orderCancelledByMechanic:
          statusIcon = Icons.cancel;
          statusColor = Colors.red;
          break;
        case OrderStatus.paymentPaid ||
              OrderStatus.findingMechanic ||
              OrderStatus.mechanicAssigned ||
              OrderStatus.mechanicDispatched ||
              OrderStatus.mechanicArrived ||
              OrderStatus.serviceInProgress ||
              OrderStatus.serviceCompleted ||
              OrderStatus.serviceIncompleted:
          statusIcon = Icons.check;
          statusColor = Colors.green;
          break;
        default:
          statusIcon = Icons.info;
          statusColor = Colors.blue;
      }
      return Container(
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 30),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    splitCamelCase(
                      controller.orderDetails.value?.status
                              .toString()
                              .split('.')
                              .last ??
                          '',
                    ),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    softWrap: true, // Membuat teks bisa dibungkus ke bawah
                    overflow: TextOverflow
                        .visible, // Menentukan bagaimana overflow diatur
                  ),
                ),
              ],
            ),
            if (controller.orderDetails.value?.updateDescription != null &&
                controller.orderDetails.value?.updateDescription != '') ...[
              const SizedBox(height: 8),
              const Text('Motorcycle Update',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(
                controller.orderDetails.value?.updateDescription ??
                    'There is no update',
                style: const TextStyle(fontSize: 14),
              ),
            ]
          ],
        ),
      );
    });
  }

  Widget _buildTotalItems(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    return Obx(() {
      if (controller.isLoading.value) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 100, height: 16, color: Colors.white),
                const SizedBox(height: 8),
                Divider(thickness: 1, color: Colors.grey[300]),
                const SizedBox(height: 8),
                Container(
                    width: double.infinity, height: 14, color: Colors.white),
                const SizedBox(height: 8),
                Container(
                    width: double.infinity, height: 14, color: Colors.white),
                const SizedBox(height: 8),
                Divider(thickness: 1, color: Colors.grey[300]),
                Container(
                    width: double.infinity, height: 14, color: Colors.white),
              ],
            ),
          ),
        );
      }

      return Container(
          margin: const EdgeInsets.only(bottom: 10, top: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Item',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                Divider(thickness: 1, color: borderColor),
                const SizedBox(height: 5),
                ...?controller.orderDetails.value?.items.map((item) =>
                    _buildItemRow(item['name'] ?? '', item['price'] ?? '')),
                const SizedBox(height: 5),
                Divider(thickness: 1, color: borderColor),
                const SizedBox(height: 5),
                ...?controller.orderDetails.value?.fees.map((item) =>
                    _buildItemRow(item['name'] ?? '', item['price'] ?? '')),
                const SizedBox(height: 5),
                Divider(thickness: 1, color: borderColor),
                const SizedBox(height: 5),
                _buildItemRow('Grand Total',
                    controller.orderDetails.value?.grandTotal ?? '',
                    isBold: true, isBigger: true),
              ],
            ),
          ));
    });
  }

  Widget _buildItemRow(String name, String price,
      {String parameter = '+', bool isBold = false, bool isBigger = false}) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100, // Lebar sesuai dengan teks "name"
                  height: 16,
                  color: Colors.white,
                ),
                Container(
                  width: 60, // Lebar sesuai dengan teks "price"
                  height: 16,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Wrap the name text with a Wrap widget
            Expanded(
              child: Wrap(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: isBigger ? 14 : 12,
                      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            // Align the price text to the right
            Expanded(
              child: Align(
                alignment:
                    Alignment.centerRight, // Align the price text to the right
                child: Wrap(
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: isBigger ? 14 : 12,
                        fontWeight:
                            isBold ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
