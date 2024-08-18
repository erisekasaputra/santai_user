import 'package:get/get.dart';
import 'package:santai/app/routes/app_pages.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatLog {
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;

  ChatLog({required this.name, required this.lastMessage, required this.time, required this.unreadCount});
}

class Notification {
  final String message;
  final String sender;
  final String time;

  Notification({required this.message, required this.sender, required this.time});
}

class ChatMenuController extends GetxController {
   final chatLogs = <ChatLog>[].obs;
  final notifications = <Notification>[].obs;
  final filteredChatLogs = <ChatLog>[].obs;
  final searchQuery = ''.obs;
  final isNotificationTab = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyData();
    filteredChatLogs.assignAll(chatLogs);
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    filterChatLogs();
  }

  void filterChatLogs() {
    if (searchQuery.isEmpty) {
      filteredChatLogs.assignAll(chatLogs);
    } else {
      filteredChatLogs.assignAll(chatLogs.where((chat) =>
          chat.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          chat.lastMessage.toLowerCase().contains(searchQuery.toLowerCase())));
    }
  }

  void loadDummyData() {
    chatLogs.addAll([
      ChatLog(name: 'Zara Zainuddin', lastMessage: 'Hello, saya sudah sampai di lokasi. Thank You', time: '09.41', unreadCount: 2),
      ChatLog(name: 'Agent Yasmine', lastMessage: 'Sorry for the unpleasant experience. I would like to give you a 10% off your next order', time: '09.41', unreadCount: 1),
      ChatLog(name: 'Haikal Amir', lastMessage: 'Job is completed. Please rate my service 🙏 Thank You', time: 'Expired', unreadCount: 3),
      ChatLog(name: 'Hakim Abd Ghani', lastMessage: 'Job is completed 👍. Thank You for choosing us 🙏. Please rate my service.', time: 'Expired', unreadCount: 0),
    ]);

    notifications.addAll([
      Notification(message: 'Hello, saya sudah sampai di lokasi. Thank You', sender: 'Zara Zainuddin', time: '09.41'),
      Notification(message: 'Your new payment method has been added succesfully', sender: '', time: '09.41'),
      Notification(message: 'Your received a payment of \$250.00', sender: 'Haikal Amir', time: '09.41'),
      Notification(message: 'requested a payment of RM 300.000', sender: 'Hakim Abd Ghani', time: '09.41'),
    ]);
  }

  void toggleTab(bool isNotification) {
    isNotificationTab.value = isNotification;
  }

  void openChat(ChatLog chat) {
    // Implement chat opening logic here
    print('Opening chat with ${chat.name}');
    Get.toNamed(Routes.CHAT);
  }
}