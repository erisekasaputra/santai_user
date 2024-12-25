import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/data/models/common/base_error.dart';
import 'package:santai/app/domain/entities/fleet/fleet_user.dart';
import 'package:santai/app/domain/usecases/fleet/get_fleet_user.dart';
import 'package:santai/app/domain/usecases/fleet/insert_fleet_user.dart';
import 'package:santai/app/domain/usecases/fleet/update_fleet_user.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/routes/app_pages.dart';

import 'package:santai/app/services/image_upload_service.dart';
import 'package:santai/app/utils/logout_helper.dart';
import 'package:santai/app/utils/session_manager.dart';

class RegMotorcycleController extends GetxController {
  List<String> motorBrands = [
    "Honda",
    "Yamaha",
    "Kawasaki",
    "Suzuki",
    "Modenas",
    "CFMOTO",
    "SYM",
    "BMW Motorrad",
    "Ducati",
    "Triumph",
    "Harley-Davidson",
    "KTM",
    "Benelli",
    "Aprilia",
    "Vespa",
    "Peugeot Motorcycles",
    "Zontes",
    "Hero MotoCorp",
    "Royal Enfield",
    "Loncin",
    "TVS",
    "KYMCO",
    "Rieju",
    "Bajaj",
    "Piaggio",
    "Zongshen"
  ];

  Map<String, List<String>> motorList = {
    "Honda": [
      "BeAT",
      "ADV160",
      "X-ADV",
      "Dash 125",
      "ADV350",
      "Forza",
      "Vario 125",
      "Vario 160",
      "NSS250",
      "CBR250RR",
      "CB250R",
      "CBR150R",
      "CB650R",
      "CBR500R",
      "CB750",
      "CB350RS",
      "Rebel 500",
      "CRF250",
      "CBR650R",
      "GL1800 Gold Wing",
      "Goldwing Tour",
      "RS-X",
      "Wave125i",
      "RS150R",
      "Wave Alpha",
      "XL750 Transalp",
      "NX500",
      "CRF1100L Africa Twin Adventure Sports ES"
    ],
    "Yamaha": [
      "NVX",
      "NMAX",
      "Y15ZR",
      "Y16ZR",
      "YZF-R25",
      "MT-25",
      "YZF-R3",
      "MT-03",
      "XSR700",
      "XSR900",
      "WR250R",
      "WR155R",
      "Y125Z",
      "Y125ZR",
      "Y15ZR",
      "Y16ZR"
    ],
    "Kawasaki": [
      "J125",
      "J300",
      "Ninja ZX-6R",
      "Ninja ZX-10R",
      "Ninja 400",
      "Z900",
      "Vulcan S",
      "Vulcan 900",
      "KLX250",
      "KLX150",
      "Z125",
      "Ninja 250"
    ],
    "Suzuki": [
      "Burgman 200",
      "Burgman 400",
      "GSX-R1000",
      "GSX-R750",
      "GSX-S750",
      "GSX-S1000",
      "Intruder 150",
      "Intruder 1800",
      "V-Strom 650",
      "V-Strom 1000",
      "Raider R150",
      "Satria F150"
    ],
    "Modenas": [
      "Elegan 250",
      "Kriss 110",
      "Pulsar RS200",
      "Pulsar NS200",
      "Dominar 400",
      "V15"
    ],
    "CFMOTO": ["300SR", "300NK", "650NK", "650MT", "700CL-X", "800MT", "150NK"],
    "SYM": ["VF3i 185", "Jet14 200", "Wolf 125", "Wolf 150", "Maxsym 400i"],
    "BMW Motorrad": [
      "S1000RR",
      "S1000R",
      "G310R",
      "R18",
      "R1250GS",
      "F850GS",
      "K1600GTL",
      "F900R",
      "R1250R",
      "S1000XR",
      "CE 04"
    ],
    "Ducati": [
      "Panigale V4",
      "Panigale V2",
      "Supersport 950",
      "Diavel 1260",
      "Monster 1200",
      "Streetfighter V4",
      "Multistrada V4",
      "DesertX",
      "Scrambler Icon",
      "Scrambler Desert Sled"
    ],
    "Triumph": [
      "Daytona 765",
      "Street Triple 765",
      "Rocket 3",
      "Speedmaster",
      "Tiger 660",
      "Speed Triple 1200 RS",
      "Tiger 900",
      "Tiger 1200",
      "Scrambler 1200",
      "Street Scrambler",
      "Trophy SE"
    ],
    "Harley-Davidson": [
      "Iron 883",
      "Sportster S",
      "Street Bob 114",
      "Fat Boy 114",
      "Softail Slim",
      "Road King",
      "Electra Glide",
      "Road Glide",
      "Ultra Limited"
    ],
    "KTM": [
      "RC390",
      "RC8C",
      "1290 Super Adventure R",
      "890 Adventure",
      "390 Duke",
      "790 Duke",
      "1290 Super Duke R",
      "250 EXC-F",
      "500 EXC-F",
      "Duke 125",
      "Ninja 250"
    ],
    "Benelli": [
      "302R",
      "TNT600i",
      "502C",
      "TNT 300",
      "Leoncino 500",
      "TRK 502X",
      "TRK 251"
    ],
    "Aprilia": [
      "RSV4 1100 Factory",
      "RS660",
      "Tuareg 660",
      "Tuono 660",
      "SR50",
      "Tuono 125"
    ],
    "Vespa": ["Primavera 125", "GTS 300", "Sprint 150"],
    "Peugeot Motorcycles": ["Django 125", "Metropolis 400", "Speedfight 50"],
    "Zontes": ["310R", "310T", "310X", "350V"],
    "Hero MotoCorp": ["Dash 110", "HF Deluxe"],
    "Royal Enfield": [
      "Meteor 350",
      "Classic 350",
      "Interceptor 650",
      "Continental GT 650",
      "Himalayan",
      "Scram 411"
    ],
    "Loncin": ["CR3 300", "GP 200"],
    "TVS": ["Apache RTR 200", "Apache RR 310", "NTorq 125", "Jupiter", "XL100"],
    "KYMCO": ["Agility 125", "Dink 200", "Super 8 150", "Xciting 400i"],
    "Rieju": ["RS3 125", "Marathon 125", "Tango 125"],
    "Bajaj": ["Pulsar 200NS", "Pulsar RS200", "Dominar 400"],
    "Piaggio": ["Vespa 300 GTS", "Piaggio Liberty 150", "Piaggio MP3 500"],
    "Zongshen": ["RX3", "ZS150-58", "ZSR 200"]
  };

