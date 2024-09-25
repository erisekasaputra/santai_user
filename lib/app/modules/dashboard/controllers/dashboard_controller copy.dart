// import 'package:get/get.dart';
// import 'package:santai/app/routes/app_pages.dart';
// import 'package:santai/app/services/location_service.dart';

// class DashboardController extends GetxController {
//   final userName = 'Pang Li';
//   final LocationService locationService = Get.find<LocationService>();

//   String get address => locationService.address.value;
//   bool get isLoading => locationService.isLoading.value;


//   final List<ServiceProgress> serviceProgresses = [
//   ServiceProgress(
//     id: 1,
//     steps: ['Order Receive', 'Pick-Up Parts', 'Servicing', 'Complete'],
//     currentStep: 0,
//     motorcycles: [
//       Motorcycle(plateNumber: 'VBB 6123', brand: 'SYM', model: 'VF3i 185', nextService: '01/12/2024'),
//       Motorcycle(plateNumber: 'AMF 4220', brand: 'YAMAHA', model: 'Y15ZR', nextService: '15/01/2025'),
//     ],
//     selectedMotorcycleIndex: 0,
//   ),
//   ServiceProgress(
//     id: 2,
//     steps: ['Order Receive', 'Diagnosis', 'Repairing', 'Testing', 'Complete'],
//     currentStep: 1,
//     motorcycles: [
//       Motorcycle(plateNumber: 'WXC 1234', brand: 'HONDA', model: 'RS150R', nextService: '30/11/2024'),
//       Motorcycle(plateNumber: 'JKL 5678', brand: 'KAWASAKI', model: 'Ninja 250', nextService: '22/02/2025'),
//       Motorcycle(plateNumber: 'MNO 9012', brand: 'SUZUKI', model: 'GSX-R150', nextService: '10/03/2025'),
//     ],
//     selectedMotorcycleIndex: 1,
//   ),
//   ServiceProgress(
//     id: 3,
//     steps: ['Order Receive', 'Waiting for Parts', 'Servicing', 'Quality Check', 'Complete'],
//     currentStep: 0,
//     motorcycles: [
//       Motorcycle(plateNumber: 'PQR 3456', brand: 'YAMAHA', model: 'R15', nextService: '05/04/2025'),
//       Motorcycle(plateNumber: 'STU 7890', brand: 'HONDA', model: 'CBR150R', nextService: '18/05/2025'),
//     ],
//     selectedMotorcycleIndex: 0,
//   ),
// ];

// final currentServiceIndex = 0.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     // getCurrentLocation();
//   }
// void selectMotorcycle(int serviceIndex, int motorcycleIndex) {
//   if (serviceProgresses[serviceIndex].currentStep == 0) { // Only allow selection during "Order" step
//     serviceProgresses[serviceIndex] = ServiceProgress(
//       id: serviceProgresses[serviceIndex].id,
//       steps: serviceProgresses[serviceIndex].steps,
//       currentStep: serviceProgresses[serviceIndex].currentStep,
//       motorcycles: serviceProgresses[serviceIndex].motorcycles,
//       selectedMotorcycleIndex: motorcycleIndex,
//     );
//     update(); // Notify listeners of the change
//   }
// }

//  void navigateToPage(int index) {
//     switch (index) {
//       case 0:
//         Get.toNamed(Routes.MOTORCYCLE_DETAIL);
//         break;
//       case 1:
//         Get.toNamed(Routes.HISTORY);
//         break;
//       case 2:
//         Get.toNamed(Routes.CHAT_MENU);
//         break;
//       case 3:
//         Get.toNamed(Routes.SETTINGS);
//         break;
//     }
//   }

// }

// class Motorcycle {
//   final String plateNumber;
//   final String brand;
//   final String model;
//   final String nextService;

//   Motorcycle({
//     required this.plateNumber,
//     required this.brand,
//     required this.model,
//     required this.nextService,
//   });
// }

// class ServiceProgress {
//   final int id;
//   final List<String> steps;
//   final int currentStep;
//   final List<Motorcycle> motorcycles;
//   final int selectedMotorcycleIndex;

//   ServiceProgress({
//     required this.id,
//     required this.steps,
//     required this.currentStep,
//     required this.motorcycles,
//     required this.selectedMotorcycleIndex,
//   });
// }

