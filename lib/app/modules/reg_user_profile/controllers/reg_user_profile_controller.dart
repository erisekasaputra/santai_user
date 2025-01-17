import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/data/models/common/base_error.dart';
import 'package:santai/app/domain/entities/profile/profile_user.dart';
import 'package:santai/app/domain/enumerations/user_types_enum.dart';
import 'package:santai/app/domain/usecases/authentikasi/signout.dart';
import 'package:santai/app/domain/usecases/profile/get_profile_user.dart';
import 'package:santai/app/domain/usecases/profile/insert_profile_user.dart';
import 'package:santai/app/domain/usecases/profile/update_profile_user.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/services/timezone_service.dart';
import 'package:santai/app/utils/logout_helper.dart';
import 'package:santai/app/utils/session_manager.dart';

class RegUserProfileController extends GetxController {
  final Logout logout = Logout();
  final SessionManager sessionManager = SessionManager();
  final TimezoneService timezoneService = TimezoneService();
  final isLoading = false.obs;
  final isUpdateMode = false.obs;

  final stateList = [
    "",
    "Johor",
    "Kedah",
    "Kelantan",
    "Melaka",
    "Negeri Sembilan",
    "Pahang",
    "Perak",
    "Perlis",
    "Pulau Pinang",
    "Sarawak",
    "Selangor",
    "Terengganu",
    "Kuala Lumpur",
    "Labuan",
    "Sabah",
    "Putrajaya",
    "Wilayah Persekutuan"
  ];

  final selectedStateCities = RxList<String>([""]);

  final stateCities = {
    "Johor": [
      "Johor Bahru",
      "Tebrau",
      "Pasir Gudang",
      "Bukit Indah",
      "Skudai",
      "Kluang",
      "Batu Pahat",
      "Muar",
      "Ulu Tiram",
      "Senai",
      "Segamat",
      "Kulai",
      "Kota Tinggi",
      "Pontian Kechil",
      "Tangkak",
      "Bukit Bakri",
      "Yong Peng",
      "Pekan Nenas",
      "Labis",
      "Mersing",
      "Simpang Renggam",
      "Parit Raja",
      "Kelapa Sawit",
      "Buloh Kasap",
      "Chaah"
    ],
    "Kedah": [
      "Sungai Petani",
      "Alor Setar",
      "Kulim",
      "Jitra / Kubang Pasu",
      "Baling",
      "Pendang",
      "Langkawi",
      "Yan",
      "Sik",
      "Kuala Nerang",
      "Pokok Sena",
      "Bandar Baharu"
    ],
    "Kelantan": [
      "Kota Bharu",
      "Pangkal Kalong",
      "Tanah Merah",
      "Peringat",
      "Wakaf Baru",
      "Kadok",
      "Pasir Mas",
      "Gua Musang",
      "Kuala Krai",
      "Tumpat"
    ],
    "Melaka": [
      "Bandaraya Melaka",
      "Bukit Baru",
      "Ayer Keroh",
      "Klebang",
      "Masjid Tanah",
      "Sungai Udang",
      "Batu Berendam",
      "Alor Gajah",
      "Bukit Rambai",
      "Ayer Molek",
      "Bemban",
      "Kuala Sungai Baru",
      "Pulau Sebang",
      "Jasin"
    ],
    "Negeri Sembilan": [
      "Seremban",
      "Port Dickson",
      "Nilai",
      "Bahau",
      "Tampin",
      "Kuala Pilah"
    ],
    "Pahang": [
      "Kuantan",
      "Temerloh",
      "Bentong",
      "Mentakab",
      "Raub",
      "Jerantut",
      "Pekan",
      "Kuala Lipis",
      "Bandar Jengka",
      "Bukit Tinggi"
    ],
    "Perak": [
      "Ipoh",
      "Taiping",
      "Sitiawan",
      "Simpang Empat",
      "Teluk Intan",
      "Batu Gajah",
      "Lumut",
      "Kampung Koh",
      "Kuala Kangsar",
      "Sungai Siput Utara",
      "Tapah",
      "Bidor",
      "Parit Buntar",
      "Ayer Tawar",
      "Bagan Serai",
      "Tanjung Malim",
      "Lawan Kuda Baharu",
      "Pantai Remis",
      "Kampar"
    ],
    "Perlis": ["Kangar", "Kuala Perlis"],
    "Pulau Pinang": [
      "Bukit Mertajam",
      "Georgetown",
      "Sungai Ara",
      "Gelugor",
      "Ayer Itam",
      "Butterworth",
      "Perai",
      "Nibong Tebal",
      "Permatang Kucing",
      "Tanjung Tokong",
      "Kepala Batas",
      "Tanjung Bungah",
      "Juru"
    ],
    "Sabah": [
      "Kota Kinabalu",
      "Sandakan",
      "Tawau",
      "Lahad Datu",
      "Keningau",
      "Putatan",
      "Donggongon",
      "Semporna",
      "Kudat",
      "Kunak",
      "Papar",
      "Ranau",
      "Beaufort",
      "Kinarut",
      "Kota Belud"
    ],
    "Sarawak": [
      "Kuching",
      "Miri",
      "Sibu",
      "Bintulu",
      "Limbang",
      "Sarikei",
      "Sri Aman",
      "Kapit",
      "Batu Delapan Bazaar",
      "Kota Samarahan"
    ],
    "Selangor": [
      "Subang Jaya",
      "Klang",
      "Ampang Jaya",
      "Shah Alam",
      "Petaling Jaya",
      "Cheras",
      "Kajang",
      "Selayang Baru",
      "Rawang",
      "Taman Greenwood",
      "Semenyih",
      "Banting",
      "Balakong",
      "Gombak Setia",
      "Kuala Selangor",
      "Serendah",
      "Bukit Beruntung",
      "Pengkalan Kundang",
      "Jenjarom",
      "Sungai Besar",
      "Batu Arang",
      "Tanjung Sepat",
      "Kuang",
      "Kuala Kubu Baharu",
      "Batang Berjuntai",
      "Bandar Baru Salak Tinggi",
      "Sekinchan",
      "Sabak",
      "Tanjung Karang",
      "Beranang",
      "Sungai Pelek",
      "Sepang",
    ],
    "Terengganu": [
      "Kuala Terengganu",
      "Chukai",
      "Dungun",
      "Kerteh",
      "Kuala Berang",
      "Marang",
      "Paka",
      "Jerteh"
    ],
    "Wilayah Persekutuan": ["Kuala Lumpur", "Labuan", "Putrajaya"]
  };

