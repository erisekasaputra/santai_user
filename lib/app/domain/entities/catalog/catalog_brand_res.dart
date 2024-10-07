class CatalogBrandResponse {
  final bool isSuccess;
  final CatalogBrandData data;
  final String message;
  final String responseStatus;
  final List<dynamic> errors;
  final List<dynamic> links;

  CatalogBrandResponse({
    required this.isSuccess,
    required this.data,
    required this.message,
    required this.responseStatus,
    required this.errors,
    required this.links,
  });
}

class CatalogBrandData {
  final int pageNumber;
  final int pageSize;
  final int pageCount;
  final int totalPages;
  final List<CatalogBrandItem> items;

  CatalogBrandData({
    required this.pageNumber,
    required this.pageSize,
    required this.pageCount,
    required this.totalPages,
    required this.items,
  });
}

class CatalogBrandItem {
  final String id;
  final String name;
  final String imageUrl;

  CatalogBrandItem({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}
