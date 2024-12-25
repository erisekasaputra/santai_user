import 'dart:async';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/controllers/permission_controller.dart';
import 'package:santai/app/domain/entities/fleet/fleet_user.dart';
import 'package:santai/app/domain/enumerations/user_types_enum.dart';
import 'package:santai/app/domain/usecases/common/common_get_banners.dart';
import 'package:santai/app/domain/usecases/common/common_get_img_url_public.dart';
import 'package:santai/app/domain/usecases/fleet/list_fleet_user.dart';
import 'package:santai/app/domain/usecases/order/get_active_orders.dart';
import 'package:santai/app/domain/usecases/profile/get_business_profile_user.dart';
import 'package:santai/app/domain/usecases/profile/get_profile_user.dart';
import 'package:santai/app/domain/usecases/profile/get_staff_profile_user.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/helpers/sqlite_db_helper.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/services/location_service.dart';
import 'package:santai/app/services/signal_r_service.dart';
import 'package:santai/app/utils/logout_helper.dart';
import 'package:santai/app/utils/session_manager.dart';

class DashboardController extends GetxController {
  final PermissionController _permissionController =
      Get.find<PermissionController>();
  final SessionManager sessionManager = SessionManager();
  final Logout logout = Logout();
  final SignalRService? chatService =
      Get.isRegistered<SignalRService>() ? Get.find<SignalRService>() : null;

  final userName = ''.obs;
  final LocationService locationService = Get.find<LocationService>();
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  final favoriteAddresses = <Map<String, dynamic>>[].obs;
  final recentAddresses = <Map<String, dynamic>>[].obs;
  final currentAddress = ''.obs;
  bool get isLocationLoading => locationService.isLoading.value;

  final isLoadingServiceProgress = false.obs;
  final isLoadingMotorCycle = false.obs;
  final isBannerLoading = false.obs;

  final listServiceProgress = RxList<ServiceProgress>([]);
  final motorcycles = RxList<Motorcycle>([]);
  final resultListFleetUser = <FleetUser>[].obs;
  final resultOrderActives = <ServiceProgress>[].obs;
  final currentServiceIndex = 0.obs;
  final selectedMotorcycleIndex = RxInt(-1);
  final listImagesCoupon = RxList<String>([]);
  final commonUrl = ''.obs;
  final profileImageUrl = ''.obs;

  final UserListFleet listFleetUser;
  final ListActiveOrders listActiveOrders;
  final UserGetProfile userGetProfile;
  final GetBusinessProfileUser getBusinessUser;
  final GetStaffProfileUser getStaffUser;
  final CommonGetImgUrlPublic commonGetImgUrlPublic;
  final CommonGetBanners commonGetBanners;

  DashboardController({
    required this.listFleetUser,
    required this.listActiveOrders,
    required this.userGetProfile,
    required this.getBusinessUser,
    required this.getStaffUser,
    required this.commonGetImgUrlPublic,
    required this.commonGetBanners,
  });

  @override
  void onInit() async {
    super.onInit();

    isLoadingMotorCycle.value = true;
    isLoadingServiceProgress.value = true;

    final response = await commonGetImgUrlPublic();

    await sessionManager.setSessionBy(
        SessionManagerType.commonFileUrl, response.data.url);
    commonUrl.value = response.data.url;
    await fetchBanners();
    await initializeAddresses();
    await fetchMotorcycles();
    await fetchServiceProgress();
    await loadAddresses();
    await loadUserProfile();
    selectedMotorcycleIndex.value = -1;
    currentServiceIndex.value = 0;
    await _permissionController.requestLocationPermission();

    if (chatService != null) {
      await chatService!.initializeConnection();
    }
  }

  Future<void> reload() async {
    isLoadingMotorCycle.value = true;
    isLoadingServiceProgress.value = true;
    await fetchBanners();
    await initializeAddresses();
    await fetchMotorcycles();
    await fetchServiceProgress();
    await loadAddresses();
    await loadUserProfile();
    selectedMotorcycleIndex.value = -1;
    currentServiceIndex.value = 0;
    update();
  }

