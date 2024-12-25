import 'package:santai/app/domain/entities/catalog/catalog_items_res.dart';
import 'package:santai/app/domain/repository/catalog/catalog_pository.dart';


class ItemGetAll {
  final CatalogRepository repository;

  ItemGetAll(this.repository);

  Future<CatalogItemsResponse> call(String? categoryId, String? brandId, int pageNumber, int pageSize) async {
    try {
      return await repository.getAllCatalogItem(categoryId, brandId, pageNumber, pageSize);
    } catch (e) {
      rethrow;
    }
  }
}