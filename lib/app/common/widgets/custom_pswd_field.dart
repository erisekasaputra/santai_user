import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final RxBool isPasswordHidden;

  const CustomPasswordField({
    Key? key,
    required this.controller,
    required this.isPasswordHidden,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => TextField(
      controller: controller,
      obscureText: isPasswordHidden.value,
      decoration: InputDecoration(
        hintText: 'Password',
        prefixIcon: const Icon(Icons.lock, color: Colors.black),
        suffixIcon: IconButton(
          icon: Icon(isPasswordHidden.value ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            isPasswordHidden.value = !isPasswordHidden.value;
          },
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
      ),
    ));
  }
}