class CatalogItemResponse {
  final bool isSuccess;
  final CatalogItem data;
  final String message;
  final String responseStatus;
  final List<dynamic> errors;
  final List<dynamic> links;

  CatalogItemResponse({
    required this.isSuccess,
    required this.data,
    required this.message,
    required this.responseStatus,
    required this.errors,
    required this.links,
  });
}

class CatalogItem {
  final String id;
  final String name;
  final String description;
  final String sku;
  final double price;
  final String currency;
  final String imageUrl;
  final DateTime createdAt;
  final int stockQuantity;
  final int soldQuantity;
  final String categoryId;
  final String categoryName;
  final String brandId;
  final String brandName;
  final bool isActive;
  final List<OwnerReview> ownerReviews;

  CatalogItem({
    required this.id,
    required this.name,
    required this.description,
    required this.sku,
    required this.price,
    required this.currency,
    required this.imageUrl,
    required this.createdAt,
    required this.stockQuantity,
    required this.soldQuantity,
    required this.categoryId,
    required this.categoryName,
    required this.brandId,
    required this.brandName,
    required this.isActive,
    required this.ownerReviews,
  });
}

class OwnerReview {
  final String title;
  final int rating;

  OwnerReview({
    required this.title,
    required this.rating,
  });
}
