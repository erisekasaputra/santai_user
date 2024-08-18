import 'package:get/get.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/services/location_service.dart';

class DashboardController extends GetxController {
  final userName = 'Pang Li';
  final LocationService locationService = Get.find<LocationService>();

  String get address => locationService.address.value;
  bool get isLoading => locationService.isLoading.value;

  // final List<Motorcycle> motorcycles = [
  //   Motorcycle(plateNumber: 'VBB 6123', brand: 'SYM', model: 'VF3i 185', nextService: '01/12/2024'),
  //   Motorcycle(plateNumber: 'AMF 4220', brand: 'YAMAHA', model: 'VF3i 185', nextService: '01/12/2024'),
  // ];

  final List<ServiceProgress> serviceProgresses = [
  ServiceProgress(
    id: 1,
    steps: ['Order Receive', 'Pick-Up Parts', 'Servicing', 'Complete'],
    currentStep: 0,
    motorcycles: [
      Motorcycle(plateNumber: 'VBB 6123', brand: 'SYM', model: 'VF3i 185', nextService: '01/12/2024'),
      Motorcycle(plateNumber: 'AMF 4220', brand: 'YAMAHA', model: 'Y15ZR', nextService: '15/01/2025'),
    ],
    selectedMotorcycleIndex: 0,
  ),
  ServiceProgress(
    id: 2,
    steps: ['Order Receive', 'Diagnosis', 'Repairing', 'Testing', 'Complete'],
    currentStep: 1,
    motorcycles: [
      Motorcycle(plateNumber: 'WXC 1234', brand: 'HONDA', model: 'RS150R', nextService: '30/11/2024'),
      Motorcycle(plateNumber: 'JKL 5678', brand: 'KAWASAKI', model: 'Ninja 250', nextService: '22/02/2025'),
      Motorcycle(plateNumber: 'MNO 9012', brand: 'SUZUKI', model: 'GSX-R150', nextService: '10/03/2025'),
    ],
    selectedMotorcycleIndex: 1,
  ),
  ServiceProgress(
    id: 3,
    steps: ['Order Receive', 'Waiting for Parts', 'Servicing', 'Quality Check', 'Complete'],
    currentStep: 0,
    motorcycles: [
      Motorcycle(plateNumber: 'PQR 3456', brand: 'YAMAHA', model: 'R15', nextService: '05/04/2025'),
      Motorcycle(plateNumber: 'STU 7890', brand: 'HONDA', model: 'CBR150R', nextService: '18/05/2025'),
    ],
    selectedMotorcycleIndex: 0,
  ),
];

final currentServiceIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // getCurrentLocation();
  }

  //  Future<void> getCurrentLocation() async {
  //     print("getCurrentLocation");
  //     isLoading.value = true;
  //     try {
  //       Map<String, dynamic> dataResponse = await determinePosition();
  //       if (!dataResponse["error"]) {
  //         Position position = dataResponse["position"];
  //         print("Position: ${position.latitude}, ${position.longitude}");
  //         try {
  //           List<Placemark> placemarks = await placemarkFromCoordinates(
  //             position.latitude,
  //             position.longitude,
  //           ).timeout(Duration(seconds: 20));
  //           print("Placemarks: $placemarks");
  //           if (placemarks.isNotEmpty) {
  //             String currentAddress = "${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].country}";
  //             address.value = currentAddress;
  //           } else {
  //             address.value = "Location found, but address details are unavailable";
  //           }
  //         } catch (e) {
  //           print("Error in placemarkFromCoordinates: $e");
  //           address.value = "Error getting address details";
  //         }
  //       } else {
  //         Get.snackbar("Terjadi Kesalahan", dataResponse["message"]);
  //       }
  //     } catch (e) {
  //       print("Error in getCurrentLocation: $e");
  //       Get.snackbar("Terjadi Kesalahan", "Gagal mendapatkan lokasi. Silakan coba lagi.");
  //       address.value = "Lokasi tidak tersedia";
  //     } finally {
  //       isLoading.value = false;
  //     }
  //   }

void selectMotorcycle(int serviceIndex, int motorcycleIndex) {
  if (serviceProgresses[serviceIndex].currentStep == 0) { // Only allow selection during "Order" step
    serviceProgresses[serviceIndex] = ServiceProgress(
      id: serviceProgresses[serviceIndex].id,
      steps: serviceProgresses[serviceIndex].steps,
      currentStep: serviceProgresses[serviceIndex].currentStep,
      motorcycles: serviceProgresses[serviceIndex].motorcycles,
      selectedMotorcycleIndex: motorcycleIndex,
    );
    update(); // Notify listeners of the change
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

  // Future<Map<String, dynamic>> determinePosition() async {
  //   try {
  //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //     if (!serviceEnabled) {
  //       return {"error": true, "message": "Layanan lokasi dinonaktifkan."};
  //     }

  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         return {"error": true, "message": "Izin lokasi ditolak."};
  //       }
  //     }

  //     if (permission == LocationPermission.deniedForever) {
  //       return {"error": true, "message": "Izin lokasi ditolak secara permanen."};
  //     }

  //     Position position = await Geolocator.getCurrentPosition(
  //       locationSettings: const LocationSettings(
  //         accuracy: LocationAccuracy.high,
  //         timeLimit: Duration(seconds: 15),
  //       ),
  //     );

  //     return {"error": false, "position": position};
  //   } catch (e) {
  //     print("Error in determinePosition: $e");
  //     return {"error": true, "message": "Gagal mendapatkan posisi: $e"};
  //   }
  // }










}

class Motorcycle {
  final String plateNumber;
  final String brand;
  final String model;
  final String nextService;

  Motorcycle({
    required this.plateNumber,
    required this.brand,
    required this.model,
    required this.nextService,
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

