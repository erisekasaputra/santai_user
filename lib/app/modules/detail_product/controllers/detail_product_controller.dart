import 'package:get/get.dart';

class Product {
  final String name;
  final String recommendation;
  final String description;
  final int sold;
  final int performanceRating;
  final int viscosityRating;
  final int priceRating;

  Product({
    required this.name,
    required this.recommendation,
    required this.description,
    required this.sold,
    required this.performanceRating,
    required this.viscosityRating,
    required this.priceRating,
  });
}

class DetailProductController extends GetxController {
  final productName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    productName.value = Get.arguments ?? 'Unknown Product';
   
   
    product = Product(
      name: productName.value,
      recommendation: 'Endurance',
      description: 'This product is engineered to react instantly to the different demands of all your bike\'s critical areas delivering instant defense and responsive performance.',
      sold: 53524,
      performanceRating: 10,
      viscosityRating: 10,
      priceRating: 10,
    );
  }

  late Product product;
}