import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:santai/app/services/secure_storage_service.dart';
import 'package:get/get.dart';
import 'package:santai/app/config/api_config.dart';
import 'package:http_parser/http_parser.dart';

class ImageUploadService extends GetxService {
  final String apiUrlPublic = '${ApiConfigUploadImage.baseUrl}/Files/images/public';
  final SecureStorageService _secureStorage = Get.find<SecureStorageService>();

  Future<String> uploadImage(File imageFile) async {
    try {
      final accessToken = await _secureStorage.readSecureData('access_token');

      if (accessToken == null) {
        throw Exception('Access token not found');
      }

      var request = http.MultipartRequest('POST', Uri.parse(apiUrlPublic));

      request.headers['Authorization'] = 'Bearer $accessToken';

      // Get the file extension
      String fileExtension = imageFile.path.split('.').last.toLowerCase();

      // Set the correct MIME type based on the file extension
      String mimeType;
      switch (fileExtension) {
        case 'jpg':
        case 'jpeg':
          mimeType = 'image/jpeg';
          break;
        case 'png':
          mimeType = 'image/png';
          break;
        case 'gif':
          mimeType = 'image/gif';
          break;
        default:
          throw Exception('Unsupported image format');
      }

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType.parse(mimeType),
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var jsonResponse = json.decode(response.body);
        return jsonResponse['resourceName'];
      } else {
        throw Exception('Failed to upload image: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
}
