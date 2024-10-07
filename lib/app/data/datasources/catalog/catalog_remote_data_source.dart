import 'package:http/http.dart' as http;
import 'package:santai/app/config/api_config.dart';
import 'package:santai/app/data/models/catalog/catalog_brand_res_model.dart';
import 'package:santai/app/data/models/catalog/catalog_category_res_model.dart';
import 'package:santai/app/data/models/catalog/catalog_item_res_model.dart';
import 'package:santai/app/data/models/catalog/catalog_items_res_model.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/services/secure_storage_service.dart';

import 'dart:convert';


abstract class CatalogRemoteDataSource {
  Future<CatalogItemsResponseModel> getAllCatalogItem(String? categoryId, String? brandId, int pageNumber, int pageSize);
  Future<CatalogBrandResponseModel> getAllCatalogBrand();
  Future<CatalogCategoryResponseModel> getAllCatalogCategory();
  Future<CatalogItemResponseModel> getItem(String itemId);
}

class CatalogRemoteDataSourceImpl implements CatalogRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  CatalogRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = ApiConfigCatalog.baseUrl,
  });

  @override
  Future<CatalogItemsResponseModel> getAllCatalogItem(String? categoryId, String? brandId, int pageNumber, int pageSize) async {
    final SecureStorageService secureStorage = SecureStorageService();
    final accessToken = await secureStorage.readSecureData('access_token');

    final response = await client.get(
      Uri.parse('$baseUrl/catalog/items?${categoryId != null ? 'CategoryId=$categoryId' : ''}${brandId != null ? '${categoryId == null ? '?' : '&'}BrandId=$brandId' : ''}&PageNumber=$pageNumber&PageSize=$pageSize'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return CatalogItemsResponseModel.fromJson(jsonDecode(response.body));
    } else {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw CustomHttpException(response.statusCode, responseBody['message'] ?? 'Failed to Login');
    }
  }

  @override
  Future<CatalogBrandResponseModel> getAllCatalogBrand() async {
    final SecureStorageService secureStorage = SecureStorageService();
    final accessToken = await secureStorage.readSecureData('access_token');

    final response = await client.get(
      Uri.parse('$baseUrl/catalog/brands?PageNumber=1&PageSize=20'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return CatalogBrandResponseModel.fromJson(jsonDecode(response.body));
    } else {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw CustomHttpException(response.statusCode, responseBody['message'] ?? 'Failed to Login');
    }
  }

  @override
  Future<CatalogCategoryResponseModel> getAllCatalogCategory() async {
    final SecureStorageService secureStorage = SecureStorageService();
    final accessToken = await secureStorage.readSecureData('access_token');

    final response = await client.get(
      Uri.parse('$baseUrl/catalog/categories?PageNumber=1&PageSize=20'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return CatalogCategoryResponseModel.fromJson(jsonDecode(response.body));
    } else {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw CustomHttpException(response.statusCode, responseBody['message'] ?? 'Failed to Login');
    }
  }

  @override
  Future<CatalogItemResponseModel> getItem(String itemId) async {
    final SecureStorageService secureStorage = SecureStorageService();
    final accessToken = await secureStorage.readSecureData('access_token');

    final response = await client.get(
      Uri.parse('$baseUrl/catalog/items/$itemId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return CatalogItemResponseModel.fromJson(jsonDecode(response.body));
    } else {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      throw CustomHttpException(response.statusCode, responseBody['message'] ?? 'Failed to Login');
    }
  }
}