  final referenceCodeController = TextEditingController();
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final genderController = TextEditingController();

  final addressController = TextEditingController();

  final posCodeController = TextEditingController();
  final countryController = TextEditingController();
  final emailController = TextEditingController();

  final genderOptions = ['Male', 'Female'];
  final selectedGender = 'Male'.obs;

  final selectedState = ''.obs;
  final selectedCity = ''.obs;

  final UserInsertProfile insertProfileUser;
  final UserGetProfile getProfileUser;
  final UserUpdateProfile updateProfileUser;
  final SignOutUser signOutUser;

  final error = Rx<ErrorResponse?>(null);

  RegUserProfileController({
    required this.insertProfileUser,
    required this.getProfileUser,
    required this.updateProfileUser,
    required this.signOutUser,
  });

  @override
  void onInit() async {
    super.onInit();
    final Map<String, dynamic>? args = Get.arguments;

    isUpdateMode.value = args?['isUpdate'] ?? false;
    await loadUserData();
  }

  void changeSelectedCities(String state) {
    var cities = stateCities[state];
    selectedStateCities.removeWhere((item) => item.isNotEmpty);
    selectedCity.value = "";
    selectedCity.refresh();
    if (cities != null) {
      for (var city in cities) {
        selectedStateCities.add(city);
      }
    }
    selectedStateCities.refresh();
  }