  final Logout logout = Logout();
  final SessionManager sessionManager = SessionManager();

  final isLoading = false.obs;
  final isUpdateMode = false.obs;
  final fleetId = RxString('');

  final registrationNumberController = TextEditingController();
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final yearOfManufactureController = TextEditingController();
  final chasisNumberController = TextEditingController();
  final engineNumberController = TextEditingController();
  final insuranceNumberController = TextEditingController();
  final isInsuranceValidController = true.obs;
  final lastInspectionDateLocalController = TextEditingController();
  final odometerReadingController = TextEditingController();
  final ownerNameController = TextEditingController();
  final ownerAddressController = TextEditingController();

  final vehicleTypeOptions = ['', 'Motorcycle'];
  final selectedVehicleType = ''.obs;

  final error = Rx<ErrorResponse?>(null);

  final gasOptions = [
    '',
    'Gasoline',
    'Diesel' 'Electric',
    'Hybrid',
    'CompressedNaturalGas',
    'LiquifiedPetroleumGas',
    'Biodiesel',
    'Hydrogen'
  ];
  final selectedGas = ''.obs;

  final usageStatusOptions = [
    '',
    'Private',
    'Commercial',
    'Taxi',
    'Rental',
    'PublicService',
    'Logistic'
  ];
  final selectedUsageStatus = ''.obs;

  final ownershipStatusOptions = [
    '',
    'FullyOwned',
    'Leased',
    'Underload',
    'CoOwned',
    'Gifted',
    'Rental'
  ];

  final selectedOwnershipStatus = ''.obs;

  final transmissionOptions = ['', 'Manual', 'Automatic'];
  final selectedTransmission = ''.obs;

  final selectedImage = Rx<File?>(null);
  final selectedImageUrl = RxString('');
  final ImagePicker _picker = ImagePicker();

  final resourceName = ''.obs;

  final UserInsertFleet insertFleetUser;
  final ImageUploadService _imageUploadService;
  final UserGetFleet getFleetUserById;
  final UserUpdateFleet updateFleetUser;
  RegMotorcycleController({
    required this.insertFleetUser,
    required ImageUploadService imageUploadService,
    required this.getFleetUserById,
    required this.updateFleetUser,
  }) : _imageUploadService = imageUploadService;

  @override
  void onInit() async {
    super.onInit();

    final args = Get.arguments;
    if (args != null &&
        args is Map<String, dynamic> &&
        args.containsKey('fleetId')) {
      fleetId.value = args['fleetId'];
      isUpdateMode.value = true;
      await loadExistingFleetData();
    }
  }

