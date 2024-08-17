import 'package:get/get.dart';

import '../modules/checkout/bindings/checkout_binding.dart';
import '../modules/checkout/views/checkout_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/detail_product/bindings/detail_product_binding.dart';
import '../modules/detail_product/views/detail_product_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/motorcycle_detail/bindings/motorcycle_detail_binding.dart';
import '../modules/motorcycle_detail/views/motorcycle_detail_view.dart';
import '../modules/motorcycle_information/bindings/motorcycle_information_binding.dart';
import '../modules/motorcycle_information/views/motorcycle_information_view.dart';
import '../modules/payment/bindings/payment_binding.dart';
import '../modules/payment/views/payment_view.dart';
import '../modules/reg_motorcycle/bindings/reg_motorcycle_binding.dart';
import '../modules/reg_motorcycle/views/reg_motorcycle_view.dart';
import '../modules/reg_user_profile/bindings/reg_user_profile_binding.dart';
import '../modules/reg_user_profile/views/reg_user_profile_view.dart';
import '../modules/register_otp/bindings/register_otp_binding.dart';
import '../modules/register_otp/views/register_otp_view.dart';
import '../modules/service_detail/bindings/service_detail_binding.dart';
import '../modules/service_detail/views/service_detail_view.dart';
import '../modules/service_now/bindings/service_now_binding.dart';
import '../modules/service_now/views/service_now_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/sign_up/bindings/sign_up_binding.dart';
import '../modules/sign_up/views/sign_up_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER_OTP,
      page: () => const RegisterOtpView(),
      binding: RegisterOtpBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: _Paths.REG_USER_PROFILE,
      page: () => const RegUserProfileView(),
      binding: RegUserProfileBinding(),
    ),
    GetPage(
      name: _Paths.REG_MOTORCYCLE,
      page: () => const RegMotorcycleView(),
      binding: RegMotorcycleBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.SERVICE_NOW,
      page: () => const ServiceNowView(),
      binding: ServiceNowBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_PRODUCT,
      page: () => const DetailProductView(),
      binding: DetailProductBinding(),
    ),
    GetPage(
      name: _Paths.CHECKOUT,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => const PaymentView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.MOTORCYCLE_DETAIL,
      page: () => const MotorcycleDetailView(),
      binding: MotorcycleDetailBinding(),
    ),
    GetPage(
      name: _Paths.MOTORCYCLE_INFORMATION,
      page: () => const MotorcycleInformationView(),
      binding: MotorcycleInformationBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: _Paths.SERVICE_DETAIL,
      page: () => const ServiceDetailView(),
      binding: ServiceDetailBinding(),
    ),
  ];
}
