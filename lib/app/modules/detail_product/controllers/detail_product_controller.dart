import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/domain/entities/catalog/catalog_item_res.dart';
import 'package:santai/app/domain/usecases/catalog/get_item.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/utils/logout_helper.dart';
import 'package:santai/app/utils/session_manager.dart';

class DetailProductController extends GetxController {
  final SessionManager sessionManager = SessionManager();
  final Logout logout = Logout();
  final isLoading = true.obs;
  final urlImgPublic = ''.obs;

  final items = Rx<CatalogItem?>(null);

  final ItemGet getItem;

  DetailProductController({
    required this.getItem,
  });

  @override
  void onInit() async {
    super.onInit();

    urlImgPublic.value =
        await sessionManager.getSessionBy(SessionManagerType.commonFileUrl);

    final itemId = Get.arguments?['itemId'] ?? '';
    await fetchItemDetails(itemId);
  }

  Future<void> fetchItemDetails(String itemId) async {
    try {
      isLoading.value = true;
      final CatalogItemResponse itemResponse = await getItem(itemId);
      if (itemResponse.isSuccess) {
        items.value = itemResponse.data;
      } else {
        CustomToast.show(
          message: "No item found",
          type: ToastType.warning,
        );
      }
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
          message: "Uh-oh, An unexpected error has occured",
          type: ToastType.error,
        );
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
