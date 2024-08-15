import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_otp_controller.dart';

class RegisterOtpView extends GetView<RegisterOtpController> {
  const RegisterOtpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'We have sent an OTP code to your email',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'contact@santaitechnology.com',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Enter the OTP code below to verify',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Obx(() => Text(
              controller.otp.value,
              style: TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold),
            )),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Didn't receive email?",
                  style: TextStyle(fontSize: 14),
                ),
                Obx(() => Text(
                  controller.canResend.value
                      ? 'Resend code'
                      : 'You can resend code in ${controller.resendTimer.value}s',
                  style: TextStyle(color: controller.canResend.value ? Colors.blue : Colors.grey),
                )),
              ],
            ),
            const Spacer(),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                if (index == 9) return const SizedBox.shrink();
                if (index == 11) {
                  return IconButton(
                    icon: const Icon(Icons.backspace),
                    onPressed: controller.deleteLastDigit,
                  );
                }
                final number = (index == 10) ? 0 : index + 1;
                return ElevatedButton(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$number', style: const TextStyle(fontSize: 24)),
                      if (index != 10 && index < 9)
                        Text(
                          ['', 'ABC', 'DEF', 'GHI', 'JKL', 'MNO', 'PQRS', 'TUV', 'WXYZ'][index],
                          style: const TextStyle(fontSize: 10),
                        ),
                    ],
                  ),
                  onPressed: () => controller.addDigit(number.toString()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}