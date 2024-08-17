import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/routes/app_pages.dart';

class ServiceNowController extends GetxController {
  final selectedCategoryIndex = 0.obs;
  final selectedPartTag = ''.obs;
  final selectedParts = <Map<String, dynamic>>{}.obs;

void togglePartSelection(Map<String, dynamic> part) {
  if (selectedParts.contains(part)) {
    selectedParts.remove(part);
  } else {
    selectedParts.add(part);
  }
  update();
}

void checkoutSelectedParts() {
  print('Selected parts:');
  for (var part in selectedParts) {
    print('${part['name']} - ${part['price']}');
  }

  Get.toNamed(Routes.CHECKOUT);
}

  final List<Map<String, dynamic>> categories = [
    {'name': 'Repair', 'icon': Icons.build},
    {'name': 'Fuel', 'icon': Icons.local_gas_station},
    {'name': 'Tires', 'icon': Icons.disc_full},
    {'name': 'Settings', 'icon': Icons.settings},
    {'name': 'Accessories', 'icon': Icons.accessible_forward_outlined},
    {'name': 'Maintenance', 'icon': Icons.build_circle},
    {'name': 'Cleaning', 'icon': Icons.cleaning_services},
    {'name': 'Safety Gear', 'icon': Icons.safety_divider},
  ];

  final Map<String, Map<String, List<Map<String, dynamic>>>> partsByCategory = {
    'Repair': {
      'Brake System': [
        {'name': 'Brake Pads', 'description': 'High-performance brake pads', 'price': 120.00, 'rating': 4.8},
        {'name': 'Brake Discs', 'description': 'Durable brake discs', 'price': 200.00, 'rating': 4.7},
        {'name': 'Brake Fluid', 'description': 'High-quality brake fluid', 'price': 15.00, 'rating': 4.6},
        {'name': 'Brake Calipers', 'description': 'Performance brake calipers', 'price': 300.00, 'rating': 4.9},
        {'name': 'Brake Lines', 'description': 'Stainless steel brake lines', 'price': 50.00, 'rating': 4.5},
      ],
      'Engine': [
        {'name': 'Oil Filter', 'description': 'Premium oil filter', 'price': 25.00, 'rating': 4.5},
        {'name': 'Spark Plugs', 'description': 'Iridium spark plugs', 'price': 80.00, 'rating': 4.7},
        {'name': 'Air Filter', 'description': 'High-flow air filter', 'price': 30.00, 'rating': 4.6},
        {'name': 'Fuel Pump', 'description': 'High-performance fuel pump', 'price': 150.00, 'rating': 4.8},
        {'name': 'Timing Belt', 'description': 'Durable timing belt', 'price': 100.00, 'rating': 4.7},
      ],
    },
    'Fuel': {
      'Engine Oil': [
        {'name': 'Petronas F900', 'description': 'Full Synthetic 5W-50', 'price': 62.00, 'rating': 4.7},
        {'name': 'Shell Advance', 'description': 'Fully Synthetic 10W-40', 'price': 70.00, 'rating': 4.6},
        {'name': 'Castrol Edge', 'description': 'Full Synthetic 5W-30', 'price': 65.00, 'rating': 4.8},
        {'name': 'Mobil 1', 'description': 'Full Synthetic 0W-40', 'price': 75.00, 'rating': 4.9},
      ],
      'Additives': [
        {'name': 'Fuel Injector Cleaner', 'description': 'Cleans fuel system', 'price': 15.00, 'rating': 4.3},
        {'name': 'Octane Booster', 'description': 'Increases fuel efficiency', 'price': 20.00, 'rating': 4.2},
        {'name': 'Engine Cleaner', 'description': 'Cleans engine internals', 'price': 18.00, 'rating': 4.4},
        {'name': 'Fuel Stabilizer', 'description': 'Prevents fuel degradation', 'price': 12.00, 'rating': 4.5},
      ],
    },
    'Tires': {
      'Front Tires': [
        {'name': 'Michelin Pilot', 'description': '120/70-17 M/C', 'price': 220.00, 'rating': 4.9},
        {'name': 'Pirelli Diablo', 'description': '120/70-17 M/C', 'price': 210.00, 'rating': 4.8},
        {'name': 'Bridgestone Battlax', 'description': '120/70-17 M/C', 'price': 230.00, 'rating': 4.6},
        {'name': 'Dunlop Sportmax', 'description': '120/70-17 M/C', 'price': 215.00, 'rating': 4.7},
      ],
      'Rear Tires': [
        {'name': 'Michelin Power', 'description': '180/55-17 M/C', 'price': 250.00, 'rating': 4.9},
        {'name': 'Dunlop SportMax', 'description': '190/50-17 M/C', 'price': 240.00, 'rating': 4.7},
        {'name': 'Pirelli Angel', 'description': '180/55-17 M/C', 'price': 245.00, 'rating': 4.8},
        {'name': 'Bridgestone Battlax', 'description': '190/50-17 M/C', 'price': 255.00, 'rating': 4.6},
      ],
    },
    'Settings': {
      'Lighting': [
        {'name': 'LED Headlight', 'description': 'Bright LED headlight kit', 'price': 150.00, 'rating': 4.6},
        {'name': 'Tail Light', 'description': 'LED tail light upgrade', 'price': 80.00, 'rating': 4.5},
        {'name': 'Turn Signal Lights', 'description': 'LED turn signal lights', 'price': 40.00, 'rating': 4.4},
        {'name': 'Fog Lights', 'description': 'High-intensity fog lights', 'price': 120.00, 'rating': 4.7},
      ],
      'Performance': [
        {'name': 'Performance ECU', 'description': 'Tunable ECU upgrade', 'price': 350.00, 'rating': 4.7},
        {'name': 'Quick Shifter', 'description': 'Smooth gear changes', 'price': 200.00, 'rating': 4.5},
        {'name': 'Exhaust System', 'description': 'High-performance exhaust', 'price': 500.00, 'rating': 4.8},
        {'name': 'Air Intake', 'description': 'High-flow air intake', 'price': 300.00, 'rating': 4.6},
      ],
    },
  };

  List<String> get partTags {
  final categoryName = categories[selectedCategoryIndex.value]['name'] as String;
  final tags = partsByCategory[categoryName]?.keys.toList() ?? [];
  if (tags.isNotEmpty && selectedPartTag.value.isEmpty) {
    selectedPartTag.value = tags.first;
  }
  return tags;
}

  List<Map<String, dynamic>> get currentParts {
    final categoryName = categories[selectedCategoryIndex.value]['name'] as String;
    final categoryParts = partsByCategory[categoryName];
    if (categoryParts == null) return [];
    
    if (selectedPartTag.value.isEmpty && categoryParts.isNotEmpty) {
      selectedPartTag.value = categoryParts.keys.first;
    }
    
    return categoryParts[selectedPartTag.value] ?? [];
  }

  void setSelectedCategory(int index) {
    selectedCategoryIndex.value = index;
    selectedPartTag.value = '';
    update();
  }

  void setSelectedPartTag(String tag) {
    selectedPartTag.value = tag;
    update();
  }
}