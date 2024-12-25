import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/services/signal_r_service.dart';
// import 'package:santai/app/routes/app_pages.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentController extends GetxController {
  late WebViewController webViewController;
  final paymentUrl = ''.obs;
  final orderSecret = ''.obs;
  final isInitialized = false.obs;

  @override
  void onInit() async {
    super.onInit();
    isInitialized.value = true;

    try {
      paymentUrl.value = Get.arguments?['paymentUrl'] ?? '';
      orderSecret.value = Get.arguments?['orderSecret'] ?? '';

      if (paymentUrl.value.isEmpty || orderSecret.value.isEmpty) {
        CustomToast.show(
            message: 'Uh-oh, Application has crashed.', type: ToastType.info);

        return;
      }

      webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {},
            onPageStarted: (String url) {
              // checkPaymentStatus(url);
            },
            onPageFinished: (String url) {},
            onHttpError: (HttpResponseError error) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://santaitechnology.com') ||
                  request.url.toLowerCase().contains('santaitechnology')) {
                Uri uri = Uri.parse(request.url);

                String? transactionId = uri.queryParameters['transactionId'];
                String? orderId = uri.queryParameters['orderId'];
                String? amount = uri.queryParameters['amount'];
                String? status = uri.queryParameters['status'];
                if (Get.isDialogOpen ?? false) {
                  Get.back(closeOverlays: true);
                }

                Get.offAllNamed(Routes.PAYMENT_STATUS, arguments: {
                  'status': status,
                  'orderId': orderId,
                  'amount': amount,
                  'transactionId': transactionId,
                  'orderSecret': orderSecret.value
                });

                return NavigationDecision.prevent;
              }

              return NavigationDecision.navigate;
            },
          ),
        );

      loadUrl(paymentUrl.value);
      isInitialized.value = false;
    } catch (_) {}
  }

  void loadUrl(String url) {
    webViewController.loadRequest(Uri.parse(url));
  }

  void checkPaymentStatus(String url) async {
    if (url.contains('payment/submit_payment_external') ||
        url.contains('submit_payment_external')) {
      showCustomPaymentView();
      return;
    }
  }

  void showCustomPaymentView() {
    Get.dialog(
      Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animasi Lottie
                Lottie.asset(
                  'assets/animations/loading_animation.json', // Pastikan file animasi Lottie di assets
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 24),

                // Text Keterangan
                const Text(
                  "Processing the payment",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Subteks
                const Text(
                  "Please hold on for a moment while we complete your payment process.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void shoLoadingCustomView() {
    Get.dialog(
      Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animasi Lottie
                Lottie.asset(
                  'assets/animations/loading_animation.json', // Pastikan file animasi Lottie di assets
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 24),

                // Text Keterangan
                const Text(
                  "Processing",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updatePaymentUrl(String newUrl) {
    paymentUrl.value = newUrl;
    loadUrl(newUrl);
  }
}
