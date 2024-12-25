import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/domain/enumerations/order_status.dart';
import 'package:santai/app/domain/usecases/order/cancel_order.dart';
import 'package:santai/app/domain/usecases/order/get_order_detail.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/utils/custom_date_extension.dart';
import 'package:santai/app/utils/logout_helper.dart';
import 'package:santai/app/utils/session_manager.dart';
import 'package:santai/app/utils/string_splitter.dart';

class ServiceDetailController extends GetxController {
  final Logout logout = Logout();
  final SessionManager sessionManager = SessionManager();
  final orderDetails = Rx<OrderDetails?>(null);
  final isLoading = false.obs;
  final orderId = ''.obs;
  final isCancelled = false.obs;
  final SingleOrderDetail singleOrderDetail;
  final CancelOrder cancelOrder;
  ServiceDetailController(
      {required this.singleOrderDetail, required this.cancelOrder});
  final commonImageUrl = ''.obs;
  @override
  void onInit() async {
    super.onInit();
    orderId.value =
        Get.arguments?['orderId'] ?? '00000-0000-0000-0000-000000000000';
    await fetchServiceDetail();
    commonImageUrl.value =
        await sessionManager.getSessionBy(SessionManagerType.commonFileUrl);
  }

  Future<void> fetchServiceDetail() async {
    try {
      isLoading.value = true;
      if (orderId.value == '') {
        return;
      }

      var orderData = await singleOrderDetail(orderId.value);
      if (orderData == null) {
        return;
      }

      final List<Map<String, String>> mappedItems = orderData.data.lineItems
          .map((item) => {
                'name': item.name,
                'price':
                    '${item.currency.toUpperCase()}${item.unitPrice.toString()}',
                'parameter': '+'
              })
          .toList();

      final List<Map<String, String>> fees = [];

      double total =
          orderData.data.lineItems.fold(0, (sum, item) => sum + item.unitPrice);

      fees.add({
        'name': 'Total',
        'price': '${orderData.data.currency.toUpperCase()}${total.toString()}',
        'parameter': '+'
      });

      fees.addAll(orderData.data.fees
          .map((fee) => {
                'name': splitCamelCase(fee.feeDescription),
                'price':
                    '${fee.currency.toUpperCase()}${fee.feeAmount.toString()}',
                'parameter': '+'
              })
          .toList());

      if (orderData.data.discount != null) {
        fees.add({
          'name': "Discount",
          'price':
              '${orderData.data.discount?.currency.toUpperCase() ?? ''}${orderData.data.discount?.discountAmount.toString() ?? ''}',
          'parameter': '-'
        });
      }

      final createdAt = orderData.data.createdAtUtc
          .utcToLocal(
              (await sessionManager.getSessionBy(SessionManagerType.timeZone)))
          .toHumanReadable();
      orderDetails.value = OrderDetails(
          orderId: orderData.data.orderId,
          date: createdAt,
          location: orderData.data.addressLine,
          mechanicId: orderData.data.mechanic?.mechanicId,
          mechanicName: orderData.data.mechanic?.name,
          mechanicImageUrl: orderData.data.mechanic?.imageUrl,
          status: orderData.data.orderStatus,
          updateDescription: '',
          items: mappedItems,
          fees: fees,
          grandTotal:
              '${orderData.data.currency.toUpperCase()} ${orderData.data.grandTotal}',
          isRated: orderData.data.isRated,
          isCancelled:
              orderData.data.orderStatus == OrderStatus.orderCancelledByUser,
          paymentUrl: orderData.data.paymentUrl,
          orderSecret: orderData.data.secret);

      isCancelled.value =
          orderData.data.orderStatus == OrderStatus.orderCancelledByUser;
    } catch (error) {
      Get.back(closeOverlays: true);
      if (error is CustomHttpException) {
        if (error.statusCode == 401) {
          await logout.doLogout();
          return;
        }
        CustomToast.show(
          message: error.message,
          type: ToastType.error,
        );
      } else {
        CustomToast.show(
          message: "Internal server error has occured",
          type: ToastType.error,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> processCancelOrder() async {
    try {
      var result = await cancelOrder(orderId.value);
      if (result) {
        isCancelled.value = true;
        CustomToast.show(
          message: "Order was successfully cancelled",
          type: ToastType.success,
        );
        Get.offAllNamed(Routes.DASHBOARD);
        return;
      }
      CustomToast.show(
        message: "Failed to cancel order",
        type: ToastType.error,
      );
      isCancelled.value = false;
    } catch (error) {
      if (error is CustomHttpException) {
        if (error.statusCode == 401) {
          await logout.doLogout();
          return;
        }
        CustomToast.show(
          message: error.message,
          type: ToastType.error,
        );
      } else {
        CustomToast.show(
          message: "Internal server error has occured",
          type: ToastType.error,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void backToDashboard() {
    if (isCancelled.value) {
      Get.back(closeOverlays: true);
      return;
    }
    Get.back(closeOverlays: true);
  }
}

class OrderDetails {
  final String orderId;
  final String date;
  final String location;
  final String? mechanicId;
  final String? mechanicName;
  final String? mechanicImageUrl;
  final OrderStatus status;
  final String updateDescription;
  final List<Map<String, String>> items;
  final List<Map<String, String>> fees;
  final String grandTotal;
  final bool isRated;
  final bool isCancelled;
  final String? paymentUrl;
  final String? orderSecret;

  OrderDetails(
      {required this.orderId,
      required this.date,
      required this.location,
      required this.mechanicId,
      required this.mechanicName,
      required this.mechanicImageUrl,
      required this.status,
      required this.updateDescription,
      required this.items,
      required this.fees,
      required this.grandTotal,
      required this.isRated,
      required this.isCancelled,
      required this.paymentUrl,
      required this.orderSecret});
}
