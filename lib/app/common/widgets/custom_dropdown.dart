import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/data/models/common/base_error.dart';
import 'package:santai/app/theme/app_theme.dart';

class CustomDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final Function(String?) onChanged;
  final String hintText;
  final IconData icon;
  final double? width;
  final Rx<ErrorResponse?> error; // Error handler
  final String fieldName;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hintText = 'Select an option',
    this.icon = Icons.arrow_drop_down,
    this.width,
    required this.error,
    required this.fieldName,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            isExpanded: true,
            borderRadius: BorderRadius.circular(20),
            dropdownColor: Colors.white,
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: borderColor, width: 2),
              ),
            ),
            value: value,
            hint: Text(hintText,
                style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            style: const TextStyle(color: Colors.black, fontSize: 16),
            icon: Icon(Icons.arrow_drop_down,
                color: Theme.of(context).colorScheme.primary),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: onChanged,
          ),
          // Error handling section
          if (error.value != null && error.value!.errors != null) ...[
            const SizedBox(height: 5),
            for (var error in error.value!.errors!) ...[
              if (error.propertyName
                  .toLowerCase()
                  .contains(fieldName.toLowerCase())) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 12,
                    ),
                    const SizedBox(width: 5), // Space between icon and text
                    Expanded(
                      child: Text(
                        error.errorMessage,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
              ]
            ]
          ],
          if (error.value != null && error.value!.validationErrors != null) ...[
            const SizedBox(height: 5),
            for (var entry in error.value!.validationErrors!.entries) ...[
              if (entry.key
                  .toLowerCase()
                  .contains(fieldName.toLowerCase())) ...[
                for (var errorMessage in entry.value) ...[
                  Row(
                    children: [
                      const Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 12,
                      ),
                      const SizedBox(width: 5), // Space between icon and text
                      Expanded(
                        child: Text(
                          errorMessage,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                ]
              ]
            ]
          ],
        ],
      ),
    );
  }
}
