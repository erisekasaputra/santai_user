import '../../../domain/entities/authentikasi/otp_request.dart';
import '../../../domain/repository/authentikasi/auth_repository.dart';

class SendOtp {
  final AuthRepository repository;

  SendOtp(this.repository);

  Future<void> call(OtpRequest request) async {
    return await repository.sendOtp(request);
  }
}