  Future<void> loadUserData() async {
    if (isUpdateMode.value) {
      try {
        isLoading.value = true;
        final result = await getProfileUser(
            await sessionManager.getSessionBy(SessionManagerType.userId));
        if (result == null) {
          await logout.doLogout();
          return;
        }
        final userData = result.data;
        referenceCodeController.text = '';
        firstNameController.text = userData.personalInfo.firstName;
        middleNameController.text = userData.personalInfo.middleName ?? '';
        lastNameController.text = userData.personalInfo.lastName ?? '';

        final DateTime? dateOfBirth = userData.personalInfo.dateOfBirth == null
            ? null
            : DateTime.parse(userData.personalInfo.dateOfBirth!);

        dateOfBirthController.text = dateOfBirth == null
            ? ''
            : "${dateOfBirth.year}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}";
        selectedGender.value =
            (userData.personalInfo.gender.toLowerCase()[0].toUpperCase() +
                userData.personalInfo.gender.toLowerCase().substring(1));

        addressController.text = userData.address.addressLine1;

        if (stateCities.containsKey(userData.address.state)) {
          selectedState.value = userData.address.state;
          changeSelectedCities(userData.address.state);

          if (stateCities.containsKey(userData.address.state) &&
              stateCities[userData.address.state]!
                  .contains(userData.address.city)) {
            selectedCity.value = userData.address.city;
          }
        }

        posCodeController.text = userData.address.postalCode;
        countryController.text = userData.address.country;
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
            message: '$error',
            type: ToastType.error,
          );
        }
      } finally {
        isLoading.value = false;
      }
    } else {
      countryController.text = "Malaysia";
    }
  }

  Future<void> register() async {
    isLoading.value = true;
    var userType =
        await sessionManager.getSessionBy(SessionManagerType.userType);
    try {
      String timezone = await timezoneService.getDeviceTimezone();

      final profileUser = ProfileUser(
        email: emailController.text,
        timeZoneId: timezone,
        referralCode: referenceCodeController.text.trim().isEmpty
            ? null
            : referenceCodeController.text,
        address: ProfileAddress(
          addressLine1: addressController.text,
          city: selectedCity.value,
          state: selectedState.value,
          postalCode: posCodeController.text,
          country: countryController.text,
        ),
        personalInfo: ProfilePersonalInfo(
          firstName: firstNameController.text,
          middleName: middleNameController.text,
          lastName: lastNameController.text,
          dateOfBirth: dateOfBirthController.text.isEmpty
              ? null
              : dateOfBirthController.text,
          gender: selectedGender.value,
        ),
      );

      if (isUpdateMode.value) {
        if (userType == UserTypesEnum.regularUser) {
          await updateProfileUser(profileUser);
          await sessionManager.updateSessionForProfile(
              userName:
                  '${profileUser.personalInfo.firstName} ${profileUser.personalInfo.middleName ?? ''} ${profileUser.personalInfo.lastName ?? ''}',
              timeZone: profileUser.timeZoneId,
              imageProfile: profileUser.personalInfo.profilePicture ?? '');
          Get.back(closeOverlays: true);
        } else {
          CustomToast.show(
              message: 'Can not update $userType account from mobile app',
              type: ToastType.error);
        }
      } else {
        if (userType == UserTypesEnum.regularUser) {
          var createdProfile = await insertProfileUser(profileUser);

          await sessionManager.registerSessionForProfile(
              userName:
                  '${profileUser.personalInfo.firstName} ${profileUser.personalInfo.middleName ?? ''} ${profileUser.personalInfo.lastName ?? ''}',
              timeZone: profileUser.timeZoneId,
              phoneNumber: await sessionManager
                  .getSessionBy(SessionManagerType.phoneNumber),
              imageProfile: profileUser.personalInfo.profilePicture ?? '',
              referralCode: createdProfile.data.referral.referralCode);

          if (await sessionManager.getSessionBy(SessionManagerType.userType) ==
              'regularUser') {
            Get.offAllNamed(Routes.REG_MOTORCYCLE);
          } else {
            Get.offAllNamed(Routes.DASHBOARD);
          }
        } else {
          CustomToast.show(
              message: 'Can not update $userType account from mobile app',
              type: ToastType.error);
        }
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
          message: "Oops, An unexpected error has occured",
          type: ToastType.error,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    referenceCodeController.dispose();
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    dateOfBirthController.dispose();
    genderController.dispose();
    addressController.dispose();
    posCodeController.dispose();
    countryController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
