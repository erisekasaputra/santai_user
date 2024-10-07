import 'dart:ui';
import 'package:get/get.dart';
// import 'package:santai/app/routes/app_pages.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentController extends GetxController {
  late WebViewController webViewController;
  final paymentUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();

    paymentUrl.value = Get.arguments['paymentUrl'];


    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
           
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    loadUrl(paymentUrl.value);

    Future.delayed(const Duration(seconds: 5), () {
      // goToHomeScreen();

      //  Get.offAllNamed(Routes.DASHBOARD);
    });
  }

  void loadUrl(String url) {
    webViewController.loadRequest(Uri.parse(url));
  }

  void showQRCode() {
    Get.snackbar('QR Code', 'Displaying QR Code for orders');
  }

  void updatePaymentUrl(String newUrl) {
    paymentUrl.value = newUrl;
    loadUrl(newUrl);
  }
}