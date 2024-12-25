import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:santai/app/config/api_config.dart';
import 'package:http_parser/http_parser.dart';
import 'package:santai/app/utils/session_manager.dart';

class ImageUploadService extends GetxService {
  final SessionManager sessionManager = SessionManager();
  final String apiUrlPublic =
      '${ApiConfigUploadImage.baseUrl}/Files/images/public';

  Future<String> uploadImage(File imageFile) async {
    try {
      final accessToken =
          await sessionManager.getSessionBy(SessionManagerType.accessToken);

      if (accessToken.isEmpty) {
        throw Exception('Access token not found');
      }

      var request = http.MultipartRequest('POST', Uri.parse(apiUrlPublic));

      request.headers['Authorization'] = 'Bearer $accessToken';

      String fileExtension = imageFile.path.split('.').last.toLowerCase();

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
        return jsonResponse['data']['resourceName'];
      } else {
        throw Exception('Failed to upload image: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
}
