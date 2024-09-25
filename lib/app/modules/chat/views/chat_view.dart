import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:santai/app/theme/app_theme.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
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
            Obx(() => CircleAvatar(
                  backgroundImage: controller.otherUser.value?.imageUrl != null
                      ? NetworkImage(controller.otherUser.value!.imageUrl!)
                      : null,
                )),
            const SizedBox(width: 10),
            Obx(() => Text(
                  controller.otherUser.value?.firstName ?? 'User',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
          ],
        ),
        leadingWidth: 900,
        actions: [
          IconButton(
            icon: Icon(Icons.call, color: primary_300, size: 30,),
            onPressed: () {},
          ),
        ],
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
              primaryColor: Colors.white,
              secondaryColor: Colors.white,
              bubbleMargin: const EdgeInsets.all(10),

              inputBackgroundColor: Colors.white,
              inputTextColor: Colors.black,
              inputTextCursorColor: Colors.black,
              inputTextDecoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                contentPadding: const EdgeInsets.all(8),
                hintStyle: const TextStyle(color: Colors.black),
              ),
              sentMessageBodyTextStyle: const TextStyle(color: Colors.black, fontSize: 16),
              receivedMessageBodyTextStyle: const TextStyle(color: Colors.black, fontSize: 16),
              userAvatarNameColors: [Colors.white],
              userNameTextStyle: const TextStyle(color: Colors.white),
            ),

            // customMessageBuilder: (message, {required messageWidth}) {
            //   final isCurrentUser =
            //       message.author.id == controller.user.value!.id;
            //   final previousMessage = controller.getPreviousMessage(message);
            //   final showDateSeparator =
            //       controller.shouldShowDateSeparator(message, previousMessage);

            //   return Column(
            //     children: [
            //       if (showDateSeparator)
            //         Padding(
            //           padding: const EdgeInsets.symmetric(vertical: 16),
            //           child: Text(
            //             controller.formatDate(message.createdAt!),
            //             style: TextStyle(color: Colors.grey, fontSize: 14),
            //           ),
            //         ),
            //       Column(
            //         crossAxisAlignment: isCurrentUser
            //             ? CrossAxisAlignment.end
            //             : CrossAxisAlignment.start,
            //         children: [
            //           Container(
            //             decoration: BoxDecoration(
            //               color:
            //                   isCurrentUser ? Colors.black : Colors.grey[800],
            //               borderRadius: BorderRadius.circular(8),
            //             ),
            //             padding: EdgeInsets.all(8),
            //             child: Text(
            //               message.toJson()['text'] as String,
            //               style: TextStyle(color: Colors.white, fontSize: 18),
            //             ),
            //           ),
            //           SizedBox(height: 4),
            //           Text(
            //             controller.formatTime(message.createdAt!),
            //             style: TextStyle(color: Colors.grey, fontSize: 12),
            //           ),
            //         ],
            //       ),
            //     ],
            //   );
            // },
          )),
    );
  }
}