  Future<void> loadExistingFleetData() async {
    isLoading.value = true;
    try {
      final existingData = await getFleetUserById(fleetId.value);
      populateFields(existingData.data);
    } catch (error) {
      CustomToast.show(
        message: "Error loading existing data",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> populateFields(FleetUser existingData) async {
    String? urlImgPublic =
        await sessionManager.getSessionBy(SessionManagerType.commonFileUrl);

    registrationNumberController.text = existingData.registrationNumber ?? "";
    selectedVehicleType.value = existingData.vehicleType ?? "";
    brandController.text = existingData.brand;
    modelController.text = existingData.model;
    yearOfManufactureController.text =
        existingData.yearOfManufacture?.toString() ?? "";
    chasisNumberController.text = existingData.chassisNumber ?? "";
    engineNumberController.text = existingData.engineNumber ?? "";
    insuranceNumberController.text = existingData.insuranceNumber ?? "";

    // lastInspectionDateLocalController.text = existingData.lastInspectionDateLocal.toIso8601String();
    final DateTime? lastInspectionDateLocal =
        existingData.lastInspectionDateLocal == null
            ? null
            : DateTime.parse(
                existingData.lastInspectionDateLocal!.toIso8601String());

    lastInspectionDateLocalController.text = lastInspectionDateLocal == null
        ? ""
        : "${lastInspectionDateLocal.year}-${lastInspectionDateLocal.month.toString().padLeft(2, '0')}-${lastInspectionDateLocal.day.toString().padLeft(2, '0')}";

    odometerReadingController.text =
        existingData.odometerReading?.toString() ?? "";
    selectedGas.value = existingData.fuelType ?? "";
    ownerNameController.text = existingData.ownerName ?? "";
    ownerAddressController.text = existingData.ownerAddress ?? "";
    selectedUsageStatus.value = existingData.usageStatus ?? "";
    selectedOwnershipStatus.value = existingData.ownershipStatus ?? "";
    selectedTransmission.value = existingData.transmissionType ?? "";

    if (existingData.imageUrl.isNotEmpty) {
      String fullImageUrl = (urlImgPublic) + existingData.imageUrl;
      resourceName.value = existingData.imageUrl;
      selectedImageUrl.value = fullImageUrl;
      selectedImage.value = null;
    } else {
      selectedImageUrl.value = '';
      selectedImage.value = null;
    }
  }

  void handleImageSourceSelection(ImageSource source) {
    _pickImage(source);
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
      selectedImageUrl.value = '';

      isLoading.value = true;

      try {
        resourceName.value =
            await _imageUploadService.uploadImage(selectedImage.value!);
        CustomToast.show(
          message: "Image was successfully uploaded",
          type: ToastType.success,
        );
      } catch (e) {
        CustomToast.show(
          message: "Error uploading image: $e",
          type: ToastType.error,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> register() async {
    isLoading.value = true;

    try {
      final dataFleetUser = FleetUser(
        id: fleetId.string,
        registrationNumber: registrationNumberController.text.isEmpty
            ? null
            : registrationNumberController.text,
        brand: brandController.text,
        model: modelController.text,
        yearOfManufacture: yearOfManufactureController.text.isEmpty
            ? null
            : int.parse(yearOfManufactureController.text),
        chassisNumber: chasisNumberController.text.isEmpty
            ? null
            : chasisNumberController.text,
        engineNumber: engineNumberController.text.isEmpty
            ? null
            : engineNumberController.text,
        insuranceNumber: insuranceNumberController.text.isEmpty
            ? null
            : insuranceNumberController.text,
        isInsuranceValid: isInsuranceValidController.value,
        vehicleType: selectedVehicleType.value.isEmpty
            ? null
            : selectedVehicleType.value,
        lastInspectionDateLocal: lastInspectionDateLocalController.text.isEmpty
            ? null
            : DateTime.parse(lastInspectionDateLocalController.text),
        odometerReading: odometerReadingController.text.isEmpty
            ? null
            : int.parse(odometerReadingController.text),
        ownerName:
            ownerNameController.text.isEmpty ? null : ownerNameController.text,
        ownerAddress: ownerAddressController.text.isEmpty
            ? null
            : ownerAddressController.text,
        fuelType: selectedGas.value.isEmpty ? null : selectedGas.value,
        usageStatus: selectedUsageStatus.value.isEmpty
            ? null
            : selectedUsageStatus.value,
        ownershipStatus: selectedOwnershipStatus.value.isEmpty
            ? null
            : selectedOwnershipStatus.value,
        transmissionType: selectedTransmission.value.isEmpty
            ? null
            : selectedTransmission.value,
        imageUrl: resourceName.value,
      );

      if (isUpdateMode.value) {
        await updateFleetUser(dataFleetUser, fleetId.value);
        CustomToast.show(
          message: "Success",
          type: ToastType.success,
        );
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        await insertFleetUser(dataFleetUser);
        CustomToast.show(
          message: "Success",
          type: ToastType.success,
        );
        Get.offAllNamed(Routes.DASHBOARD);
      }
    } catch (e) {
      if (e is CustomHttpException) {
        error.value = e.errorResponse;

        if (e.statusCode == 401) {
          await logout.doLogout();
          return;
        }

        if (e.errorResponse != null) {
          CustomToast.show(
            message: e.message,
            type: ToastType.error,
          );
          return;
        }

        CustomToast.show(message: e.message, type: ToastType.error);
        return;
      } else {
        CustomToast.show(
          message: "An unexpected error occurred",
          type: ToastType.error,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // driverOwnerController.dispose();
    // licensePlateController.dispose();
    // makeController.dispose();
    // modelController.dispose();
    // yearController.dispose();
    // fuelTypeController.dispose();
    super.onClose();
  }
}
