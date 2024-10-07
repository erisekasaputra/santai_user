import 'package:santai/app/domain/entities/catalog/catalog_item_res.dart';

class CatalogItemsResponse {
  final bool isSuccess;
  final CatalogItemData data;
  final String message;
  final String responseStatus;
  final List<dynamic> errors;
  final List<dynamic> links;

  CatalogItemsResponse({
    required this.isSuccess,
    required this.data,
    required this.message,
    required this.responseStatus,
    required this.errors,
    required this.links,
  });
}

class CatalogItemData {
  final int pageNumber;
  final int pageSize;
  final int pageCount;
  final int totalPages;
  final List<CatalogItem> items;

  CatalogItemData({
    required this.pageNumber,
    required this.pageSize,
    required this.pageCount,
    required this.totalPages,
    required this.items,
  });
}


