import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/domain/usecases/chat/get_chat_conversations.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/helpers/conversation_sqlite.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/services/signal_r_service.dart';
import 'package:santai/app/utils/http_error_handler.dart';
import 'package:santai/app/utils/logout_helper.dart';
import 'package:santai/app/utils/session_manager.dart';

class ChatController extends GetxController {
  final isLoading = false.obs;
  final Logout logout = Logout();
  final conversationDb = ConversationSqlite.instance;
  final SessionManager sessionManager = SessionManager();
  final SignalRService? chatService =
      Get.isRegistered<SignalRService>() ? Get.find<SignalRService>() : null;
  final me = Rx<types.User?>(null);
  final he = Rx<types.User?>(null);
  final lastTimestamp = 0.obs;

  final userId = ''.obs;
  final orderId = ''.obs;
  final mechanicId = ''.obs;
  final mechanicName = ''.obs;
  final mechanicImageUrl = ''.obs;

  final commonImageUrl = ''.obs;

  final GetChatConversationsByOrderId getChatConversationByOrderId;

  ChatController({required this.getChatConversationByOrderId});

  @override
  void onInit() async {
    super.onInit();
    await initializeChat();

    if (chatService == null) {
      Get.offAllNamed(Routes.SPLASH_SCREEN);
      return;
    }

    commonImageUrl.value =
        await sessionManager.getSessionBy(SessionManagerType.commonFileUrl);
    debounce(chatService!.contacts, (updatedContacts) {
      int indexFoundContact = chatService!.contacts
          .indexWhere((element) => element.orderId == orderId.value);
      bool isContactFound = indexFoundContact != -1;

      if (isContactFound) {
        mechanicId.value = chatService!
            .contacts[indexFoundContact].mechanicId.value
            .toString();

        mechanicName.value = chatService!
            .contacts[indexFoundContact].mechanicName.value
            .toString();

        mechanicImageUrl.value = chatService!
            .contacts[indexFoundContact].mechanicImageUrl.value
            .toString();

        he.value = types.User(
            id: mechanicId.value,
            firstName: mechanicName.isEmpty
                ? 'Discovering a Mechanic'
                : mechanicName.value,
            imageUrl: mechanicImageUrl.value);
      } else {
        mechanicId.value = '';
        mechanicName.value = '';
        mechanicImageUrl.value = '';

        if (Get.isOverlaysOpen) {
          Get.offAllNamed(Routes.DASHBOARD);
          CustomToast.show(
              message: 'Your order has already become invalid.',
              type: ToastType.error);
        }
      }
    }, time: const Duration(seconds: 1));
    await chatService!.initializeConnection();
  }

  Future<void> initializeChat() async {
    try {
      userId.value =
          await sessionManager.getSessionBy(SessionManagerType.userId);
      orderId.value = Get.arguments?['orderId'] ?? '';

      mechanicId.value = (Get.arguments?['mechanicId'] ?? '').toString();
      mechanicName.value = (Get.arguments?['mechanicName'] ?? '').toString();
      mechanicImageUrl.value =
          (Get.arguments?['mechanicImageUrl'] ?? '').toString();

      me.value = types.User(id: userId.value);
      he.value = types.User(
        id: mechanicId.value,
        firstName: mechanicName.value.isEmpty
            ? 'Discovering a Mechanic'
            : mechanicName.value,
        imageUrl: mechanicImageUrl.value,
      );

      await loadInitialMessages();

      he.refresh();
      me.refresh();
    } catch (e) {
      CustomToast.show(message: e.toString(), type: ToastType.error);
    }
  }

