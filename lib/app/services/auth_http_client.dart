import 'package:http/http.dart' as http;
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'dart:convert';
import 'package:santai/app/services/secure_storage_service.dart';
import 'package:santai/app/config/api_config.dart';
import 'package:santai/app/utils/authorization_builder.dart';
import 'package:santai/app/utils/int_extension_method.dart';
import 'package:santai/app/utils/logout_helper.dart';
import 'package:santai/app/utils/session_manager.dart';

class AuthHttpClient extends http.BaseClient {
  final SessionManager sessionManager = SessionManager();
  final Logout logout = Logout();
  final http.Client _inner;
  final SecureStorageService secureStorage;

  AuthHttpClient(this._inner, this.secureStorage);
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    try {
      final accessToken =
          await sessionManager.getSessionBy(SessionManagerType.accessToken);
      final method = request.method;
      final url = request.url;
      final headers = Map<String, String>.from(request.headers); // Salin header
      headers['Authorization'] = buildBearerToken(accessToken);

      // Simpan body jika ada, untuk digunakan kembali nanti
      final bodyBytes =
          request is http.Request ? await request.finalize().toBytes() : null;

      // Buat request baru dengan header yang sudah diperbarui
      final newRequest = http.Request(method, url)..headers.addAll(headers);
      if (bodyBytes != null) {
        newRequest.bodyBytes = bodyBytes;
      }

      // Kirim request
      http.StreamedResponse response = await _inner.send(newRequest);

      // Jika status bukan 401, langsung kembalikan response
      if (response.statusCode != 401) {
        return response;
      }

      // Coba refresh token
      var (statusCode, newToken) = await _refreshToken();
      if (newToken != null) {
        // Perbarui header Authorization dengan token baru
        headers['Authorization'] = buildBearerToken(newToken);

        // Buat request baru untuk pengiriman ulang
        final newRequest2 = http.Request(method, url)..headers.addAll(headers);
        if (bodyBytes != null) {
          newRequest2.bodyBytes = bodyBytes;
        }

        // Kirim ulang request dengan token yang baru
        response = await _inner.send(newRequest2);

        if (response.statusCode == 401) {
          await logout.logoutSecureStorage();
        }
      }

      return response;
    } catch (e) {
      CustomToast.show(
        message: e.toString(),
        type: ToastType.info,
      );
      rethrow;
    }
  }

  Future<(int statusCode, String? token)> _refreshToken() async {
    final accessToken =
        await sessionManager.getSessionBy(SessionManagerType.accessToken);
    final refreshToken =
        await sessionManager.getSessionBy(SessionManagerType.refreshToken);
    final deviceId =
        await sessionManager.getSessionBy(SessionManagerType.deviceId);

    // Jika refresh token, device ID, atau access token tidak ada, maka kembalikan null
    if (refreshToken.isEmpty || deviceId.isEmpty || accessToken.isEmpty) {
      return (400, null);
    }

    try {
      final response = await _inner.post(
        Uri.parse('${ApiConfig.baseUrl}/Auth/refresh-token'),
        body: json.encode({
          'accessToken': accessToken,
          'refreshToken': refreshToken,
          'deviceId': deviceId
        }),
        headers: {'Content-Type': 'application/json'},
      );

      // Cek jika status HTTP sukses
      if (response.statusCode.isHttpResponseSuccess()) {
        final responseBody =
            response.body.isEmpty ? null : json.decode(response.body);
        final data = responseBody?['data'] as Map<String, dynamic>?;

        if (data == null ||
            data['token'] == null ||
            data['refreshToken'] == null) {
          return (400, null);
        }
        await sessionManager.setSessionBy(
            SessionManagerType.accessToken, data['token']);
        await sessionManager.setSessionBy(
            SessionManagerType.refreshToken, data['refreshToken']);
        return (200, data['token'] as String);
      }
    } catch (e) {
      if (e is CustomHttpException) {
        CustomToast.show(
          message: e.message,
          type: ToastType.error,
        );
        return (e.statusCode, null);
      }
      // Tampilkan pesan jika ada kesalahan lain saat mencoba refresh token
      CustomToast.show(
        message: "Internal server error has occured, please try again shortly.",
        type: ToastType.error,
      );
      return (500, null);
    }
    return (400, null);
  }
}
