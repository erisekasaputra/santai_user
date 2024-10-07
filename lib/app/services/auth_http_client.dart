import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:santai/app/services/secure_storage_service.dart';
import 'package:santai/app/config/api_config.dart';

class AuthHttpClient extends http.BaseClient {
  final http.Client _inner;
  final SecureStorageService _secureStorage;

  AuthHttpClient(this._inner, this._secureStorage);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    request.headers['Authorization'] = 'Bearer ${await _getAccessToken()}';

    var response = await _inner.send(request);

    if (response.statusCode == 401) {
      print('Token might be expired, try to refresh');
      // Token might be expired, try to refresh
      final newToken = await _refreshToken();
      print(newToken);
      if (newToken != null) {
        // Retry the request with the new token
        request.headers['Authorization'] = 'Bearer $newToken';
        return _inner.send(request);
      }
    }

    return response;
  }

  Future<String?> _getAccessToken() async {
    return await _secureStorage.readSecureData('access_token');
  }

  Future<String?> _refreshToken() async {
    final accessToken = await _getAccessToken();
    final refreshToken = await _secureStorage.readSecureData('refresh_token');
    final deviceId = await _secureStorage.readSecureData('fcm_token');

    print('accessToken: $accessToken');
    print('refreshToken: $refreshToken');
    print('deviceId: $deviceId');

    if (refreshToken == null || deviceId == null || accessToken == null) return null;

    try {
      print('masuk sini');
      final response = await _inner.post(
        Uri.parse('${ApiConfig.baseUrl}/Auth/refresh-token'),
        body: json.encode({
                            'accessToken': accessToken,
                            'refreshToken': refreshToken,
                            'deviceId': deviceId
                          }),
        headers: {'Content-Type': 'application/json'},
      );

      print("status code: ${response.statusCode}");
      print("body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _secureStorage.writeSecureData('access_token', data['token']);
        await _secureStorage.writeSecureData('refresh_token', data['refreshToken']);
        return data['token'];
      }
    } catch (e) {
      print('Error refreshing token: $e');
    }

    return null;
  }
}