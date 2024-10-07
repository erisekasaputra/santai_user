
import 'package:santai/app/data/models/catalog/catalog_item_res_model.dart';
import 'package:santai/app/domain/entities/catalog/catalog_items_res.dart';

class CatalogItemsResponseModel extends CatalogItemsResponse {
  CatalogItemsResponseModel({
    required bool isSuccess,
    required CatalogItemsDataModel data,
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

  factory CatalogItemsResponseModel.fromJson(Map<String, dynamic> json) {
    return CatalogItemsResponseModel(
      isSuccess: json['isSuccess'],
      data: CatalogItemsDataModel.fromJson(json['data']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
    );
  }
}

class CatalogItemsDataModel extends CatalogItemData {
  CatalogItemsDataModel({
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

  factory CatalogItemsDataModel.fromJson(Map<String, dynamic> json) {
    return CatalogItemsDataModel(
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      pageCount: json['pageCount'],
      totalPages: json['totalPages'],
      items: List<CatalogItemModel>.from(json['items'].map((item) => CatalogItemModel.fromJson(item))),
    );
  }
}
