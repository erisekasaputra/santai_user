// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/domain/usecases/catalog/get_all_brand.dart';
import 'package:santai/app/domain/usecases/catalog/get_all_category.dart';
import 'package:santai/app/domain/usecases/catalog/get_all_item.dart';

import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/services/secure_storage_service.dart';

class ServiceNowController extends GetxController {
  final SecureStorageService _secureStorage = SecureStorageService();
  final urlImgPublic = ''.obs;

  final fleetId = ''.obs;

  final isLoading = false.obs;
  final isLoadingCategories = true.obs;
  final isLoadingBrands = true.obs;
  final isLoadingItems = true.obs;

  final selectedCategoryId = ''.obs;
  final selectedPartTagId = ''.obs;
  final selectedParts = <Map<String, dynamic>>{}.obs;

  // New RxList to store categories
  final categories = <Map<String, dynamic>>[].obs;
  final brands = <Map<String, dynamic>>[].obs;
  final items = <Map<String, dynamic>>[].obs;

  final ItemGetAll getAllItem;
  final BrandGetAll getAllBrand;
  final CategoryGetAll getAllCategory;

  ServiceNowController({
    required this.getAllItem,
    required this.getAllBrand,
    required this.getAllCategory,
  });

  @override
  void onInit() async {
    super.onInit();
    if (Get.arguments != null && Get.arguments['fleetId'] != null) {
      fleetId.value = Get.arguments['fleetId'];
    }

    print('fleetId: $fleetId');

    urlImgPublic.value =
        await _secureStorage.readSecureData('commonGetImgUrlPublic') ?? '';

    await fetchCategories();
    await fetchBrands();
    await fetchItems(
        selectedCategoryId.value == '' ? null : selectedCategoryId.value,
        selectedPartTagId.value == '' ? null : selectedPartTagId.value);
  }

  Future<void> fetchCategories() async {
    try {
      isLoadingCategories.value = true;
      final categoryResponse = await getAllCategory();
      categories.value = categoryResponse.data.items
          .map((category) => {
                'id': category.id,
                'name': category.name,
                'icon': urlImgPublic + (category.imageUrl),
              })
          .toList();

      selectedCategoryId.value = categories.first['id'];
    } catch (error) {
      if (error is CustomHttpException) {
        CustomToast.show(
          message: error.message,
          type: ToastType.error,
        );
      } else {
        CustomToast.show(
          message: "An unexpected error occurred",
          type: ToastType.error,
        );
      }
    } finally {
      isLoadingCategories.value = false;

      update();
    }
  }

  Future<void> fetchBrands() async {
    try {
      isLoadingBrands.value = true;
      final brandResponse = await getAllBrand();
      brands.value = brandResponse.data.items
          .map((brand) => {
                'id': brand.id,
                'name': brand.name,
                'icon': urlImgPublic + (brand.imageUrl),
              })
          .toList();

      selectedPartTagId.value = brands.first['id'];
    } catch (error) {
      if (error is CustomHttpException) {
        CustomToast.show(
          message: error.message,
          type: ToastType.error,
        );
      } else {
        CustomToast.show(
          message: "An unexpected error occurred",
          type: ToastType.error,
        );
      }
    } finally {
      isLoadingBrands.value = false;
      update();
    }
  }

  // Future<void> fetchItems(String? categoryId, String? brandId) async {
  //   try {
  //     isLoadingItems.value = true;
  //     final itemResponse = await getAllItem(categoryId, brandId, 1, 10);
  //     items.value = itemResponse.data.items
  //         .map((item) => {
  //               'id': item.id,
  //               'name': item.name,
  //               'description': item.description,
  //               'price': item.price,
  //               'rating': 0.0,
  //               'imageUrl': urlImgPublic + (item.imageUrl),
  //               'categoryId': item.categoryId,
  //               'brandId': item.brandId,
  //             })
  //         .toList();
  //   } catch (error) {
  //     if (error is CustomHttpException) {
  //       CustomToast.show(
  //         message: error.message,
  //         type: ToastType.error,
  //       );
  //     } else {
  //       CustomToast.show(
  //         message: "An unexpected error occurred",
  //         type: ToastType.error,
  //       );
  //     }
  //   } finally {
  //     isLoadingItems.value = false;
  //     update();
  //   }
  // }

  Future<void> fetchItems(String? categoryId, String? brandId) async {
    try {
      isLoadingItems.value = true;
      final itemResponse = await getAllItem(categoryId, brandId, 1, 10);
      items.value = itemResponse.data.items.map((item) {
        final mappedItem = {
          'id': item.id,
          'name': item.name,
          'description': item.description,
          'price': item.price,
          'rating': 0.0,
          'imageUrl': urlImgPublic + (item.imageUrl),
          'categoryId': item.categoryId,
          'brandId': item.brandId,
        };

        // Check if the item is already in selectedParts
        if (selectedParts
            .any((selectedItem) => selectedItem['id'] == item.id)) {
          // Remove the old item and add the updated one
          selectedParts
              .removeWhere((selectedItem) => selectedItem['id'] == item.id);
          selectedParts.add(mappedItem);
        }

        return mappedItem;
      }).toList();
    } catch (error) {
      if (error is CustomHttpException) {
        CustomToast.show(
          message: error.message,
          type: ToastType.error,
        );
      } else {
        CustomToast.show(
          message: "An unexpected error occurred",
          type: ToastType.error,
        );
      }
    } finally {
      isLoadingItems.value = false;
      update();
    }
  }

  void setSelectedCategory(String categoryId) {
    selectedCategoryId.value = categoryId;
    update();
    fetchItems(categoryId,
        selectedPartTagId.value == '' ? null : selectedPartTagId.value);
  }

  void setSelectedPartTag(String tag) {
    selectedPartTagId.value = tag;
    update();
    fetchItems(
        selectedCategoryId.value == '' ? null : selectedCategoryId.value, tag);
  }

  // void togglePartSelection(Map<String, dynamic> part) {
  //   if (selectedParts.contains(part)) {
  //     selectedParts.remove(part);
  //   } else {
  //     selectedParts.add(part);
  //   }
  //   update();
  // }

  void togglePartSelection(Map<String, dynamic> part) {
    if (selectedParts.any((item) => item['id'] == part['id'])) {
      selectedParts.removeWhere((item) => item['id'] == part['id']);
    } else {
      selectedParts.add(part);
    }
    update();
  }

  Future<void> checkoutSelectedParts() async {
    isLoading.value = true;

    try {
      List<Map<String, dynamic>> selectedItems = selectedParts
          .map((part) => {
                'id': part['id'],
                'name': part['name'],
                'price': part['price'],
              })
          .toList();

      Get.toNamed(Routes.CHECKOUT, arguments: {
        'fleetId': fleetId.value,
        'selectedItems': selectedItems,
      });
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }
}
