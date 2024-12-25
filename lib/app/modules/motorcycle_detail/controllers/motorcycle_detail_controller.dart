import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/domain/entities/fleet/fleet_user.dart';
import 'package:santai/app/domain/usecases/fleet/list_fleet_user.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/utils/logout_helper.dart';
import 'package:santai/app/utils/session_manager.dart';

class MotorcycleDetailController extends GetxController {
  final ScrollController scrollController = ScrollController();
  Map<String, GlobalKey> cardKeys = {};

  void scrollToMotorcycle(String id) {
    final key = cardKeys[id];
    if (key != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 300),
        alignment: 0.1,
      );
    }
  }

  final timeZone = ''.obs;
  final SessionManager sessionManager = SessionManager();
  final isInitLoading = false.obs;
  final Logout logout = Logout();
  final isLoading = false.obs;
  final userType = ''.obs;
  final UserListFleet listFleetUser;
  MotorcycleDetailController({
    required this.listFleetUser,
  });
  String urlImgPublic = '';

  final resultListFleetUser = <FleetUser>[].obs;
  final selectedMotorcycle = Rx<FleetUser?>(null);

  final preferenceItems = [
    {'title': 'Mechanic', 'subtitle': 'John Doe', 'icon': Icons.person},
    {'title': 'Lubricant', 'subtitle': 'Shell', 'icon': Icons.opacity},
    {'title': 'Brakes', 'subtitle': 'Brembo', 'icon': Icons.motorcycle},
  ].obs;

  @override
  void onInit() async {
    super.onInit();
    isInitLoading.value = true;
    urlImgPublic =
        await sessionManager.getSessionBy(SessionManagerType.commonFileUrl);
    await getListFleetUser();
    userType.value =
        await sessionManager.getSessionBy(SessionManagerType.userType);
    timeZone.value =
        await sessionManager.getSessionBy(SessionManagerType.timeZone);
    isInitLoading.value = false;
  }

  Future<void> getListFleetUser() async {
    try {
      isLoading.value = true;
      final response = await listFleetUser();
      resultListFleetUser.assignAll(response.data.items);

      for (var fleet in response.data.items) {
        cardKeys[fleet.id!] = GlobalKey();
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
          message: "An unexpected error occurred",
          type: ToastType.error,
        );
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void updateSelectedMotorcycle(FleetUser motorcycle) {
    if (selectedMotorcycle.value == motorcycle) {
      selectedMotorcycle.value = null;
      return;
    }
    selectedMotorcycle.value = motorcycle;
    update();
  }
}