  Future<void> fetchBanners() async {
    try {
      isBannerLoading.value = true;
      var bannerResponse = await commonGetBanners();

      if (bannerResponse.data.bannersUrl.isNotEmpty) {
        listImagesCoupon.clear();
        listImagesCoupon.value = bannerResponse.data.bannersUrl;
      }
    } catch (error) {
      if (error is CustomHttpException) {
        if (error.statusCode == 401) {
          await logout.doLogout();
          return;
        }
      } else {
        CustomToast.show(
          message: "An unexpected error occurred",
          type: ToastType.error,
        );
      }
    } finally {
      isBannerLoading.value = false;
    }
  }

  Future<void> loadUserProfile() async {
    var userType =
        await sessionManager.getSessionBy(SessionManagerType.userType);
    var userId = await sessionManager.getSessionBy(SessionManagerType.userId);

    if (userType == UserTypesEnum.regularUser) {
      final response = await userGetProfile(userId);

      if (response == null) {
        Get.offAllNamed(Routes.REG_USER_PROFILE);
        return;
      }

      if (!response.isSuccess) {
        return;
      }

      await sessionManager.registerSessionForProfile(
        userName:
            '${response.data.personalInfo.firstName} ${response.data.personalInfo.middleName ?? ''} ${response.data.personalInfo.lastName ?? ''}',
        timeZone: response.data.timeZoneId,
        phoneNumber: response.data.phoneNumber,
        imageProfile: response.data.personalInfo.profilePicture ?? '',
        referralCode: response.data.referral.referralCode,
      );
      userName.value = response.data.personalInfo.firstName;
      profileImageUrl.value = response.data.personalInfo.profilePicture ?? '';
      return;
    }

    if (userType == UserTypesEnum.businessUser) {
      var businessUser = await getBusinessUser(userId);
      if (businessUser == null) {
        await logout.doLogout();
        return;
      }

      await sessionManager.registerSessionForProfile(
        userName: businessUser.data.businessName,
        timeZone: businessUser.data.timeZoneId,
        phoneNumber: businessUser.data.phoneNumber ?? '',
        imageProfile: '',
        referralCode: businessUser.data.referral?.referralCode ?? '',
      );
      userName.value = businessUser.data.businessName;
      profileImageUrl.value = '';
      return;
    }

    if (userType == UserTypesEnum.staffUser) {
      var staffUser = await getStaffUser(userId);
      if (staffUser == null) {
        await logout.doLogout();
        return;
      }

      await sessionManager.registerSessionForProfile(
        userName: staffUser.data.name,
        timeZone: staffUser.data.timeZoneId,
        phoneNumber: staffUser.data.phoneNumber ?? '',
        imageProfile: '',
        referralCode: '',
      );

      userName.value = staffUser.data.name;
      profileImageUrl.value = '';
      return;
    }
  }

  Future<void> fetchMotorcycles() async {
    try {
      String urlImgPublic =
          await sessionManager.getSessionBy(SessionManagerType.commonFileUrl);

      final response = await listFleetUser();
      final fleetUsers = response.data.items;

      if (fleetUsers.isEmpty) {
        motorcycles.clear();
        motorcycles.refresh();
        return;
      }

      motorcycles.assignAll(fleetUsers
          .map((fleetUser) => Motorcycle(
                id: fleetUser.id ?? "",
                plateNumber: fleetUser.registrationNumber ?? "NA",
                brand: fleetUser.brand,
                model: fleetUser.model,
                nextService: fleetUser.lastInspectionDateLocal.toString(),
                image: fleetUser.imageUrl.isEmpty == true
                    ? ""
                    : "$urlImgPublic${fleetUser.imageUrl}",
              ))
          .toList());
    } catch (error) {
      if (error is CustomHttpException) {
        if (error.statusCode == 401) {
          await logout.doLogout();
          return;
        }
      } else {
        CustomToast.show(
          message: "An unexpected error occurred",
          type: ToastType.error,
        );
      }
    } finally {
      isLoadingMotorCycle.value = false;
    }
  }

  void showServiceDetail() {
    if (currentServiceIndex.value < 0 ||
        currentServiceIndex >= listServiceProgress.length) {
      return;
    }
    Get.toNamed(Routes.SERVICE_DETAIL, arguments: {
      'orderId': listServiceProgress[currentServiceIndex.value].id,
    });
  }

