import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/theme/app_theme.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CustomBackButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Color effectiveBackgroundColor = Theme.of(context).colorScheme.primary_300;

    return GestureDetector(
      onTap: onPressed ?? () => Get.back(),
      child: Container(
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_back, color: Colors.white, size: 16, weight: 2),
            SizedBox(width: 4),
            Text(
              'Back',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}