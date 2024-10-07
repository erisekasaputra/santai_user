import 'package:santai/app/domain/entities/catalog/catalog_category_res.dart';

class CatalogCategoryResponseModel extends CatalogCategoryResponse {
  CatalogCategoryResponseModel({
    required bool isSuccess,
    required CatalogCategoryDataModel data,
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

  factory CatalogCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return CatalogCategoryResponseModel(
      isSuccess: json['isSuccess'],
      data: CatalogCategoryDataModel.fromJson(json['data']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
    );
  }
}

class CatalogCategoryDataModel extends CatalogCategoryData {
  CatalogCategoryDataModel({
    required int pageNumber,
    required int pageSize,
    required int pageCount,
    required int totalPages,
    required List<CatalogItemModel> items,
  }) : super(
          pageNumber: pageNumber,
          pageSize: pageSize,
          pageCount: pageCount,
          totalPages: totalPages,
          items: items,
        );

  factory CatalogCategoryDataModel.fromJson(Map<String, dynamic> json) {
    return CatalogCategoryDataModel(
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      pageCount: json['pageCount'],
      totalPages: json['totalPages'],
      items: List<CatalogItemModel>.from(json['items'].map((item) => CatalogItemModel.fromJson(item))),
    );
  }
}

class CatalogItemModel extends CatalogItem {
  CatalogItemModel({
    required String id,
    required String name,
    required String imageUrl,
  }) : super(
          id: id,
          name: name,
          imageUrl: imageUrl,
        );

  factory CatalogItemModel.fromJson(Map<String, dynamic> json) {
    return CatalogItemModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }
}