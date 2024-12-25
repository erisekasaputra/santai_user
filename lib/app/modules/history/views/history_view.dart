import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_back_button.dart';
import 'package:santai/app/domain/enumerations/order_status.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/theme/app_theme.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

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
              Get.back();
            },
          ),
        ),
        leadingWidth: 100,
        title: const Text(
          'History',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchBar(context),
          _buildFilterChips(context),
          _buildOrderList(context),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: const Icon(
            Icons.search,
            size: 30, // Ukuran total ikon
          ),
          // Border ketika tidak fokus
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFB0B2B6), // Warna border saat tidak fokus
            ),
          ),
          // Border ketika fokus
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.blue, // Warna border saat fokus
            ),
          ),
        ),
        onChanged: (value) {
          controller.filterOrders(value);
        },
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('Payment Pending', OrderStatus.paymentPending,
                primary_300, borderColor),
            const SizedBox(width: 8),
            _buildFilterChip('Payment Complete', OrderStatus.paymentPaid,
                primary_300, borderColor),
            const SizedBox(width: 8),
            _buildFilterChip('Mechanic Discovery', OrderStatus.findingMechanic,
                primary_300, borderColor),
            const SizedBox(width: 8),
            _buildFilterChip('Mechanic Assigned', OrderStatus.mechanicAssigned,
                primary_300, borderColor),
            const SizedBox(width: 8),
            _buildFilterChip('Mechanic Dispatched',
                OrderStatus.mechanicDispatched, primary_300, borderColor),
            const SizedBox(width: 8),
            _buildFilterChip('Mechanic Arrived', OrderStatus.mechanicArrived,
                primary_300, borderColor),
            const SizedBox(width: 8),
            _buildFilterChip('Service Started', OrderStatus.serviceInProgress,
                primary_300, borderColor),
            const SizedBox(width: 8),
            _buildFilterChip('Service Completed', OrderStatus.serviceCompleted,
                primary_300, borderColor),
            const SizedBox(width: 8),
            _buildFilterChip('Service Incompleted',
                OrderStatus.serviceIncompleted, primary_300, borderColor),
            const SizedBox(width: 8),
            _buildFilterChip('Order Cancelled',
                OrderStatus.orderCancelledByUser, primary_300, borderColor),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
      String label, OrderStatus status, Color primary_300, Color borderColor) {
    return Obx(() => FilterChip(
          label: Text(label),
          selected: controller.selectedFilter.value == status,
          onSelected: (selected) => controller.setFilter(status),
          backgroundColor: Colors.white,
          selectedColor: primary_300,
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
            color: controller.selectedFilter.value == status
                ? Colors.white
                : Colors.black,
          ),
          side: BorderSide(color: borderColor),
        ));
  }

  Widget _buildShimmerOrderCard(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!, // Warna dasar shimmer
          highlightColor: Colors.grey[100]!, // Warna highlight shimmer
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Simulate the order header with shimmer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 100,
                        height: 20,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                  Container(
                    width: 60,
                    height: 20,
                    color: Colors.grey[300],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Simulate status text with shimmer
              Container(
                width: 120,
                height: 20,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 8),
              // Simulate description with shimmer
              Container(
                width: double.infinity,
                height: 14,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 8),
              // Simulate buttons with shimmer
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList(BuildContext context) {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return ListView(
            controller: controller
                .scrollController, // jika kamu menggunakan ScrollController
            children: [
              _buildShimmerOrderCard(context),
              _buildShimmerOrderCard(context),
              _buildShimmerOrderCard(context),
              _buildShimmerOrderCard(context),
              _buildShimmerOrderCard(context),
            ],
          );
        } else {
          return ListView.builder(
            controller: controller.scrollController,
            itemCount: controller.filteredOrders.length +
                1, // Tambahkan 1 untuk tombol Load More
            itemBuilder: (context, index) {
              if (index == controller.filteredOrders.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Obx(
                    () => controller.isLoading.value
                        ? Container(
                            width: 24, // Anda bisa sesuaikan ukuran
                            height: 40,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(
                              strokeWidth: 4.0, // Sesuaikan ketebalan garis
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.green), // Warna progress
                              backgroundColor: Colors
                                  .white, // Pastikan backgroundnya transparan
                            ),
                          )
                        : ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : controller
                                    .loadMoreOrders, // Disable button if loading
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .transparent, // Set button background to transparent
                              overlayColor: Colors
                                  .transparent, // Set text color when not loading
                              shadowColor:
                                  Colors.transparent, // Remove the shadow
                              padding: const EdgeInsets.symmetric(
                                  vertical: 1.0,
                                  horizontal: 1.0), // Padding for the button
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(1), // Rounded corners
                                side: const BorderSide(
                                    color: Colors.transparent,
                                    width: 0), // Border color
                              ),
                            ),
                            child: const Text('Load More'),
                          ),
                  ),
                );
              }

              // Tampilkan item order biasa
              final order = controller.filteredOrders[index];
              return _buildOrderCard(context, order);
            },
          );
        }
      }),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(24),
      ),
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(context, order),
            const SizedBox(height: 10),
            if (order.description.isNotEmpty) ...[
              const Text(
                "Motorcycle Update",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(order.description),
              const SizedBox(height: 10),
            ],
            Row(
              children: [
                const Icon(Icons.location_on, size: 22, color: Colors.red),
                const SizedBox(width: 4),
                Expanded(
                    child: Text(order.address,
                        style: const TextStyle(fontSize: 14))),
              ],
            ),
            const SizedBox(height: 20),
            _buildOrderButtons(context, order),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader(BuildContext context, Order order) {
    IconData statusIcon = Icons.info_outline_rounded;
    Color iconColor = Colors.blue.shade700;

    if (order.status == OrderStatus.orderCancelledByUser ||
        order.status == OrderStatus.orderCancelledByMechanic) {
      // Status pembatalan
      statusIcon = Icons.cancel_rounded; // Ikon lebih jelas untuk pembatalan
      iconColor = Colors.red.shade700;
    } else if (order.status == OrderStatus.paymentPending) {
      // Status menunggu pembayaran
      statusIcon = Icons.hourglass_empty_rounded; // Ikon menunggu pembayaran
      iconColor = Colors.orange.shade600;
    } else if (order.status == OrderStatus.paymentPaid) {
      // Status pembayaran selesai
      statusIcon = Icons.attach_money_rounded; // Ikon pembayaran berhasil
      iconColor = Colors.green.shade700;
    } else if (order.status == OrderStatus.findingMechanic ||
        order.status == OrderStatus.mechanicAssigned) {
      // Status mencari atau mekanik ditugaskan
      statusIcon = Icons.search_rounded; // Ikon pencarian mekanik
      iconColor = Colors.yellow.shade800;
    } else if (order.status == OrderStatus.mechanicDispatched) {
      // Status mekanik dalam perjalanan
      statusIcon = Icons.directions_car_rounded; // Ikon mobil dalam perjalanan
      iconColor = Colors.blue.shade600;
    } else if (order.status == OrderStatus.mechanicArrived) {
      // Status mekanik telah sampai
      statusIcon = Icons.location_on_rounded; // Ikon lokasi mekanik tiba
      iconColor = Colors.green.shade700;
    } else if (order.status == OrderStatus.serviceInProgress) {
      // Status servis sedang berlangsung
      statusIcon = Icons.build_rounded; // Ikon alat untuk proses servis
      iconColor = Colors.amber.shade700;
    } else if (order.status == OrderStatus.serviceCompleted) {
      // Status servis selesai
      statusIcon =
          Icons.verified_rounded; // Ikon tanda verifikasi untuk servis selesai
      iconColor = Colors.green.shade700;
    } else if (order.status == OrderStatus.serviceIncompleted) {
      // Status servis tidak selesai
      statusIcon =
          Icons.error_rounded; // Ikon tanda kesalahan untuk servis gagal
      iconColor = Colors.red.shade700;
    } else {
      // Default status (jika status tidak diketahui)
      statusIcon = Icons.info_outline_rounded;
      iconColor = Colors.blue.shade700;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Bagian kiri (order status), yang bisa digulir jika overflow
        Expanded(
          child: SingleChildScrollView(
            scrollDirection:
                Axis.horizontal, // Membuat konten scrollable secara horizontal
            child: Row(
              mainAxisSize: MainAxisSize
                  .min, // Membatasi lebar row hanya untuk konten yang ada
              children: [
                Icon(
                  statusIcon,
                  color: iconColor,
                  size: 30,
                ),
                const SizedBox(width: 8),
                Text(
                  order.status.status,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bagian kanan (Order ID dan Date) tetap di tempat tanpa digulir
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Order ID #${order.orderId.substring(0, 8).toUpperCase()}',
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
            Text(
              order.date,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderButtons(BuildContext context, Order order) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;

    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            Get.toNamed(Routes.SERVICE_DETAIL, arguments: {
              'orderId': order.orderId,
              'mechanicId': order.mechanicId,
              'mechanicName': order.mechanicName
            });
          },
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(92, 28),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: borderColor, width: 1),
            ),
          ),
          child: const Text('Detail'),
        ),
        if ((order.status == OrderStatus.serviceIncompleted ||
                order.status == OrderStatus.serviceCompleted) &&
            !order.isRated) ...[
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.RATE_SERVICE, arguments: {
                'orderId': order.orderId,
                'mechanicId': order.mechanicId,
                'mechanicName': order.mechanicName
              });
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(92, 28),
              backgroundColor: primary_300,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Rate'),
          ),
        ],
      ],
    );
  }
}
