import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_back_button.dart';
import 'package:santai/app/theme/app_theme.dart';
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
            Obx(() => controller.isNotificationTab.value
                ? const SizedBox.shrink()
                : _buildSearchBar(context)),
            const SizedBox(height: 16),
            _buildTabButtons(context),
            const SizedBox(height: 16),
            Obx(() => controller.isNotificationTab.value
                ? _buildNotificationList(context)
                : _buildChatList(context)),
            _buildEndOfMessage(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 0, 8),
        child: CustomBackButton(
          onPressed: () => Get.back(),
        ),
      ),
      leadingWidth: 100,
      title: const Text(
        'Service Detail',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.button_text_01;
    return TextField(
      onChanged: controller.updateSearchQuery,
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: Icon(Icons.search, size: 30),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
      ),
    );
  }

  Widget _buildTabButtons(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Obx(() => ElevatedButton(
                  onPressed: () => controller.toggleTab(false),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: controller.isNotificationTab.value
                        ? Colors.black
                        : Colors.white,
                    backgroundColor: controller.isNotificationTab.value
                        ? Colors.white
                        : primary_300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: borderColor, width: 1),
                    ),
                  ),
                  child: Text('Chat Logs',
                      style: TextStyle(
                        color: controller.isNotificationTab.value
                            ? Colors.black
                            : Colors.white,
                      )),
                )),
          ),
        ),
        Expanded(
          child: Obx(() => ElevatedButton(
                onPressed: () => controller.toggleTab(true),
                style: ElevatedButton.styleFrom(
                  foregroundColor: controller.isNotificationTab.value
                      ? Colors.white
                      : Colors.black,
                  backgroundColor: controller.isNotificationTab.value
                      ? primary_300
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: borderColor, width: 1),
                  ),
                ),
                child: Text('Notifications',
                    style: TextStyle(
                      color: controller.isNotificationTab.value
                          ? Colors.white
                          : Colors.black,
                    )),
              )),
        ),
      ],
    );
  }

  Widget _buildNotificationList(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    return Expanded(
      child: ListView.separated(
        itemCount: controller.notifications.length,
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
          child: Divider(height: 1, color: borderColor),
        ),
        itemBuilder: (context, index) {
          final notification = controller.notifications[index];
          return ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/company_logo.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
            ),
            title: Text(
              notification.message,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            subtitle: Text(notification.sender.isNotEmpty
                ? 'from ${notification.sender}'
                : ''),
            trailing: Text(notification.time),
          );
        },
      ),
    );
  }

  Widget _buildChatList(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    return Expanded(
      child: Obx(() => ListView.separated(
            itemCount: controller.filteredChatLogs.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: borderColor),
            itemBuilder: (context, index) {
              final chat = controller.filteredChatLogs[index];
              return _buildChatListItem(context, chat);
            },
          )),
    );
  }

  Widget _buildChatListItem(BuildContext context, ChatLog chat) {
    final Color alert_300 = Theme.of(context).colorScheme.alert_300;
    bool isExpired = chat.time.toLowerCase() == 'expired';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
            radius: 35,
            backgroundImage:
                Image.network('https://picsum.photos/200/200').image),
        title: Text(
          chat.name,
          style: TextStyle(
            color: isExpired ? Colors.grey : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          chat.lastMessage,
          style: TextStyle(
            color: isExpired ? Colors.grey : Colors.black,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (chat.unreadCount > 0)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: alert_300,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  chat.unreadCount.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            const SizedBox(height: 4),
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
      child: Obx(() => Text(controller.isNotificationTab.value
          ? 'You have reached the end of the notification'
          : 'You have reached the end of the chat')),
    );
  }
}
