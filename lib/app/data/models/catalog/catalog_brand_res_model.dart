import 'package:santai/app/domain/entities/catalog/catalog_brand_res.dart';

class CatalogBrandResponseModel extends CatalogBrandResponse {
  CatalogBrandResponseModel({
    required bool isSuccess,
    required CatalogBrandDataModel data,
    required String message,
    required String responseStatus,
    required List<dynamic> errors,
    required List<dynamic> links,
  }) : super(
          isSuccess: isSuccess,
          data: data,
          message: message,
          responseStatus: responseStatus,
          errors: errors,
          links: links,
        );

  factory CatalogBrandResponseModel.fromJson(Map<String, dynamic> json) {
    return CatalogBrandResponseModel(
      isSuccess: json['isSuccess'],
      data: CatalogBrandDataModel.fromJson(json['data']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
    );
  }
}

class CatalogBrandDataModel extends CatalogBrandData {
  CatalogBrandDataModel({
    required int pageNumber,
    required int pageSize,
    required int pageCount,
    required int totalPages,
    required List<CatalogBrandItemModel> items,
  }) : super(
          pageNumber: pageNumber,
          pageSize: pageSize,
          pageCount: pageCount,
          totalPages: totalPages,
          items: items,
        );

  factory CatalogBrandDataModel.fromJson(Map<String, dynamic> json) {
    return CatalogBrandDataModel(
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      pageCount: json['pageCount'],
      totalPages: json['totalPages'],
      items: List<CatalogBrandItemModel>.from(json['items'].map((item) => CatalogBrandItemModel.fromJson(item))),
    );
  }
}

class CatalogBrandItemModel extends CatalogBrandItem {
  CatalogBrandItemModel({
    required String id,
    required String name,
    required String imageUrl,
  }) : super(
          id: id,
          name: name,
          imageUrl: imageUrl,
        );

  factory CatalogBrandItemModel.fromJson(Map<String, dynamic> json) {
    return CatalogBrandItemModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }
}