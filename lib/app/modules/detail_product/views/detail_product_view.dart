import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/detail_product_controller.dart';

class DetailProductView extends GetView<DetailProductController> {
  const DetailProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Product Detail',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(Icons.image, size: 120, color: Colors.grey[400]),
                ),
              ),
              const SizedBox(height: 32),
             Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.product.name,
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${controller.product.sold} Sold',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Recommended for ${controller.product.recommendation}',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              Divider(
                thickness: 2,
                color: Colors.grey[200],
              ),
              const SizedBox(height: 10),
              const Text(
                'Description',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 5),
              Text(
                controller.product.description,
                style: TextStyle(fontSize: 16, color: Colors.grey[800], height: 1.5),
              ),
              const SizedBox(height: 32),
              const Text(
                'Santai Review',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 5),
              _buildRatingRow('Performance', controller.product.performanceRating),
              _buildRatingRow('Viscosity', controller.product.viscosityRating),
              _buildRatingRow('Price', controller.product.priceRating),
            ],
          ),
        ),
      ),
    );
  }

    Widget _buildRatingRow(String label, int rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700]),
            ),
          ),
          Expanded(
            child: Wrap(
              spacing: 2,
              runSpacing: 2,
              children: List.generate(
                10,
                (index) => Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  size: 20,
                  color: index < rating ? const Color(0xFFFFD700) : Colors.grey[300],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}