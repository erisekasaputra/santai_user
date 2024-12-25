import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:santai/app/common/widgets/custom_back_button.dart';

import '../controllers/qr_order_controller.dart';

class QrOrderView extends GetView<QrOrderController> {
  const QrOrderView({super.key});
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: SafeArea(
    //     child: Center(
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.stretch,
    //         children: [
    //           const SizedBox(height: 20),
    //           Image.asset(
    //             'assets/images/company_logo.png',
    //             height: 120,
    //           ),
    //           const SizedBox(height: 20),
    //           Center(
    //             child: Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                   // Widget QR Code berada di tengah layar
    //                   QrImageView(
    //                     data: controller.orderSecret.value,
    //                     version: QrVersions.auto,
    //                     size: 300.0, // Ukuran QR Code sedang
    //                     gapless: true,
    //                   ),
    //                   const SizedBox(height: 20),
    //                   // Teks tambahan di bawah QR Code
    //                   const Text(
    //                     'Let your mechanic scan this QR',
    //                     style: TextStyle(
    //                         fontSize: 18, fontWeight: FontWeight.w500),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 0, 8),
          child: CustomBackButton(
            onPressed: () => {controller.backToDashboard()},
          ),
        ),
        leadingWidth: 100,
        title: const Text(
          'QR',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Pusatkan secara vertikal
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Pusatkan secara horizontal
              mainAxisSize: MainAxisSize.min, // Hanya mengambil ruang minimum
              children: [
                // QR ImageView tetap tidak diubah
                QrImageView(
                  data: controller.orderSecret.value,
                  gradient: const LinearGradient(colors: [
                    Color.fromARGB(255, 24, 16, 16),
                    Color.fromARGB(255, 24, 16, 16),
                  ]),
                  version: QrVersions.auto,
                  size: 300.0, // Ukuran QR Code sedang
                  gapless: true,
                  eyeStyle: const QrEyeStyle(
                    eyeShape:
                        QrEyeShape.square, // Membuat mata QR menjadi bulat
                    color: Colors.black,
                    borderRadius: 15, // Warna mata QR
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square, // Tetap kotak
                    color: Colors.blueAccent,
                    borderRadius: 15,
                  ),
                ),
                const SizedBox(height: 20),
                // Teks tambahan di bawah QR Code
                Container(
                  width: 320, // Lebar container sama dengan lebar QR Code
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 14.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Saira',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(text: 'Show the '),
                        TextSpan(
                          text: 'QRCode',
                          style: TextStyle(
                            fontFamily: 'Saira',
                            fontWeight: FontWeight.w600,
                            color: Colors.blue, // Warna biru
                          ),
                        ),
                        TextSpan(
                          text: ' to your technician to start the service.',
                          style: TextStyle(
                            fontFamily: 'Saira',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