  Future<void> fetchServiceProgress() async {
    try {
      final progress = await listActiveOrders();
      List<ServiceProgress>? serviceProgressList = progress?.data
          .map((order) {
            return ServiceProgress(
                id: order.id, // Assuming order.id is convertible to int
                steps: order.statuses,
                currentStep: order.step,
                secret: order.secret);
          })
          .take(5) // ubah 0 untuk simulasi tidak ada data
          .toList();

      if (serviceProgressList != null && serviceProgressList.isNotEmpty) {
        listServiceProgress.clear();
        listServiceProgress.addAll(serviceProgressList);
        listServiceProgress.refresh();
        return;
      } else {
        listServiceProgress.clear();
        listServiceProgress.refresh();
      }
    } catch (error) {
      if (error is CustomHttpException) {
        if (error.statusCode == 401) {
          await logout.doLogout();
          return;
        }
        if (error.statusCode == 401) {
          return;
        }
      } else {
        CustomToast.show(
          message: "An unexpected error occurred",
          type: ToastType.error,
        );
      }
    } finally {
      isLoadingServiceProgress.value = false;
    }
  }

  void selectMotorcycle(int motorcycleIndex) {
    if (selectedMotorcycleIndex.value == motorcycleIndex) {
      selectedMotorcycleIndex.value = -1;
      return;
    }
    if (motorcycleIndex >= 0 && motorcycleIndex < motorcycles.length) {
      selectedMotorcycleIndex.value = motorcycleIndex;
      update();
    }
  }

  void showQR() {
    if (currentServiceIndex.value < 0 ||
        currentServiceIndex >= listServiceProgress.length) {
      return;
    }

    final orderData = listServiceProgress[currentServiceIndex.value];
    Get.toNamed(Routes.QR_ORDER,
        arguments: {'orderSecret': orderData.secret, 'paramAction': 'BACK'});
  }

  Future<void> initializeAddresses() async {
    final count = await dbHelper.countAddressesBySelection();
    RxDouble latitude = 0.0.obs;
    RxDouble longitude = 0.0.obs;

    if (count == 0) {
      var (double lat, double long, bool isSuccess, String? errorMessage) =
          await locationService.getCurrentLocation();
      if (!isSuccess) {
        CustomToast.show(
            message: errorMessage ?? 'Unknown error has occured',
            type: ToastType.error);
        return;
      }

      latitude.value = lat;
      longitude.value = long;

      final newAddress = {
        'name': 'New Location',
        'latitude': latitude.toDouble(),
        'longitude': longitude.toDouble(),
        'isFavorite': 0,
        'isSelected': 1,
      };

      await dbHelper.createAddress(newAddress);
    } else {
      final currentAddress = await dbHelper.getCurrentAddress();
      if (currentAddress == null ||
          currentAddress['latitude'] == null ||
          currentAddress['longitude'] == null) {
        CustomToast.show(
            message: 'Something bad has happend, please restart you app!',
            type: ToastType.error);
        return;
      }

      latitude.value = currentAddress['latitude'] as double;
      longitude.value = currentAddress['longitude'] as double;
    }

    var (data, isSuccess) = await locationService.translateCoordinatesToAddress(
        latitude.value, longitude.value);

    if (data != null && isSuccess) {
      currentAddress.value = data;
    }

    update();
  }

  Future<void> loadAddresses() async {
    try {
      favoriteAddresses.value = await dbHelper.getAddresses(isFavorite: true);
      List<Map<String, dynamic>> recentAddressesList =
          await dbHelper.getLastFiveNonFavoriteNonSelectedAddresses();

      recentAddresses.value =
          await Future.wait(recentAddressesList.map((address) async {
        var (translatedAddress, isError) =
            await locationService.translateCoordinatesToAddress(
          address['latitude'] as double,
          address['longitude'] as double,
        );
        return {...address, 'translatedAddress': translatedAddress ?? ''};
      }));
    } catch (e) {
      CustomToast.show(
        message: "Snap, an error occured during load the addresses",
        type: ToastType.error,
      );
    }
  }

