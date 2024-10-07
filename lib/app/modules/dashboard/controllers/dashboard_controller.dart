import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/domain/entities/fleet/fleet_user.dart';
import 'package:santai/app/domain/usecases/fleet/list_fleet_user.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/helpers/sqlite_db_helper.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/services/location_service.dart';
import 'package:santai/app/services/secure_storage_service.dart';

class DashboardController extends GetxController {
  final SecureStorageService _secureStorage = SecureStorageService();

  final userName = 'Pang Li';
  final LocationService locationService = Get.find<LocationService>();
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  final favoriteAddresses = <Map<String, dynamic>>[].obs;
  final recentAddresses = <Map<String, dynamic>>[].obs;

  final currentAddress = ''.obs;

  // String get address => locationService.address.value;
  bool get isLoading => locationService.isLoading.value;


  final listServiceProgress = RxList<ServiceProgress>([]);
  final resultListFleetUser = <FleetUser>[].obs;
  final currentServiceIndex = 0.obs;

  final UserListFleet listFleetUser;
  DashboardController({
    required this.listFleetUser,
  });

  @override
  void onInit() async {
    super.onInit();
    // await dbHelper.deleteDatabase();
    await initializeAddresses();


    await getListFleetUser();
    fetchServiceProgress();
  }

  // SERVICE PROGRESS
    Future<void> getListFleetUser() async {
      try {
        final response = await listFleetUser();
        resultListFleetUser.assignAll(response.data.items);
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
      }
    }

    Future<void> fetchServiceProgress() async {
      try {
        String? urlImgPublic =
            await _secureStorage.readSecureData('commonGetImgUrlPublic');

        final motorcycles = resultListFleetUser
            .map((fleetUser) => Motorcycle(
                  id: fleetUser.id ?? "",
                  plateNumber: fleetUser.registrationNumber,
                  brand: fleetUser.brand,
                  model: fleetUser.model,
                  nextService: fleetUser.lastInspectionDateLocal.toString(),
                  image: fleetUser.imageUrl?.isEmpty == true
                      ? ""
                      : urlImgPublic != null
                          ? urlImgPublic + (fleetUser.imageUrl ?? "")
                          : fleetUser.imageUrl ?? "",
                ))
            .toList();

        listServiceProgress.assignAll([
          ServiceProgress(
            id: 1,
            steps: ['Order Receive', 'Pick-Up Parts', 'Servicing', 'Complete'],
            currentStep: 0,
            motorcycles: motorcycles,
            selectedMotorcycleIndex: 0,
          ),
        ]);
      } catch (e) {
        print('Error fetching service progress: $e');
      }
    }

    void selectMotorcycle(int serviceIndex, int motorcycleIndex) {
      if (listServiceProgress[serviceIndex].currentStep == 0) {
        listServiceProgress[serviceIndex] = ServiceProgress(
          id: listServiceProgress[serviceIndex].id,
          steps: listServiceProgress[serviceIndex].steps,
          currentStep: listServiceProgress[serviceIndex].currentStep,
          motorcycles: listServiceProgress[serviceIndex].motorcycles,
          selectedMotorcycleIndex: motorcycleIndex,
        );
        update(); 
      }
    }
  // END SERVICE PROGRESS




  Future<void> initializeAddresses() async {
    // COUNT JUMLAH IS SELECTED ADDRESS
    final count = await dbHelper.countAddressesBySelection();
    RxDouble latitude = 0.0.obs;
    RxDouble longitude = 0.0.obs;

    if (count == 0) {

      final result = await locationService.getCurrentLocation();

      longitude.value = result['longitude'] as double;
      latitude.value = result['latitude'] as double;

      final newAddress = {
        'name': 'New Location',
        'latitude': latitude.toDouble(),
        'longitude': longitude.toDouble(),
        'isFavorite': 0,
        'isSelected': 1,
      };

      await dbHelper.createAddress(newAddress);

    } else {
      // GET CURRENT ADDRESS
      final currentAddress = await dbHelper.getCurrentAddress();
      latitude.value = currentAddress!['latitude'] as double;
      longitude.value = currentAddress['longitude'] as double;
    }

    currentAddress.value = await locationService.translateCoordinatesToAddress(latitude.value, longitude.value);
  }

  Future<void> loadAddresses() async {
    favoriteAddresses.value = await dbHelper.getAddresses(isFavorite: true);
    recentAddresses.value = await dbHelper.getAddresses(isFavorite: false);
  }

  Future<void> getCurrentLocation() async {
    await locationService.getCurrentLocation();
  }

  void openMap() async {
    final result = await Get.toNamed(Routes.MAP_PICKER);
    if (result != null && result is Map<String, dynamic>) {
      locationService.address.value = result['address'];
      final newAddress = {
        'name': 'New Location',
        'latitude': result['position'].latitude,
        'longitude': result['position'].longitude,
        'isFavorite': 0
      };
      await dbHelper.createAddress(newAddress);
      await loadAddresses();
    }
  }

  void handleMenuSelection(int item, Map<String, dynamic> address) {
    switch (item) {
      case 0:
        // Implement your delete logic here
        deleteAddress(address);
        break;
      case 1:
        // Implement your toggle favorite logic here
        toggleFavorite(address);
        break;
    }
  }

  void deleteAddress(Map<String, dynamic> address) {
    // Add logic to delete the address
    // This might involve removing it from the database and updating the list
    favoriteAddresses.removeWhere((a) => a['id'] == address['id']);
    recentAddresses.removeWhere((a) => a['id'] == address['id']);
    update(); // Update the UI after deletion
  }

  void toggleFavorite(Map<String, dynamic> address) {
    // Add logic to toggle the favorite status
    // This might involve updating the database and toggling the isFavorite property
    int index = favoriteAddresses.indexWhere((a) => a['id'] == address['id']);
    if (index != -1) {
      favoriteAddresses[index]['isFavorite'] =
          !(favoriteAddresses[index]['isFavorite'] as bool);
      update(); // Update the UI after toggling
    }
  }


  Future<void> addNewAddress(String name, double latitude, double longitude, int isFavorite) async {
    try {
      await dbHelper.createAddress({
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'isFavorite': 0,
        'isSelected': 1,
      });

      await loadAddresses();

      // if (result != -1) {
      //   CustomToast.show(
      //     message: "Alamat berhasil ditambahkan",
      //     type: ToastType.success,
      //   );
      //   // Refresh address list after adding
      //   await loadAddresses();
      // } else {
      //   CustomToast.show(
      //     message: "Gagal menambahkan alamat",
      //     type: ToastType.error,
      //   );
      // }
    } catch (e) {
      CustomToast.show(
        message: "Terjadi kesalahan: $e",
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
  final int id;
  final List<String> steps;
  final int currentStep;
  final List<Motorcycle> motorcycles;
  final int selectedMotorcycleIndex;

  ServiceProgress({
    required this.id,
    required this.steps,
    required this.currentStep,
    required this.motorcycles,
    required this.selectedMotorcycleIndex,
  });
}
