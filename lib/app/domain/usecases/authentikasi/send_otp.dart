import 'package:santai/app/domain/entities/authentikasi/otp_request.dart';
import 'package:santai/app/domain/entities/authentikasi/otp_request_res.dart';

import '../../../domain/repository/authentikasi/auth_repository.dart';

class SendOtp {
  final AuthRepository repository;

  SendOtp(this.repository);

  Future<OtpRequestResponse?> call(OtpRequest request) async {
    return await repository.sendOtp(request);
  }
}