  Future<void> loadInitialMessages() async {
    try {
      if (chatService == null) {
        Get.offAllNamed(Routes.SPLASH_SCREEN);
        return;
      }
      isLoading.value = true;
      chatService!.messages.clear();

      var lastConversations =
          await conversationDb.getConversationsByOrderId(orderId.value);

      if (lastConversations.isNotEmpty) {
        lastTimestamp.value = lastConversations.last.timestamp;

        for (var storedConversation in lastConversations) {
          if (chatService!.messages.indexWhere((element) =>
                  element.messageId == storedConversation.messageId) ==
              -1) {
            chatService!.messages.insert(0, storedConversation);
          }
        }
      }

      chatService!.messages.refresh();
      var chatResults = await getChatConversationByOrderId(
          orderId.value, lastTimestamp.value, true);
      if (chatResults == null || chatResults.data.isEmpty) {
        return;
      }

      for (var conver in chatResults.data) {
        if (!await conversationDb
            .anyConversationByMessageId(conver.messageId)) {
          await conversationDb.insertConversation(ConversationResponse(
            messageId: conver.messageId,
            orderId: conver.orderId,
            originUserId: conver.originUserId,
            destinationUserId: conver.destinationUserId,
            text: conver.text,
            timestamp: conver.timestamp,
          ));
        }
        if (chatService!.messages
                .indexWhere((elemen) => elemen.messageId == conver.messageId) ==
            -1) {
          chatService!.messages.insert(
            0,
            ConversationResponse(
              messageId: conver.messageId,
              orderId: conver.orderId,
              originUserId: conver.originUserId,
              destinationUserId: conver.destinationUserId,
              text: conver.text,
              timestamp: conver.timestamp,
            ),
          );
        }
      }
    } catch (e) {
      if (e is CustomHttpException) {
        if (e.statusCode == 401) {
          await logout.doLogout();
          return;
        }

        if (e.errorResponse != null) {
          var messageError = parseErrorMessage(e.errorResponse!);
          CustomToast.show(
            message: '${e.message}$messageError',
            type: ToastType.error,
          );
          return;
        }

        CustomToast.show(message: e.message, type: ToastType.error);
        return;
      }
      CustomToast.show(
        message: "Uh-oh, there is an issue.",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void handleSendPressed(types.PartialText message) {
    try {
      if (chatService == null) {
        Get.offAllNamed(Routes.SPLASH_SCREEN);
        return;
      }

      if (orderId.value.isEmpty) {
        CustomToast.show(message: 'Invalid order id', type: ToastType.error);
        return;
      }

      if ((he.value?.id ?? '').isEmpty) {
        CustomToast.show(
            message: 'Mechanic has not been assigned', type: ToastType.error);
        return;
      }

      chatService!.sendMessage(orderId.value, he.value!.id, message.text,
          attachment: null, // Add other attachments if required
          replyMessageId: null, // Add reply message ID if replying
          replyMessageText: null // Add reply message text if replying
          );
    } catch (e) {
      CustomToast.show(
          message: 'Failed to send message. Please try again shortly.',
          type: ToastType.error);
    }
  }

  final RegExp emojiRegex = RegExp(
    r'(\uD83D[\uDC00-\uDFFF]|\uD83C[\uD000-\uDFFF]|\uFFFD|[\u2600-\u27BF])', // Emoji Unicode
  );

  types.TextMessage convertToTextMessage(ConversationResponse response) {
    return types.TextMessage(
      id: response.messageId,
      author: types.User(id: response.originUserId),
      text: response.text,
      createdAt: response.timestamp,
      metadata: {
        'orderId': response.orderId,
        'destinationUserId': response.destinationUserId,
        'attachment': response.attachment,
        'replyMessageId': response.replyMessageId,
        'replyMessageText': response.replyMessageText,
      },
    );
  }

  String formatDateTime(int? milliseconds) {
    if (milliseconds == null) return '';
    final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  bool shouldShowDateSeparator(
      types.Message message, types.Message? previousMessage) {
    if (previousMessage == null) return true;
    final messageDate = DateTime.fromMillisecondsSinceEpoch(message.createdAt!);
    final previousMessageDate =
        DateTime.fromMillisecondsSinceEpoch(previousMessage.createdAt!);
    return !isSameDay(messageDate, previousMessageDate);
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
