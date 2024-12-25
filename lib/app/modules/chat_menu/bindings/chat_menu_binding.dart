import 'package:get/get.dart';
import 'package:santai/app/data/datasources/chat/chat_remote_data_source.dart';
import 'package:santai/app/data/datasources/notification/notification_remote_data_source.dart';
import 'package:santai/app/data/repositories/chat/chat_repository_impl.dart';
import 'package:santai/app/data/repositories/notification/notification_repository_impl.dart';
import 'package:santai/app/domain/repository/chat/chat_repository.dart';
import 'package:santai/app/domain/repository/notification/notification_repository.dart';
import 'package:santai/app/domain/usecases/chat/get_chat_contacts.dart';
import 'package:santai/app/domain/usecases/notification/get_notifications.dart';
import '../controllers/chat_menu_controller.dart';
import 'package:santai/app/services/auth_http_client.dart';
import 'package:santai/app/services/secure_storage_service.dart';
import 'package:http/http.dart' as http;

class ChatMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.create<http.Client>(() => http.Client());
    Get.create<SecureStorageService>(() => SecureStorageService());
    Get.create<AuthHttpClient>(() => AuthHttpClient(
        Get.find<http.Client>(), Get.find<SecureStorageService>()));

    Get.create<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(client: Get.find<AuthHttpClient>()),
    );
    Get.create<NotificationRemoteDataSource>(
      () =>
          NotificationRemoteDataSourceImpl(client: Get.find<AuthHttpClient>()),
    );

    Get.create<ChatRepository>(
      () => ChatRepositoryImpl(
          remoteDataSource: Get.find<ChatRemoteDataSource>()),
    );
    Get.create<NotificationRepository>(
      () => NotificationRepositoryImpl(
          remoteDataSource: Get.find<NotificationRemoteDataSource>()),
    );

    Get.create(() => GetChatContactsByUserId(Get.find<ChatRepository>()));
    Get.create(() => GetNotifications(Get.find<NotificationRepository>()));

    Get.put<ChatMenuController>(
      ChatMenuController(
          getChatContacts: Get.find<GetChatContactsByUserId>(),
          getNotification: Get.find<GetNotifications>()),
    );
  }
}
