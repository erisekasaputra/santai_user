import 'package:get/get.dart';
import 'package:santai/app/data/repositories/authentikasi/auth_repository_impl.dart';
import 'package:santai/app/data/datasources/authentikasi/auth_remote_data_source.dart';
import 'package:santai/app/domain/repository/authentikasi/auth_repository.dart';

import 'package:santai/app/domain/usecases/authentikasi/send_otp.dart';
import 'package:santai/app/domain/usecases/authentikasi/otp_verify_register.dart';
import 'package:santai/app/domain/usecases/authentikasi/verify_login.dart';

import '../controllers/register_otp_controller.dart';
import 'package:http/http.dart' as http;
class RegisterOtpBinding extends Bindings {
  @override
  // void dependencies() {
  //   Get.lazyPut<RegisterOtpController>(
  //     () => RegisterOtpController(),
  //   );
  // }

   void dependencies() {
    Get.lazyPut<http.Client>(() => http.Client());

    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: Get.find<http.Client>()),
    );

    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: Get.find<AuthRemoteDataSource>()),
    );


    Get.lazyPut(() => SendOtp(Get.find<AuthRepository>()));
    Get.lazyPut(() => VerifyOtpRegister(Get.find<AuthRepository>()));
    Get.lazyPut(() => LoginVerify(Get.find<AuthRepository>()));

    Get.lazyPut<RegisterOtpController>(
      () => RegisterOtpController(
        sendOtp: Get.find<SendOtp>(),
        otpRegisterVerify: Get.find<VerifyOtpRegister>(),
        verifyLogin: Get.find<LoginVerify>(),
      )
    );
  }
}