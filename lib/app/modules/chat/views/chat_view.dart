import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:santai/app/theme/app_theme.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            height: 1.0,
            color: borderColor,
          ),
        ),
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 10),
            Obx(
              () => CircleAvatar(
                backgroundImage: controller.commonImageUrl.isNotEmpty &&
                        controller.he.value?.imageUrl != null &&
                        controller.he.value!.imageUrl!.isNotEmpty
                    ? Image.network(
                            '${controller.commonImageUrl.value}${controller.he.value!.imageUrl}')
                        .image
                    : null,
                child: controller.commonImageUrl.isNotEmpty &&
                        controller.he.value?.imageUrl != null &&
                        controller.he.value!.imageUrl!.isNotEmpty
                    ? null
                    : const Icon(
                        Icons.person,
                        size: 35,
                        color: Colors.white,
                      ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Obx(
                () => Text(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  controller.he.value?.firstName ?? 'User',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
        leadingWidth: 900,
        actions: const [
          // IconButton(
          //   icon: Icon(
          //     Icons.call,
          //     color: primary_300,
          //     size: 30,
          //   ),
          //   onPressed: () {},
          // ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value || controller.me.value == null) {
          return const SizedBox.shrink();
        }

        return Chat(
          messages: controller.chatService?.messages
                  .map((element) => controller.convertToTextMessage(element))
                  .toList() ??
              [],
          onSendPressed: controller.handleSendPressed,
          user: controller.me.value!,
          theme: DefaultChatTheme(
            backgroundColor: Colors.grey.shade100,
            messageBorderRadius: 8,
            messageInsetsHorizontal: 12,
            messageInsetsVertical: 8,
            primaryColor: Colors.blue.shade400,
            secondaryColor: Colors.grey.shade300,
            bubbleMargin:
                const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            inputBackgroundColor: Colors.white,
            inputTextColor: Colors.black,
            inputTextCursorColor: Colors.blue.shade400,
            inputTextDecoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              hintText: 'Type your message...',
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              filled: true,
              fillColor: Colors.grey.shade200,
            ),
            sentMessageBodyTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.normal,
            ),
            receivedMessageBodyTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.normal,
            ),
            userAvatarNameColors: [
              Colors.blue.shade400,
              Colors.green.shade400,
              Colors.orange.shade400,
            ],
            userNameTextStyle: const TextStyle(
              color: Colors.blueGrey,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
        );
      }),
    );
  }
}
