import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/domain/usecases/catalog/get_all_brand.dart';
import 'package:santai/app/domain/usecases/catalog/get_all_category.dart';
import 'package:santai/app/domain/usecases/catalog/get_all_item.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/utils/logout_helper.dart';
import 'package:santai/app/utils/session_manager.dart';

class ServiceNowController extends GetxController {
  final Logout logout = Logout();
  int pageSize = 10;
  final SessionManager sessionManager = SessionManager();
  final urlImgPublic = ''.obs;

  final fleetId = ''.obs;
  final fleetModel = ''.obs;

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

  final pageNumber = 1.obs;
  final totalPages = 1.obs;

  ServiceNowController({
    required this.getAllItem,
    required this.getAllBrand,
    required this.getAllCategory,
  });

  Future<void> loadPage(int newPage) async {
    if (newPage > 0 && newPage <= totalPages.value) {
      // Panggil API atau lakukan logika pemuatan data baru
      await fetchItems(
          selectedCategoryId.value.isEmpty ? null : selectedCategoryId.value,
          selectedPartTagId.value.isEmpty ? null : selectedPartTagId.value,
          newPage);
    }
  }

  @override
  void onInit() async {
    super.onInit();

    urlImgPublic.value =
        await sessionManager.getSessionBy(SessionManagerType.commonFileUrl);
    if (Get.arguments != null && Get.arguments['fleetId'] != null) {
      fleetId.value = Get.arguments['fleetId'];
    }
    if (Get.arguments != null && Get.arguments['fleetModel'] != null) {
      fleetModel.value = Get.arguments['fleetModel'];
    }

    await fetchCategories();
    await fetchBrands();
    await fetchItems(
        selectedCategoryId.value.isEmpty ? null : selectedCategoryId.value,
        selectedPartTagId.value.isEmpty ? null : selectedPartTagId.value,
        pageNumber.value);
  }

  Future<void> fetchCategories() async {
    try {
      isLoadingCategories.value = true;
      final categoryResponse = await getAllCategory();
      if (categoryResponse.data.items.isEmpty) {
        return;
      }
      categories.value = categoryResponse.data.items
          .map((category) => {
                'id': category.id,
                'name': category.name,
                'icon': urlImgPublic.value + (category.imageUrl),
              })
          .toList();
    } catch (error) {
      if (error is CustomHttpException) {
        if (error.statusCode == 401) {
          await logout.doLogout();
          return;
        }

        if (error.errorResponse != null) {
          CustomToast.show(
            message: error.message,
            type: ToastType.error,
          );
          return;
        }

        CustomToast.show(message: error.message, type: ToastType.error);
        return;
      } else {
        CustomToast.show(
          message: "An unexpected error has occured",
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
      if (brandResponse.data.items.isEmpty) {
        return;
      }
      brands.value = brandResponse.data.items
          .map((brand) => {
                'id': brand.id,
                'name': brand.name,
                'icon': urlImgPublic.value + (brand.imageUrl),
              })
          .toList();
    } catch (error) {
      if (error is CustomHttpException) {
        if (error.statusCode == 401) {
          await logout.doLogout();
          return;
        }
        if (error.statusCode == 404) {
          return;
        }
        CustomToast.show(
          message: error.message,
          type: ToastType.error,
        );
      } else {
        CustomToast.show(
          message: "An unexpected error has occured",
          type: ToastType.error,
        );
      }
    } finally {
      isLoadingBrands.value = false;
      update();
    }
  }

  Future<void> fetchItems(
      String? categoryId, String? brandId, int currentPage) async {
    try {
      isLoadingItems.value = true;
      final itemResponse =
          await getAllItem(categoryId, brandId, currentPage, pageSize);
      if (itemResponse.data.items.isEmpty) {
        items.value = [];
        pageNumber.value = 1;
        totalPages.value = 1;
        return;
      }

      pageNumber.value = currentPage;
      totalPages.value = itemResponse.data.totalPages;

      items.value = itemResponse.data.items.map((item) {
        final mappedItem = {
          'id': item.id,
          'name': item.name,
          'description': item.description,
          'price': item.price,
          'rating': 5,
          'imageUrl': urlImgPublic.value + (item.imageUrl),
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
        if (error.statusCode == 401) {
          await logout.doLogout();
          return;
        }
        if (error.statusCode == 404) {
          return;
        }
        CustomToast.show(
          message: error.message,
          type: ToastType.error,
        );
      } else {
        CustomToast.show(
          message: "An unexpected error has occured",
          type: ToastType.error,
        );
      }
    } finally {
      isLoadingItems.value = false;
      update();
    }
  }

  void setSelectedCategory(String categoryId) {
    if (selectedCategoryId.value == categoryId) {
      selectedCategoryId.value = '';
      fetchItems(null,
          selectedPartTagId.value.isEmpty ? null : selectedPartTagId.value, 1);
      return;
    }

    selectedCategoryId.value = categoryId;
    fetchItems(categoryId.isEmpty ? null : categoryId,
        selectedPartTagId.value.isEmpty ? null : selectedPartTagId.value, 1);
  }

  void setSelectedPartTag(String tag) {
    if (selectedPartTagId.value == tag) {
      selectedPartTagId.value = '';
      fetchItems(
          selectedCategoryId.value.isEmpty ? null : selectedCategoryId.value,
          null,
          1);
      return;
    }

    selectedPartTagId.value = tag;
    fetchItems(
        selectedCategoryId.value.isEmpty ? null : selectedCategoryId.value,
        tag,
        1);
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
        'fleetModel': fleetModel.value
      });
    } catch (error) {
      if (error is CustomHttpException) {
        if (error.statusCode == 401) {
          await logout.doLogout();
          return;
        }
        CustomToast.show(
          message: error.message,
          type: ToastType.error,
        );
      } else {
        CustomToast.show(
          message: "An unexpected error has occured",
          type: ToastType.error,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
