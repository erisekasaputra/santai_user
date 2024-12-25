import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/domain/entities/order/order_order_res.dart';
import 'package:santai/app/domain/enumerations/order_status.dart';
import 'package:santai/app/domain/usecases/order/get_all_orders.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/utils/custom_date_extension.dart';
import 'package:santai/app/utils/logout_helper.dart';
import 'package:santai/app/utils/session_manager.dart';

class HistoryController extends GetxController {
  final Logout logout = Logout();
  final SessionManager sessionManager = SessionManager();
  final ScrollController scrollController = ScrollController();
  final orders = <Order>[].obs;
  final filteredOrders = <Order>[].obs;
  final selectedFilter = Rx<OrderStatus?>(null);
  final isLoading = false.obs;
  final timezone = ''.obs;
  final lastPage = 1.obs;
  final pageCount = 10.obs;
  GetOrders getOrders;

  HistoryController({required this.getOrders});

  @override
  void onInit() async {
    super.onInit();
    timezone.value =
        await sessionManager.getSessionBy(SessionManagerType.timeZone);
    await loadOrders();
  }

  Future<void> loadMoreOrders() async {
    try {
      isLoading.value = true;

      final itemResponse = await getOrders(lastPage.value + 1, pageCount.value,
          orderStatus: selectedFilter.value?.toString().split('.').last);

      if (itemResponse?.data.items.isEmpty ?? true) {
        return;
      }

      if (timezone.value.isEmpty) {
        CustomToast.show(
            message: 'Time zone is not defined', type: ToastType.info);
        return;
      }

      lastPage.value++;

      var newOrders = itemResponse?.data.items.map((item) {
            var order = Order(
                orderId: item.orderId,
                date: item.createdAtUtc
                    .utcToLocal(timezone.value)
                    .toHumanReadable(withTime: false),
                status: item.orderStatus,
                description: '',
                fleet: item.fleets.first.model,
                address: item.addressLine,
                isRated: item.isRated,
                mechanicName: item.mechanic?.name ?? '',
                mechanicId: item.mechanic?.mechanicId ?? '');
            return order;
          }).toList() ??
          [];

      orders.addAll(newOrders);
      filteredOrders.addAll(newOrders);
    } catch (error) {
      if (error is CustomHttpException) {
        if (error.statusCode == 401) {
          await logout.doLogout();
          return;
        }
        if (error.statusCode == 404) {
          return;
        }
        CustomToast.show(
          message: error.message,
          type: ToastType.error,
        );
        return;
      } else {
        CustomToast.show(
          message: "Uh-oh, Application has an issue",
          type: ToastType.error,
        );
        return;
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<List<OrderResponseData>> loadOrders() async {
    try {
      isLoading.value = true;

      final itemResponse = await getOrders(lastPage.value, pageCount.value,
          orderStatus: selectedFilter.value?.toString().split('.').last);

      if (itemResponse?.data.items.isEmpty ?? true) {
        return [];
      }

      if (timezone.value.isEmpty) {
        CustomToast.show(
            message: 'Time zone is not defined', type: ToastType.info);
        return itemResponse?.data.items ?? [];
      }

      var newOrders = itemResponse?.data.items.map((item) {
            var order = Order(
                orderId: item.orderId,
                date: item.createdAtUtc
                    .utcToLocal(timezone.value)
                    .toHumanReadable(withTime: false),
                status: item.orderStatus,
                description: '',
                fleet: item.fleets.first.model,
                address: item.addressLine,
                isRated: item.isRated,
                mechanicName: item.mechanic?.name ?? '',
                mechanicId: item.mechanic?.mechanicId ?? '');
            return order;
          }).toList() ??
          [];

      orders.addAll(newOrders);
      filteredOrders.clear();
      filteredOrders.addAll(orders);

      return itemResponse?.data.items ?? [];
    } catch (error) {
      if (error is CustomHttpException) {
        if (error.statusCode == 401) {
          await logout.doLogout();
          return [];
        }
        if (error.statusCode == 404) {
          return [];
        }
        CustomToast.show(
          message: error.message,
          type: ToastType.error,
        );
        return [];
      } else {
        CustomToast.show(
          message: "Uh-oh, Application has an issue",
          type: ToastType.error,
        );
        return [];
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void filterOrders(String value) {
    filteredOrders.clear();

    if (value.isEmpty) {
      filteredOrders.addAll(orders);
    } else {
      // Filter the orders list based on the input value
      filteredOrders.addAll(orders.where((order) =>
          order.status
              .toString()
              .toLowerCase()
              .split('.')
              .last
              .contains(value.toLowerCase()) ||
          order.description.toLowerCase().contains(value.toLowerCase()) ||
          order.address.toLowerCase().contains(value.toLowerCase()) ||
          order.fleet.toLowerCase().contains(value.toLowerCase()) ||
          (order.mechanicName?.toLowerCase().contains(value.toLowerCase()) ??
              false)));
    }

    update(); // Notify the UI to rebuild with the updated list
  }

  void setFilter(OrderStatus filter) async {
    if (selectedFilter.value == filter) {
      selectedFilter.value = null;
      orders.clear();
      lastPage.value = 1;
      var items = await loadOrders();
      if (items.isEmpty) {
        orders.clear();
        filteredOrders.clear();
      }
      return;
    }
    selectedFilter.value = filter;
    orders.clear();
    lastPage.value = 1;
    var items = await loadOrders();
    if (items.isEmpty) {
      orders.clear();
      filteredOrders.clear();
    }
  }
}

class Order {
  final String orderId;
  final String date;
  final OrderStatus status;
  final String description;
  final String fleet;
  final String address;
  final bool isRated;
  final String? mechanicName;
  final String? mechanicId;

  Order(
      {required this.orderId,
      required this.date,
      required this.status,
      required this.description,
      required this.fleet,
      required this.address,
      required this.isRated,
      this.mechanicName,
      this.mechanicId});
}
