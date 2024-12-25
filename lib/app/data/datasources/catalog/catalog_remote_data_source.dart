import 'package:santai/app/config/api_config.dart';
import 'package:santai/app/data/models/catalog/catalog_brand_res_model.dart';
import 'package:santai/app/data/models/catalog/catalog_category_res_model.dart';
import 'package:santai/app/data/models/catalog/catalog_item_res_model.dart';
import 'package:santai/app/data/models/catalog/catalog_items_res_model.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/services/auth_http_client.dart';

import 'dart:convert';

abstract class CatalogRemoteDataSource {
  Future<CatalogItemsResponseModel> getAllCatalogItem(
      String? categoryId, String? brandId, int pageNumber, int pageSize);
  Future<CatalogBrandResponseModel> getAllCatalogBrand();
  Future<CatalogCategoryResponseModel> getAllCatalogCategory();
  Future<CatalogItemResponseModel> getItem(String itemId);
}

class CatalogRemoteDataSourceImpl implements CatalogRemoteDataSource {
  final AuthHttpClient client;
  final String baseUrl;

  CatalogRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = ApiConfigCatalog.baseUrl,
  });

  @override
  Future<CatalogItemsResponseModel> getAllCatalogItem(
      String? categoryId, String? brandId, int pageNumber, int pageSize) async {
    final response = await client.get(
      Uri.parse(
          '$baseUrl/catalog/items?${categoryId != null ? 'CategoryId=$categoryId' : ''}${brandId != null ? '&BrandId=$brandId' : ''}&PageNumber=$pageNumber&PageSize=$pageSize'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return CatalogItemsResponseModel.fromJson(jsonDecode(response.body));
    }
    final Map<String, dynamic> responseBody = response.body.isNotEmpty
        ? json.decode(response.body)
        : {'message': 'Can not fetch catalog items'};
    throw CustomHttpException(response.statusCode,
        responseBody['message'] ?? 'Can not fetch catalog items');
  }

  @override
  Future<CatalogBrandResponseModel> getAllCatalogBrand() async {
    final response = await client.get(
      Uri.parse('$baseUrl/catalog/brands?PageNumber=1&PageSize=20'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return CatalogBrandResponseModel.fromJson(jsonDecode(response.body));
    }
    final Map<String, dynamic> responseBody = response.body.isNotEmpty
        ? json.decode(response.body)
        : {'message': 'Can not fetch Product Brands'};
    throw CustomHttpException(response.statusCode,
        responseBody['message'] ?? 'Can not fetch Product Brands');
  }

  @override
  Future<CatalogCategoryResponseModel> getAllCatalogCategory() async {
    final response = await client.get(
      Uri.parse('$baseUrl/catalog/categories?PageNumber=1&PageSize=50'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return CatalogCategoryResponseModel.fromJson(jsonDecode(response.body));
    }
    final Map<String, dynamic> responseBody = response.body.isNotEmpty
        ? json.decode(response.body)
        : {'message': 'Can not fetch Product Categories'};
    throw CustomHttpException(response.statusCode,
        responseBody['message'] ?? 'Can not fetch Product Categories');
  }

  @override
  Future<CatalogItemResponseModel> getItem(String itemId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/catalog/items/$itemId'),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return CatalogItemResponseModel.fromJson(jsonDecode(response.body));
    }
    final Map<String, dynamic> responseBody = response.body.isNotEmpty
        ? json.decode(response.body)
        : {'message': 'Can not fetch Product Item '};
    throw CustomHttpException(response.statusCode,
        responseBody['message'] ?? 'Can not fetch Product Item');
  }
}
