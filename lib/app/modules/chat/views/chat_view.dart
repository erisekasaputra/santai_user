import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
           Obx(() => CircleAvatar(
              backgroundImage: controller.otherUser.value?.imageUrl != null
                ? NetworkImage(controller.otherUser.value!.imageUrl!)
                : null,
            )),
            SizedBox(width: 10),
            Obx(() => Text(
              controller.otherUser.value?.firstName ?? 'User',
              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            )),
          ],
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.more_vert, color: Colors.black),
        //     onPressed: () {},
        //   ),
        // ],
      ),
            body: Obx(() => Chat(
              messages: controller.messages,
              onSendPressed: controller.handleSendPressed,
              user: controller.user.value!,
              theme: DefaultChatTheme(
                backgroundColor: Colors.white,
                messageBorderRadius: 8,
                messageInsetsHorizontal: 8,
                messageInsetsVertical: 4,
                primaryColor: Colors.black,
                secondaryColor: Colors.grey[800] ?? Colors.grey[800]!, 
                inputBackgroundColor: Colors.white,
                inputTextColor: Colors.black,
                inputTextCursorColor: Colors.black,
                inputTextDecoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  contentPadding: EdgeInsets.all(8),
                  hintStyle: TextStyle(color: Colors.black),
                ),
                sentMessageBodyTextStyle: TextStyle(color: Colors.white, fontSize: 18),
                receivedMessageBodyTextStyle: TextStyle(color: Colors.white, fontSize: 18),
                userAvatarNameColors: [Colors.white],
                userNameTextStyle: TextStyle(color: Colors.white),
              ),
              customMessageBuilder: (message, {required messageWidth}) {
                final isCurrentUser = message.author.id == controller.user.value!.id;
                final previousMessage = controller.getPreviousMessage(message);
                final showDateSeparator = controller.shouldShowDateSeparator(message, previousMessage);

                return Column(
                  children: [
                    if (showDateSeparator)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          controller.formatDate(message.createdAt!),
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                    Column(
                      crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: isCurrentUser ? Colors.black : Colors.grey[800],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Text(
                            message.toJson()['text'] as String,
                            style: TextStyle(color: Colors.white, fontSize: 18), 
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          controller.formatTime(message.createdAt!),
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                );
              },
            )),
    );
  }
}