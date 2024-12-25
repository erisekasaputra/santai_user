import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/domain/enumerations/user_types_enum.dart';
import 'package:santai/app/domain/usecases/common/common_get_img_url_public.dart';
import 'package:santai/app/domain/usecases/profile/get_business_profile_user.dart';
import 'package:santai/app/domain/usecases/profile/get_profile_user.dart';
import 'package:santai/app/domain/usecases/profile/get_staff_profile_user.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/controllers/device_info_controller.dart';
import 'package:santai/app/services/timezone_service.dart';
import 'package:santai/app/utils/logout_helper.dart';
import 'package:santai/app/utils/session_manager.dart';

class SplashScreenController extends GetxController {
  final Logout logout = Logout();
  final DeviceInfoController deviceInfoController =
      Get.find<DeviceInfoController>();
  final TimezoneService timezoneService = TimezoneService();

  final SessionManager sessionManager = SessionManager();
  final CommonGetImgUrlPublic commonGetImgUrlPublic;
  final UserGetProfile getUserProfile;
  final GetBusinessProfileUser getBusinessUserProfile;
  final GetStaffProfileUser getStaffUserProfile;

  SplashScreenController({
    required this.commonGetImgUrlPublic,
    required this.getUserProfile,
    required this.getBusinessUserProfile,
    required this.getStaffUserProfile,
  });

  @override
  void onInit() {
    super.onInit();
    initializeApp();
  }

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool connected = true;
    for (var connect in connectivityResult) {
      if (connect == ConnectivityResult.none) {
        connected = false;
      }
    }
    return connected;
  }

  Future<void> initializeApp() async {
    if (await _checkInternetConnection()) {
      try {
        final response = await commonGetImgUrlPublic();

        await sessionManager.setSessionBy(
            SessionManagerType.commonFileUrl, response.data.url);

        String accessToken =
            await sessionManager.getSessionBy(SessionManagerType.accessToken);
        String userId =
            await sessionManager.getSessionBy(SessionManagerType.userId);
        String userType =
            await sessionManager.getSessionBy(SessionManagerType.userType);

        if (accessToken.isEmpty || userId.isEmpty || userType.isEmpty) {
          Get.offAllNamed(Routes.LOGIN);
          return;
        }

        if (userType == UserTypesEnum.regularUser) {
          var userProfile = await getUserProfile(userId);
          if (userProfile == null) {
            Get.offAllNamed(Routes.REG_USER_PROFILE);
            return;
          }

          await sessionManager.registerSessionForProfile(
            userName:
                '${userProfile.data.personalInfo.firstName} ${userProfile.data.personalInfo.middleName ?? ''} ${userProfile.data.personalInfo.lastName ?? ''}',
            timeZone: userProfile.data.timeZoneId,
            phoneNumber: userProfile.data.phoneNumber,
            imageProfile: userProfile.data.personalInfo.profilePicture ?? '',
            referralCode: userProfile.data.referral.referralCode,
          );
          Get.offAllNamed(Routes.DASHBOARD);
          return;
        }

        if (userType == UserTypesEnum.businessUser) {
          var businessUser = await getBusinessUserProfile(userId);
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

          Get.offAllNamed(Routes.DASHBOARD);
          return;
        }

        if (userType == UserTypesEnum.staffUser) {
          var staffUser = await getStaffUserProfile(userId);
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

          Get.offAllNamed(Routes.DASHBOARD);
          return;
        }

        Get.offAllNamed(Routes.LOGIN);
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
            message: "An unexpected error occurred ",
            type: ToastType.error,
          );
        }
      }
    } else {
      CustomToast.show(
        message: "No internet connection. Please check your network.",
        type: ToastType.error,
      );
    }
  }
}
