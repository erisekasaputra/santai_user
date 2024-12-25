import 'package:santai/app/domain/entities/catalog/catalog_brand_res.dart';
import 'package:santai/app/domain/repository/catalog/catalog_pository.dart';


class BrandGetAll {
  final CatalogRepository repository;

  BrandGetAll(this.repository);

  Future<CatalogBrandResponse> call() async {
    try {
      return await repository.getAllCatalogBrand();
    } catch (e) {
      rethrow;
    }
  }
}