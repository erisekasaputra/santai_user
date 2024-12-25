import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/data/models/notification/notification_res_model.dart';
import 'package:santai/app/domain/entities/notification/notify.dart';
import 'package:santai/app/domain/usecases/chat/get_chat_contacts.dart';
import 'package:santai/app/domain/usecases/notification/get_notifications.dart';
import 'package:santai/app/exceptions/custom_http_exception.dart';
import 'package:santai/app/helpers/notification_sqlite.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/services/signal_r_service.dart';
import 'package:santai/app/utils/custom_date_extension.dart';
import 'package:santai/app/utils/http_error_handler.dart';
import 'package:santai/app/utils/logout_helper.dart';
import 'package:santai/app/utils/session_manager.dart';

class ChatMenuController extends GetxController {
  final isNotificationLoading = false.obs;
  final Logout logout = Logout();
  final SessionManager sessionManager = SessionManager();
  final SignalRService? chatService =
      Get.isRegistered<SignalRService>() ? Get.find<SignalRService>() : null;
  final notificationDb = NotificationSqlite.instance;
  final notifications = <Notify>[].obs;
  final isNotificationTab = false.obs;
  final timezone = ''.obs;
  final GetChatContactsByUserId getChatContacts;
  final GetNotifications getNotification;

  final lastNotificationTimestamp = 0.obs;

  final globalImageUrl = ''.obs;

  ChatMenuController(
      {required this.getChatContacts, required this.getNotification});

  @override
  void onInit() async {
    super.onInit();
    if (chatService == null) {
      Get.offAllNamed(Routes.SPLASH_SCREEN);
      return;
    }
    timezone.value =
        await sessionManager.getSessionBy(SessionManagerType.timeZone);
    globalImageUrl.value =
        await sessionManager.getSessionBy(SessionManagerType.commonFileUrl);
    chatService!.contacts.clear();
    await loadChatData();
    debounce(chatService!.forceRefresh, (value) async {
      chatService!.contacts.clear();
      await loadChatData();
    }, time: const Duration(seconds: 1));
    await chatService!.initializeConnection();
  }

  Future loadChatData() async {
    if (chatService == null) {
      Get.offAllNamed(Routes.SPLASH_SCREEN);
      return;
    }
    try {
      var chatContacts = await getChatContacts();
      if (chatContacts != null && chatContacts.isNotEmpty) {
        for (var chatContact in chatContacts) {
          var indexExisting = chatService!.contacts
              .indexWhere((element) => element.orderId == chatContact.orderId);
          if (indexExisting != -1) {
            chatService!.contacts[indexExisting].mechanicId.value =
                (chatContact.mechanicId ?? '');
            chatService!.contacts[indexExisting].mechanicName.value =
                (chatContact.mechanicName ?? '');
            chatService!.contacts[indexExisting].mechanicImageUrl.value =
                (chatContact.mechanicImageUrl ?? '');
            chatService!.contacts[indexExisting].lastChatText.value =
                (chatContact.lastChatText ?? '');
            chatService!.contacts[indexExisting].isOrderCompleted =
                chatContact.isOrderCompleted;
            chatService!.contacts[indexExisting].chatUpdateTimestamp =
                chatContact.chatUpdateTimestamp;
            chatService!.contacts[indexExisting].isChatExpired.value =
                chatContact.isChatExpired;
            return;
          }

          chatService!.contacts.add(
            ChatContactResponse(
              orderId: chatContact.orderId,
              lastChatTimestamp: chatContact.lastChatTimestamp,
              buyerId: chatContact.buyerId.obs,
              buyerName: chatContact.buyerName.obs,
              buyerImageUrl: chatContact.buyerImageUrl.obs,
              mechanicId: (chatContact.mechanicId ?? '').obs,
              mechanicName: (chatContact.mechanicName ?? '').obs,
              mechanicImageUrl: (chatContact.mechanicImageUrl ?? '').obs,
              lastChatText: (chatContact.lastChatText ?? '').obs,
              chatOriginUserId: chatContact.chatOriginUserId ?? '',
              isOrderCompleted: chatContact.isOrderCompleted,
              chatUpdateTimestamp: chatContact.chatUpdateTimestamp,
              isChatExpired: chatContact.isChatExpired.obs,
              orderChatExpiredAtUtc:
                  chatContact.orderChatExpiredAtUtc.toString(),
              orderCompletedAtUtc: chatContact.orderCompletedAtUtc.toString(),
            ),
          );
        }
        chatService!.contacts.refresh();
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
    }
  }

  void toggleTab(bool isNotification) async {
    isNotificationTab.value = isNotification;

    if (isNotificationTab.value) {
      await fetchNotifications();
    }
  }

  Future<void> fetchNotifications() async {
    try {
      isNotificationLoading.value = true;
      var userId = await sessionManager.getSessionBy(SessionManagerType.userId);
      if (userId.isEmpty) {
        return;
      }

      var localNotifications =
          await notificationDb.getNotificationsByUserId(userId);

      if (localNotifications.isNotEmpty) {
        for (var localNotification in localNotifications) {
          if (notifications.indexWhere((element) =>
                  element.notificationId == localNotification.notificationId) ==
              -1) {
            notifications.insert(0, localNotification);
          }
        }
        lastNotificationTimestamp.value = notifications.last.timestamp;
      }
      notifications.refresh();
      NotifyResponseModel? notificationsData;

      do {
        notificationsData =
            await getNotification(lastNotificationTimestamp.value);

        if (notificationsData != null) {
          for (var notificationData in notificationsData.data) {
            if (!await notificationDb.anyNotificationByNotificationId(
                notificationData.notificationId)) {
              await notificationDb.insertNotification(notificationData);
            }

            if (notifications.indexWhere((element) =>
                    element.notificationId ==
                    notificationData.notificationId) ==
                -1) {
              notifications.insert(0, notificationData);
            }
          }
          lastNotificationTimestamp.value =
              notificationsData.data.last.timestamp;
          notifications.refresh();
        }
      } while (notificationsData != null && notificationsData.data.isNotEmpty);
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
      isNotificationLoading.value = false;
    }
  }

  DateTime miliEpochToDate(int timestamp) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);

    if (timezone.value.isEmpty) {
      throw Exception('Time zone has not been set');
    }

    return dateTime.utcToLocal(timezone.value);
  }

  void openChat(ChatContactResponse chat) {
    if (chat.isChatExpired.value) {
      return;
    }

    Get.toNamed(Routes.CHAT, arguments: {
      'orderId': chat.orderId,
      'buyerId': chat.buyerId,
      'mechanicId': chat.mechanicId,
      'mechanicName': chat.mechanicName,
      'mechanicImageUrl': chat.mechanicImageUrl,
    });
  }
}