  Future<void> getCurrentLocation() async {
    RxDouble latitude = 0.0.obs;
    RxDouble longitude = 0.0.obs;

    var (double lat, double long, bool isSuccess, String? errorMessage) =
        await locationService.getCurrentLocation();

    var (translatedAddress, isTranslationSuccess) =
        await locationService.translateCoordinatesToAddress(lat, long);

    if (!isSuccess) {
      return;
    }

    latitude.value = lat;
    longitude.value = long;

    if (currentAddress.value != translatedAddress) {
      await dbHelper.updateClearAddressSelected();
      final newAddress = {
        'name': 'New Location',
        'latitude': latitude.toDouble(),
        'longitude': longitude.toDouble(),
        'isFavorite': 0,
        'isSelected': 1,
      };

      await dbHelper.createAddress(newAddress);

      if (!isTranslationSuccess) {
        CustomToast.show(
            message: 'Failed to get current location', type: ToastType.error);
      }
      currentAddress.value = translatedAddress ?? '';
      await loadAddresses();
      update();
    }
  }

  void openMap() async {
    final result = await Get.toNamed(Routes.MAP_PICKER);
    if (result != null && result is Map<String, dynamic>) {
      if (result['addressUpdated'] == true) {
        await initializeAddresses();
      }
    }
  }

  void handleMenuSelection(int item, Map<String, dynamic> address) async {
    switch (item) {
      case 0:
        await deleteAddress(address);
        break;
      case 1:
        await toggleFavorite(address);
        break;
    }
  }

  Future<void> deleteAddress(Map<String, dynamic> address) async {
    try {
      int id = address['id'];
      await dbHelper.deleteAddress(id);
    } catch (e) {
      CustomToast.show(
        message: "Error deleting address: $e",
        type: ToastType.error,
      );
    }
  }

  Future<void> toggleFavorite(Map<String, dynamic> address) async {
    try {
      int id = address['id'];
      bool currentFavoriteStatus = address['isFavorite'] == 1;
      bool newFavoriteStatus = !currentFavoriteStatus;

      bool success = await dbHelper.setIsFavorite(id, newFavoriteStatus);
      if (!success) {
        throw Exception('Failed to update favorite status');
      }

      // Update local lists
      void updateList(RxList<Map<String, dynamic>> list) {
        int index = list.indexWhere((a) => a['id'] == id);
        if (index != -1) {
          list[index] = {
            ...list[index],
            'isFavorite': newFavoriteStatus ? 1 : 0
          };
        }
      }

      updateList(favoriteAddresses);
      updateList(recentAddresses);

      // Refresh the lists
      await loadAddresses();

      CustomToast.show(
        message: newFavoriteStatus
            ? "Address added to favorites"
            : "Address removed from favorites",
        type: ToastType.success,
      );
    } catch (e) {
      CustomToast.show(
        message: "Error updating favorite status",
        type: ToastType.error,
      );
    }
  }

  Future<void> addNewAddress(
      String name, double latitude, double longitude, int isFavorite) async {
    try {
      await dbHelper.createAddress({
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'isFavorite': 0,
        'isSelected': 1,
      });

      await loadAddresses();
    } catch (e) {
      CustomToast.show(
        message: "An error has occured: $e",
        type: ToastType.error,
      );
    }
  }

  void navigateToPage(int index) {
    switch (index) {
      case 0:
        Get.toNamed(Routes.MOTORCYCLE_DETAIL);
        break;
      case 1:
        Get.toNamed(Routes.HISTORY);
        break;
      case 2:
        Get.toNamed(Routes.CHAT_MENU);
        break;
      case 3:
        Get.toNamed(Routes.SETTINGS);
        break;
    }
  }
}

class Motorcycle {
  final String id;
  final String plateNumber;
  final String brand;
  final String model;
  final String nextService;
  final String image;

  Motorcycle({
    required this.id,
    required this.plateNumber,
    required this.brand,
    required this.model,
    required this.nextService,
    required this.image,
  });
}

class ServiceProgress {
  final String id;
  final List<String> steps;
  final int currentStep;
  final String secret;

  ServiceProgress(
      {required this.id,
      required this.steps,
      required this.currentStep,
      required this.secret});
}
