import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double borderRadius;
  final double width;
  final double height;
  final Widget? child;

  const CustomElevatedButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.textColor = Colors.black,
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
    this.borderRadius = 20.0,
    this.width = double.infinity,
    this.height = 50.0,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, height),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: child ?? Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}





// import 'package:flutter/material.dart';

// class CustomElevatedButton extends StatelessWidget {
//   final String text;
//   final VoidCallback? onPressed;
//   final Color backgroundColor;
//   final Color textColor;
//   final double fontSize;
//   final FontWeight fontWeight;
//   final double borderRadius;
//   final double width;
//   final double height;

//   const CustomElevatedButton({
//     Key? key,
//     required this.text,
//     this.onPressed,
//     this.backgroundColor = const Color(0xFFE0E0E0), 
//     this.textColor = Colors.black,
//     this.fontSize = 16,
//     this.fontWeight = FontWeight.bold,
//     this.borderRadius = 20.0,
//     this.width = double.infinity, 
//     this.height = 50.0,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         minimumSize: Size(width, height),
//         backgroundColor: backgroundColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(borderRadius),
//         ),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: textColor,
//           fontSize: fontSize,
//           fontWeight: fontWeight,
//         ),
//       ),
//     );
//   }
// }