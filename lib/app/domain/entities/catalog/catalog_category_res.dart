class CatalogCategoryResponse {
  final bool isSuccess;
  final CatalogCategoryData data;
  final String message;
  final String responseStatus;
  final List<dynamic> errors;
  final List<dynamic> links;

  CatalogCategoryResponse({
    required this.isSuccess,
    required this.data,
    required this.message,
    required this.responseStatus,
    required this.errors,
    required this.links,
  });
}

class CatalogCategoryData {
  final int pageNumber;
  final int pageSize;
  final int pageCount;
  final int totalPages;
  final List<CatalogItem> items;

  CatalogCategoryData({
    required this.pageNumber,
    required this.pageSize,
    required this.pageCount,
    required this.totalPages,
    required this.items,
  });
}

class CatalogItem {
  final String id;
  final String name;
  final String imageUrl;

  CatalogItem({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}
