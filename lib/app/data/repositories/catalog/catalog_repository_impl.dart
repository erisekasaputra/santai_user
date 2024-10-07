import 'package:santai/app/data/datasources/catalog/catalog_remote_data_source.dart';
import 'package:santai/app/data/models/catalog/catalog_brand_res_model.dart';
import 'package:santai/app/data/models/catalog/catalog_category_res_model.dart';
import 'package:santai/app/data/models/catalog/catalog_item_res_model.dart';
import 'package:santai/app/data/models/catalog/catalog_items_res_model.dart';
import 'package:santai/app/domain/repository/catalog/catalog_pository.dart';
// import 'package:santai/app/domain/entities/profile/profile_user_res.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogRemoteDataSource remoteDataSource;

  CatalogRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CatalogItemsResponseModel> getAllCatalogItem(String? categoryId, String? brandId, int pageNumber, int pageSize) async {
    final response = await remoteDataSource.getAllCatalogItem(categoryId, brandId, pageNumber, pageSize);
    return response;
  }

  @override
  Future<CatalogBrandResponseModel> getAllCatalogBrand() async {
    final response = await remoteDataSource.getAllCatalogBrand();
    return response;
  }

  @override
  Future<CatalogCategoryResponseModel> getAllCatalogCategory() async {
    final response = await remoteDataSource.getAllCatalogCategory();
    return response;
  }

  @override
  Future<CatalogItemResponseModel> getItem(String itemId) async {
    final response = await remoteDataSource.getItem(itemId);
    return response;
  }
}
