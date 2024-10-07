import 'package:santai/app/domain/entities/catalog/catalog_item_res.dart';
import 'package:santai/app/domain/entities/catalog/catalog_items_res.dart';
import 'package:santai/app/domain/entities/catalog/catalog_brand_res.dart';
import 'package:santai/app/domain/entities/catalog/catalog_category_res.dart';

abstract class CatalogRepository {
  Future<CatalogItemsResponse> getAllCatalogItem(String? categoryId, String? brandId, int pageNumber, int pageSize);
  Future<CatalogBrandResponse> getAllCatalogBrand();
  Future<CatalogCategoryResponse> getAllCatalogCategory();
  Future<CatalogItemResponse> getItem(String itemId);
}
