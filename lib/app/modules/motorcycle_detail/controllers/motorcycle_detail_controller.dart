import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/domain/entities/fleet/fleet_user.dart';
import 'package:santai/app/domain/usecases/fleet/list_fleet_user.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/services/secure_storage_service.dart';
class MotorcycleDetailController extends GetxController {
  final isLoading = false.obs;

  final UserListFleet listFleetUser;
  MotorcycleDetailController({
    required this.listFleetUser,
  });

  final SecureStorageService _secureStorage = SecureStorageService();
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
    await _secureStorage.readSecureData('commonGetImgUrlPublic').then((value) => urlImgPublic = value ?? '');
    await getListFleetUser();
  }


   Future<void> getListFleetUser() async {
    try {
      isLoading.value = true;
      final response = await listFleetUser();
      resultListFleetUser.assignAll(response.data.items);
      if (resultListFleetUser.isNotEmpty) {
        selectedMotorcycle.value = resultListFleetUser.first;
      }
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
      isLoading.value = false;
      update();
    }
  }

  void updateSelectedMotorcycle(FleetUser motorcycle) {
    selectedMotorcycle.value = motorcycle;
    update();
  }






  // final motorcycles = ['Yamaha LC135', 'SYM VF3i', 'Honda RSX150', 'Kawasaki Ninja 250', 'Suzuki GSX-R150'];
  // final selectedMotorcycle = 'SYM VF3i'.obs;

  // final motorcycleDetails = {
  //   'Yamaha LC135': {
  //     'Model': 'Yamaha LC135',
  //     'Engine Capacity': '135cc',
  //     'Engine Number': '1YM-548*04125*',
  //     'Chassis Number': 'MH31YM32-005000105',
  //     'Insurer': 'Tokio Marine Insurance',
  //     'Insurance Expire': '15/08/2024',
  //     'Roadtax Expire': '15/08/2024',
  //     'Previous Service': '10/02/2023',
  //     'ODO Meter': '15,230 km',
  //   },
  //   'SYM VF3i': {
  //     'Model': 'SYM VF3i 185',
  //     'Engine Capacity': '185cc',
  //     'Engine Number': '4-548*04125*',
  //     'Chassis Number': 'MH35EF32-005000105',
  //     'Insurer': 'Etiqa Motor Insurance',
  //     'Insurance Expire': '25/06/2025',
  //     'Roadtax Expire': '25/06/2025',
  //     'Previous Service': '05/03/2023',
  //     'ODO Meter': '8,750 km',
  //   },
  //   'Honda RSX150': {
  //     'Model': 'Honda RSX150',
  //     'Engine Capacity': '150cc',
  //     'Engine Number': 'HDA-548*04125*',
  //     'Chassis Number': 'MH3HDA32-005000105',
  //     'Insurer': 'AIG Insurance',
  //     'Insurance Expire': '10/11/2024',
  //     'Roadtax Expire': '10/11/2024',
  //     'Previous Service': '20/05/2023',
  //     'ODO Meter': '12,500 km',
  //   },
  //   'Kawasaki Ninja 250': {
  //     'Model': 'Kawasaki Ninja 250',
  //     'Engine Capacity': '250cc',
  //     'Engine Number': 'KWS-548*04125*',
  //     'Chassis Number': 'MH3KWS32-005000105',
  //     'Insurer': 'Allianz Insurance',
  //     'Insurance Expire': '05/09/2024',
  //     'Roadtax Expire': '05/09/2024',
  //     'Previous Service': '15/04/2023',
  //     'ODO Meter': '6,800 km',
  //   },
  //   'Suzuki GSX-R150': {
  //     'Model': 'Suzuki GSX-R150',
  //     'Engine Capacity': '150cc',
  //     'Engine Number': 'SUZ-548*04125*',
  //     'Chassis Number': 'MH3SUZ32-005000105',
  //     'Insurer': 'Zurich Insurance',
  //     'Insurance Expire': '20/12/2024',
  //     'Roadtax Expire': '20/12/2024',
  //     'Previous Service': '30/06/2023',
  //     'ODO Meter': '9,300 km',
  //   },
  // };

  // final preferenceItems = [
  //   {'title': 'Mechanic', 'subtitle': 'Zara Zainuddin', 'icon': Icons.person},
  //   {'title': 'Lubricant', 'subtitle': 'Motul', 'icon': Icons.opacity},
  //   {'title': 'Brakes', 'subtitle': 'RCB', 'icon': Icons.motorcycle},
  // ];

  // Map<String, String> get currentMotorcycleDetails => motorcycleDetails[selectedMotorcycle.value] ?? {};

  // void updateSelectedMotorcycle(String motorcycle) {
  //   selectedMotorcycle.value = motorcycle;
  //   update();
  // }
}