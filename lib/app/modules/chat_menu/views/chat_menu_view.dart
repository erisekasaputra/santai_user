import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_menu_controller.dart';

class ChatMenuView extends GetView<ChatMenuController> {
  const ChatMenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Obx(() => controller.isNotificationTab.value ? const SizedBox.shrink() : _buildSearchBar()),
            SizedBox(height: 16),
            _buildTabButtons(),
            SizedBox(height: 16),
            Obx(() => controller.isNotificationTab.value ? _buildNotificationList() : _buildChatList()),
            _buildEndOfMessage(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
      ),
      title: Obx(() => Text(
        controller.isNotificationTab.value ? 'Notification' : 'Inbox',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      )),
      centerTitle: true,
      elevation: 0,
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: controller.updateSearchQuery,
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildTabButtons() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Obx(() => ElevatedButton(
              onPressed: () => controller.toggleTab(false),
              child: Text('Chat Logs'),
              style: ElevatedButton.styleFrom(
                foregroundColor: controller.isNotificationTab.value ? Colors.grey : Colors.black,
                backgroundColor: controller.isNotificationTab.value ? Colors.white : Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )),
          ),
        ),
        Expanded(
          child: Obx(() => ElevatedButton(
            onPressed: () => controller.toggleTab(true),
            child: Text('Notifications'),
            style: ElevatedButton.styleFrom(
              foregroundColor: controller.isNotificationTab.value ? Colors.black : Colors.grey,
              backgroundColor: controller.isNotificationTab.value ? Colors.grey[300] : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )),
        ),
      ],
    );
  }

  Widget _buildNotificationList() {
    return Expanded(
      child: ListView.separated(
        itemCount: controller.notifications.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[300]),
        itemBuilder: (context, index) {
          final notification = controller.notifications[index];
          return ListTile(
            leading: const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white, size: 40),
            ),
            title: Text(notification.message,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),),
            subtitle: Text(notification.sender.isNotEmpty ? 'from ${notification.sender}' : ''),
            trailing: Text(notification.time),
          );
        },
      ),
    );
  }

  Widget _buildChatList() {
    return Expanded(
      child: Obx(() => ListView.separated(
        itemCount: controller.filteredChatLogs.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[300]),
        itemBuilder: (context, index) {
          final chat = controller.filteredChatLogs[index];
          return _buildChatListItem(chat);
        },
      )),
    );
  }

  Widget _buildChatListItem(ChatLog chat) {
    bool isExpired = chat.time.toLowerCase() == 'expired';
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white, size: 40),
        ),
        title: Text(chat.name,
              style: TextStyle(
                color: isExpired ? Colors.grey : Colors.black,
                fontWeight: FontWeight.bold,
              ),),
        subtitle: Text(chat.lastMessage, 
                style: TextStyle(
                color: isExpired ? Colors.grey : Colors.black,
              ),),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (chat.unreadCount > 0)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  chat.unreadCount.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            SizedBox(height: 4), // Add some space between unread count and time
            Text(
              chat.time,
              style: TextStyle(
                color: isExpired ? Colors.grey : Colors.black,
              ),
            ),
          ],
        ),
        onTap: () => controller.openChat(chat),
      ),
    );
  }

  Widget _buildEndOfMessage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(() => Text(
        controller.isNotificationTab.value
            ? 'You have reached the end of the notification'
            : 'You have reached the end of the chat'
      )),
    );
  }
}