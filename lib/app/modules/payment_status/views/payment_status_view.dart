import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:santai/app/theme/app_theme.dart';

import '../controllers/payment_status_controller.dart';

class PaymentStatusView extends GetView<PaymentStatusController> {
  const PaymentStatusView({super.key});
  @override
  Widget build(BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                controller.status.value == '1'
                    ? "Payment Success!"
                    : "Payment Failed!",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              if (controller.status.value == '1') ...[
                Image.asset(
                  'assets/images/success.png',
                  height: 200,
                  width: 200,
                ),
              ] else ...[
                const CircleAvatar(
                  backgroundColor: Colors.red, // Warna bulatan
                  radius: 80, // Ukuran radius lingkaran
                  child: Icon(
                    Icons.close, // Ikon "Close"
                    color: Colors.white, // Warna ikon
                    size: 120, // Ukuran ikon
                  ),
                ),
              ],
              const SizedBox(height: 20),
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
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Saira',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    children: [
                      const TextSpan(
                          text:
                              'You will be directed to the home screen automatically or click'),
                      TextSpan(
                        text: ' Here',
                        style: const TextStyle(
                          fontFamily: 'Saira',
                          fontWeight: FontWeight.w600,
                          color: Colors.blue, // Warna biru
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            controller.redirectToHome();
                          },
                      ),
                      const TextSpan(
                        text: ' to return to home screen.',
                        style: TextStyle(
                          fontFamily: 'Saira',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              if (controller.status.value == '1')
                ElevatedButton.icon(
                  onPressed: controller.showQRCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary_300,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 20.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: Image(
                      width: 30,
                      height: 30,
                      image: Image.asset(
                        'assets/icons/qris.png',
                      ).image),
                  label: const Text(
                    'Show your QR Code orders',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
