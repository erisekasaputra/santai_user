import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';

class CustomPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String, String) onChanged;

  const CustomPhoneField({
    Key? key,
    required this.controller,
    this.hintText = 'Phone Number',
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Colors.black, width: 2.0),
        ),
      ),
      initialCountryCode: 'ID',
      onChanged: (phone) {
        onChanged(phone.countryCode, phone.number);
      },
      pickerDialogStyle: PickerDialogStyle(
        backgroundColor: Colors.white,
      ),
    );
  }
}