import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';
import 'package:santai/app/services/signal_r_service.dart';

class ChatController extends GetxController {
  final SignalRService _signalRService = Get.find<SignalRService>();
  final messages = <types.Message>[].obs;
  final user = Rx<types.User?>(null);
  final otherUser = Rx<types.User?>(null);

  @override
  void onInit() {
    super.onInit();
    user.value = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
    otherUser.value = const types.User(
      id: 'pang-liquan',
      firstName: 'Pang Liquan',
      imageUrl: 'https://picsum.photos/200/200',
    );
    _initializeSignalR();
    _signalRService.messages.listen((newMessages) {
      _addNewMessages(newMessages);
    });
  }

  Future<void> _initializeSignalR() async {
    await _signalRService.initializeConnection('YOUR_SIGNALR_HUB_URL');
  }

  void _addNewMessages(List<String> newMessages) {
    for (var message in newMessages) {
      final textMessage = types.TextMessage(
        author: otherUser.value!,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: message,
      );
      messages.add(textMessage);
    }
    messages.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
  }

  void handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: user.value!,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    messages.add(textMessage);
    messages.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    _signalRService.sendMessage(message.text);
  }

  String formatDateTime(int? milliseconds) {
    if (milliseconds == null) return '';
    final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  types.Message? getPreviousMessage(types.Message message) {
    final index = messages.indexOf(message);
    if (index > 0) {
      return messages[index - 1];
    }
    return null;
  }

  bool shouldShowDateSeparator(types.Message message, types.Message? previousMessage) {
    if (previousMessage == null) return true;
    final messageDate = DateTime.fromMillisecondsSinceEpoch(message.createdAt!);
    final previousMessageDate = DateTime.fromMillisecondsSinceEpoch(previousMessage.createdAt!);
    return !isSameDay(messageDate, previousMessageDate);
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}