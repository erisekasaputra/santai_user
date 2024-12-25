import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedFloatingStars extends StatefulWidget {
  const AnimatedFloatingStars({super.key});

  @override
  AnimatedFloatingStarsState createState() => AnimatedFloatingStarsState();
}

class AnimatedFloatingStarsState extends State<AnimatedFloatingStars>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final random = Random();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: List.generate(10, (index) {
        // Menentukan posisi acak untuk setiap bintang
        final x = random.nextDouble() * screenWidth;
        final y = random.nextDouble() * screenHeight;

        return Positioned(
          left: x, // Posisi horizontal acak
          top: y, // Posisi vertikal acak
          child: const Opacity(
            opacity: 0.8,
            child: Icon(
              size: 40,
              Icons
                  .cloud_rounded, // Menggunakan ikon awan, bisa diganti dengan ikon lain
              color: Colors.white24,
            ),
          ),
        );
      }),
    );
  }
}
