import 'package:get/get.dart';
import 'package:santai/app/domain/usecases/chat/get_chat_conversations.dart';
import '../controllers/chat_controller.dart';
import 'package:santai/app/data/datasources/chat/chat_remote_data_source.dart';
import 'package:santai/app/data/repositories/chat/chat_repository_impl.dart';
import 'package:santai/app/domain/repository/chat/chat_repository.dart';
import 'package:santai/app/services/auth_http_client.dart';
import 'package:santai/app/services/secure_storage_service.dart';
import 'package:http/http.dart' as http;

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    // Register the http client
    Get.create<http.Client>(() => http.Client());
    Get.create<SecureStorageService>(() => SecureStorageService());
    Get.create<AuthHttpClient>(() => AuthHttpClient(
        Get.find<http.Client>(), Get.find<SecureStorageService>()));

    Get.create<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(client: Get.find<AuthHttpClient>()),
    );

    Get.create<ChatRepository>(
      () => ChatRepositoryImpl(
          remoteDataSource: Get.find<ChatRemoteDataSource>()),
    );

    Get.create(() => GetChatConversationsByOrderId(Get.find<ChatRepository>()));

    Get.put<ChatController>(
      ChatController(
          getChatConversationByOrderId:
              Get.find<GetChatConversationsByOrderId>()),
    );
  }
}
