import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_back_button.dart';
import 'package:santai/app/modules/payment/controllers/payment_controller.dart';
// import 'package:santai/app/routes/app_pages.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({Key? key}) : super(key: key);

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
            onPressed: () => Get.back(),
          ),
        ),
        leadingWidth: 100,
        title: const Text(
          'Payment',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: WebViewWidget(controller: controller.webViewController),
        )
        
        // Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       const Text(
        //         'Payment Successful!',
        //         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        //       ),
        //       const SizedBox(height: 20),
        //       Container(
        //         width: 100,
        //         height: 100,
        //         decoration: BoxDecoration(
        //           color: Colors.grey[300],
        //           borderRadius: BorderRadius.circular(20),
        //         ),
        //         child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
        //       ),
        //       const SizedBox(height: 20),
        //       const Text(
        //         'You will be redirected to the home screen automatically',
        //         textAlign: TextAlign.center,
        //       ),
        //       const SizedBox(height: 10),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           const Text('or click '),
        //           GestureDetector(
        //             onTap: () => Get.offAllNamed(Routes.DASHBOARD),
        //             child: const Text(
        //               'here',
        //               style: TextStyle(color: Colors.blue),
        //             ),
        //           ),
        //           const Text(' to return to home screen'),
        //         ],
        //       ),
        //       const SizedBox(height: 20),
        //       ElevatedButton.icon(
        //         onPressed: controller.showQRCode,
        //         icon: const Icon(Icons.qr_code),
        //         label: const Text('Show your QR Code orders'),
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: Colors.grey[300],
        //           foregroundColor: Colors.black,
        //         ),
        //       ),
        //       const SizedBox(height: 20),
        //       Expanded(
        //         child: WebViewWidget(controller: controller.webViewController),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}