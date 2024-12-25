import 'package:get/get.dart';
import 'package:santai/app/data/datasources/profile/profile_remote_data_source.dart';
import 'package:santai/app/data/repositories/authentikasi/auth_repository_impl.dart';
import 'package:santai/app/data/datasources/authentikasi/auth_remote_data_source.dart';
import 'package:santai/app/data/repositories/profile/profile_repository_impl.dart';
import 'package:santai/app/domain/repository/authentikasi/auth_repository.dart';
import 'package:santai/app/domain/repository/profile/profile_repository.dart';

import 'package:santai/app/domain/usecases/authentikasi/send_otp.dart';
import 'package:santai/app/domain/usecases/authentikasi/otp_verify_register.dart';
import 'package:santai/app/domain/usecases/authentikasi/verify_login.dart';
import 'package:santai/app/domain/usecases/profile/get_business_profile_user.dart';
import 'package:santai/app/domain/usecases/profile/get_profile_user.dart';
import 'package:santai/app/domain/usecases/profile/get_staff_profile_user.dart';
import 'package:santai/app/services/auth_http_client.dart';
import 'package:santai/app/services/secure_storage_service.dart';

import '../controllers/register_otp_controller.dart';
import 'package:http/http.dart' as http;

class RegisterOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.create<http.Client>(() => http.Client());
    Get.create<SecureStorageService>(() => SecureStorageService());
    Get.create<AuthHttpClient>(() => AuthHttpClient(
        Get.find<http.Client>(), Get.find<SecureStorageService>()));

    Get.create<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: Get.find<http.Client>()),
    );

    Get.create<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(client: Get.find<AuthHttpClient>()),
    );

    Get.create<AuthRepository>(
      () => AuthRepositoryImpl(
          remoteDataSource: Get.find<AuthRemoteDataSource>()),
    );

    Get.create<ProfileRepository>(
      () => ProfileRepositoryImpl(
          remoteDataSource: Get.find<ProfileRemoteDataSource>()),
    );

    Get.create(() => SendOtp(Get.find<AuthRepository>()));
    Get.create(() => VerifyOtpRegister(Get.find<AuthRepository>()));
    Get.create(() => LoginVerify(Get.find<AuthRepository>()));
    Get.create(() => UserGetProfile(Get.find<ProfileRepository>()));
    Get.create(() => GetBusinessProfileUser(Get.find<ProfileRepository>()));
    Get.create(() => GetStaffProfileUser(Get.find<ProfileRepository>()));

    Get.put(RegisterOtpController(
        sendOtp: Get.find<SendOtp>(),
        otpRegisterVerify: Get.find<VerifyOtpRegister>(),
        verifyLogin: Get.find<LoginVerify>(),
        getUserProfile: Get.find<UserGetProfile>(),
        getBusinessUser: Get.find<GetBusinessProfileUser>(),
        getStaffUser: Get.find<GetStaffProfileUser>()));
  }
}
