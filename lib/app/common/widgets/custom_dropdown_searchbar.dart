import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/data/models/common/base_error.dart';
import 'package:santai/app/theme/app_theme.dart';

class CustomDropdownSearchbar extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final List<String> items;
  final String fieldName;
  final Rx<ErrorResponse?> error;

  const CustomDropdownSearchbar({
    super.key,
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.items,
    required this.fieldName,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;

    return Obx(
      () => Column(
        children: [
          GestureDetector(
            onTap: () async {
              final selectedValue = await showSearchDropdown(context);
              if (selectedValue != null) {
                controller.text = selectedValue;
              }
            },
            child: AbsorbPointer(
              child: TextField(
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Saira',
                ),
                controller: controller,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle:
                      const TextStyle(fontSize: 14, color: Color(0xFF818898)),
                  prefixIcon: Icon(icon, color: const Color(0xFF818898)),
                  suffixIcon:
                      const Icon(Icons.arrow_drop_down, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: borderColor, width: 2),
                  ),
                ),
              ),
            ),
          ),
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

  Future<String?> showSearchDropdown(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        String searchText = "";
        final filteredItems = items.obs;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: TextField(
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Saira',
            ),
            onChanged: (value) {
              searchText = value;
              filteredItems.value = items
                  .where((item) =>
                      item.toLowerCase().contains(searchText.toLowerCase()))
                  .toList();
            },
            decoration: InputDecoration(
              hintStyle: const TextStyle(
                fontSize: 14,
                fontFamily: 'Saira',
              ),
              hintText: "Search",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          content: Obx(
            () => SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return ListTile(
                    title: Text(item),
                    onTap: () {
                      Navigator.of(context).pop(item);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
