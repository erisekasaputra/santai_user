import 'package:santai/app/domain/entities/catalog/catalog_category_res.dart';
import 'package:santai/app/domain/repository/catalog/catalog_pository.dart';


class CategoryGetAll {
  final CatalogRepository repository;

  CategoryGetAll(this.repository);

  Future<CatalogCategoryResponse> call() async {
    return await repository.getAllCatalogCategory();
  }
}