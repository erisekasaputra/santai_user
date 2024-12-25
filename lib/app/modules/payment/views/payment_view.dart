import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_back_button.dart';
import 'package:santai/app/modules/payment/controllers/payment_controller.dart';
import 'package:santai/app/routes/app_pages.dart';
// import 'package:santai/app/routes/app_pages.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

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
            onPressed: () => {Get.offAllNamed(Routes.DASHBOARD)},
          ),
        ),
        leadingWidth: 100,
        title: const Text(
          'Payment',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          Get.offAllNamed(Routes.DASHBOARD);
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() => controller.isInitialized.value
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : WebViewWidget(controller: controller.webViewController)),
          ),
        ),
      ),
    );
  }
}
