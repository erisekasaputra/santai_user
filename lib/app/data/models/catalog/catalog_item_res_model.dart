
import 'package:santai/app/domain/entities/catalog/catalog_item_res.dart';

class CatalogItemResponseModel extends CatalogItemResponse {
  CatalogItemResponseModel({
    required bool isSuccess,
    required CatalogItemModel data,
    required String message,
    required String responseStatus,
    required List<dynamic> errors,
    required List<dynamic> links,
  }) : super(
          isSuccess: isSuccess,
          data: data,
          message: message,
          responseStatus: responseStatus,
          errors: errors,
          links: links,
        );

  factory CatalogItemResponseModel.fromJson(Map<String, dynamic> json) {
    return CatalogItemResponseModel(
      isSuccess: json['isSuccess'],
      data: CatalogItemModel.fromJson(json['data']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
    );
  }
}

class CatalogItemModel extends CatalogItem {
  CatalogItemModel({
    required String id,
    required String name,
    required String description,
    required String sku,
    required double price,
    required String currency,
    required String imageUrl,
    required DateTime createdAt,
    required int stockQuantity,
    required int soldQuantity,
    required String categoryId,
    required String categoryName,
    required String brandId,
    required String brandName,
    required bool isActive,
    required List<OwnerReviewModel> ownerReviews,
  }) : super(
          id: id,
          name: name,
          description: description,
          sku: sku,
          price: price,
          currency: currency,
          imageUrl: imageUrl,
          createdAt: createdAt,
          stockQuantity: stockQuantity,
          soldQuantity: soldQuantity,
          categoryId: categoryId,
          categoryName: categoryName,
          brandId: brandId,
          brandName: brandName,
          isActive: isActive,
          ownerReviews: ownerReviews,
        );

  factory CatalogItemModel.fromJson(Map<String, dynamic> json) {
    return CatalogItemModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      sku: json['sku'],
      price: json['price'],
      currency: json['currency'],
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      stockQuantity: json['stockQuantity'],
      soldQuantity: json['soldQuantity'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      brandId: json['brandId'],
      brandName: json['brandName'],
      isActive: json['isActive'],
      ownerReviews: List<OwnerReviewModel>.from(json['ownerReviews'].map((review) => OwnerReviewModel.fromJson(review))),
    );
  }
}

class OwnerReviewModel extends OwnerReview {
  OwnerReviewModel({
    required String title,
    required int rating,
  }) : super(
          title: title,
          rating: rating,
        );

  factory OwnerReviewModel.fromJson(Map<String, dynamic> json) {
    return OwnerReviewModel(
      title: json['title'],
      rating: json['rating'],
    );
  }
}