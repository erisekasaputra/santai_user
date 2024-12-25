import 'package:santai/app/domain/entities/catalog/catalog_item_res.dart';
import 'package:santai/app/domain/repository/catalog/catalog_pository.dart';


class ItemGet {
  final CatalogRepository repository;

  ItemGet(this.repository);

  Future<CatalogItemResponse> call(String itemId) async {
    try {
      return await repository.getItem(itemId);
    } catch (e) {
      rethrow;
    }
  }
}